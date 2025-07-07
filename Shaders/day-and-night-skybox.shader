Shader "DeltaField/skybox/day-and-night"
{
    Properties
    {
        [Header(Colors)][Space(16)]
        _SkyColor("Sky Color",Color)=(0.2,0.2,0.6,1.0)
        _SkyColor_Night("Night Color",Color)=(0.05,0.05,0.15,1.0)
        _HorizonColor("Horizon Color",Color)=(0.6,0.6,0.8,1.0)
        _UnderColor("Under Color",Color)=(0.4,0.4,0.4,1.0)
        [Space(16)]
        [Header(General)][Space(16)]
        _DayCycle("Day Cycle",Range(0.0,1.0))=0.0
        _Direction("Direction",Float)=0.0
        [Toggle(_LIGHT_BASED_DIRECTION)]
        _Light_Based_Direction("Light-Based Direction",Float)=0.0
        [Space(16)]
        [Header(Sunrise Sunset)][Space(16)]
        _SkyColor_Sun("Base Color",Color)=(1.0,0.55,0.0,1.0)
        _SkyColor_Sun_Core("Core Color",Color)=(0.95,0.58,0.0,1.0)
        _Sun_Effect_Range("Effect Range",Range(-1.0,1.0))=0.0
        [PowerSlider(12.0)]_Sun_Core_Compression("Core Color Compression",Range(1.0,16.0))=8.0
        [Space(16)]
        [Header(Sun)][Space(16)]
        [Toggle(_SUN_ADD)]
        _Enable_Sun("Activate Sun",Float)=0.0
        _Sun_Color("Sun Color",Color)=(1.0,1.0,0.95,1.0)
        [PowerSlider(4.00)]_Sun_Size("Size",Range(0.0,1.49))=0.03
        _Sun_Sharpness("Sharpness",Range(0.0,64.0))=10.0
    }
    SubShader
    {
        Tags { "RenderType"="Background" "Queue"="Background" "PreviewType"="Skybox" "LightMode"="ForwardBase"}
        ZWrite Off
        Pass{
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_local _ _SUN_ADD
            #pragma shader_feature_local _ _LIGHT_BASED_DIRECTION

            #include "UnityCG.cginc"

            fixed4 _SkyColor;
            fixed4 _HorizonColor;
            fixed4 _UnderColor;
            fixed4 _SkyColor_Night;

            float _DayCycle;
            float _Direction;

            fixed4 _SkyColor_Sun;
            fixed4 _SkyColor_Sun_Core;
            float _Sun_Effect_Range;
            float _Sun_Core_Compression;

            fixed4 _Sun_Color;
            float _Sun_Size;
            float _Sun_Sharpness;

            struct appdata{
                float4 vertex : POSITION;
                float3 texcoord : TEXCOORD0;

                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f{
                float4 vertex : SV_POSITION;
                float3 texcoord : TEXCOORD0;
                float3 rotate : TEXCOORD1;
                float day_cycle : TEXCOORD2;
                float sun_time : TEXCOORD3;
                float4 sky_color_bottom_t : TEXCOORD4;

                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            #include "Packages/com.deltafield.shader_commons/Includes/functions_math.hlsl"

            fixed3 Screen(fixed3 a, fixed3 b){
                return a+b-a*b;
            }

            v2f vert (appdata v){
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_OUTPUT(v2f,o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = v.texcoord;

                #ifdef _LIGHT_BASED_DIRECTION
                    o.rotate = normalize(_WorldSpaceLightPos0.xyz);
                    o.day_cycle = saturate(-o.rotate.y+0.5);
                    float arc_sin = asin(o.rotate.y)/UNITY_PI*0.5;
                    o.sun_time = 1.0-mod(arc_sin,0.5)*4.0;

                    o.sky_color_bottom_t = lerp(_HorizonColor,_SkyColor_Night/2.0,o.day_cycle);

                #else
                    o.day_cycle = saturate(sin(_DayCycle*UNITY_PI*2.0-UNITY_PI)+0.5);
                    o.sun_time = 1.0-mod(_DayCycle,0.5)*4.0;
                    o.sky_color_bottom_t = lerp(_HorizonColor,_SkyColor_Night/2.0,o.day_cycle);
                    float day_cycle_pi = -_DayCycle*UNITY_PI*2.0;

                    float c_dir = cos(_Direction);
                    float s_dir = sin(_Direction);
                    float c_cyc = cos(day_cycle_pi);
                    float s_cyc = sin(day_cycle_pi);
                    float3 rot_pitch = float3(0.0,-s_cyc,-c_cyc);
                    o.rotate = float3(
                        c_dir*rot_pitch.x-s_dir*rot_pitch.z,
                        rot_pitch.y,
                        s_dir*rot_pitch.x+c_dir*rot_pitch.z
                    );
                #endif
                return o;
            }

            fixed4 frag (v2f i) : SV_Target{
                UNITY_SETUP_INSTANCE_ID(i);
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

                float4 sky = lerp(
                    lerp(i.sky_color_bottom_t,_SkyColor, 1.0 - pow(1.0 - i.texcoord.y, 3.0)),
                    lerp(i.sky_color_bottom_t,_SkyColor_Night, 1.0 - pow(1.0 - i.texcoord.y, 3.0)),
                    i.day_cycle
                    );
                float4 under = lerp(i.sky_color_bottom_t,lerp(_UnderColor,_UnderColor*0.1,i.day_cycle), 1.0 - pow(1.0 - -i.texcoord.y, 5.0));

                float4 c = lerp(under,sky,step(0.0,i.texcoord.y));

                float sun_pos = (frac(_DayCycle+0.25) > 0.5 ? 1.0 : -1.0);
                float sun_rot = dot(i.rotate,normalize(i.texcoord));
                float sun_area = sun_rot*sun_rot*sun_rot*sun_rot*sun_rot;
                float3 sun_base_effect = _SkyColor_Sun.rgb * max(0.0,sun_area+_Sun_Effect_Range+i.sun_time*i.sun_time) * _SkyColor_Sun.a;
                float3 sun_core_effect = _SkyColor_Sun_Core.rgb * pow(saturate(sun_area),_Sun_Core_Compression) * _SkyColor_Sun_Core.a;
                float3 sun_star = float3(1.0,1.0,1.0)*sun_area;

                c.rgb = Screen(c.rgb,sun_base_effect * pow(i.sun_time,8.0));

                #ifdef _SUN_ADD
                    float sun_size_exp = _Sun_Size*_Sun_Size;
                    float sun_size = sun_size_exp == 0.0 ? -1.0 : 1.0/sun_size_exp;
                    c.rgb = lerp(c.rgb,_Sun_Color.rgb,saturate(1.0-pow(2.0,pow(max(0.0,-sun_rot+1.0)*sun_size,_Sun_Sharpness))+1.0)*_Sun_Color.a);
                #endif

                c.rgb = lerp(c.rgb,c.rgb+sun_core_effect,sun_core_effect * pow(i.sun_time,8.0));

                return saturate(c);
            }
            ENDHLSL
        }
    }
}