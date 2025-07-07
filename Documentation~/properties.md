# Properties | プロパティ
Day-and-NightSkyboxShaderのプロパティ解説です。<br>
(独自のプロパティ以外の解説は省略します。)



## Colors
|Property|Description|
|:--|:--|
|Sky Color|昼時の空の色です。|
|Night Color|夜時の空の色です。|
|Horizon Color|水平線の背景の色です。<br>昼夜の描写は、上記で設定した色に合わせてブレンドされます。|
|Under Color|水平線より下の背景の色です。<br>昼夜の描写は、上記で設定した色に合わせてブレンドされます。|



## General
|Property|Description|
|:--|:--|
|Day Cycle|0~1の間で指定した時間帯を描写します。<br>0の時点では日の入り、0.5の時点では日没の時間になっています。|
|Direction|日の入り、日没の方角を指定します。|
|Light-Based Direction|有効にすると、Lightオブジェクトの向きを基に時間帯が反映されます。<br>最初に生成されたLightオブジェクト、もしくはUnityツールバーから、`Rendering -> Lighting -> Environment`内の**Sun Sourceで指定されたLightオブジェクト**が対象となります。<br>Directional Lightオブジェクトを対象にすることが想定されています。|



## Sunrise Sunset
|Property|Description|
|:--|:--|
|Base Color|日の入り、日没時の空の色を指定します。<br>下記プロパティを含めて、適度にブレンドされます。<br>アルファ値に応じて効果の反映量が変化します。|
|Core Color|日の入り、日没時の太陽の中心付近の色を指定します。<br>アルファ値に応じて効果の反映量が変化します。|
|Effect Range|日の入り、日没時の空の色の影響範囲を指定します。|
|Core Compression|Core Colorの範囲を凝縮するように狭めます。|



## Sun
|Property|Description|
|:--|:--|
|Activate Sun|チェックを入れると太陽の描写を有効にします。<br>無効にすると、描写処理も省かれるため軽量になります。|
|Sun Color|太陽の色を指定します。<br>Sunrise Sunsetで指定した色の影響を僅かに受けます。<br>アルファ値に応じて効果の反映量が変化します。|
|Size|太陽の大きさを指定します。|
|Sharpness|太陽の輪郭の強調具合を調整します。値が小さいとぼやけます。
