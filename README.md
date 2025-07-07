# Day-and-NightSkyboxShader
Copyright (c) 2025, DeltaField



## Overview | 概要
Name: Day-and-NightSkyboxShader<br>
Version: 1.0.0<br>

Day-and-NightSkyboxShaderは昼夜を連続した空の景色を描写することが可能なシェーダーです。<br>
以下の機能を特徴としています。

* 昼の空の色、夜の空の色を個別に指定が可能。地平線の色や日の出と日没時の色も指定できます。
* シェーダー側のプロパティ、もしくはDirectional Lightで、時間の指定が可能。太陽が回る方角も指定できます。

## Requirements | 環境要件
現在、以下の環境で動作を確認しています。
* Unity 2022.3
* Built-in Render Pipeline
* Unity XR Single-pass Instanced

以下の前提パッケージが必要です。VPMでインストールした場合は自動的にインポートされます。
* [DeltaField-Shader-Commons](https://github.com/r-delta-c/DeltaField-Shader-Commons)



## Caution | 警告
* **設計の都合上、非常に光度の高い設定が可能です。<br>
デスクトップのみならずVR着用時といった環境で視認した際に、健康上に支障が出ないかの確認を怠らないようにしてください。**

* 動作保証外として、実際に検証ができなかった環境があります。<br>***Pimaxといったステレオ描写が特殊な機器等***<br><br>正常な動作を確認できていないため、保証はできかねます。ご了承ください。



## Installation instructions | インストール方法
インストール方法は以下の三つのやり方があります。どれか一つの方法を実施してください。

### VPM - ***推奨***
[Package Listing WEB](https://r-delta-c.github.io/vpm_repository/)へ移動し、**Add to VCC**というボタンを押して、VRChat Creator Companionを開きます。<br>
リポジトリを加えましたら、導入したいプロジェクトのManage Packagesを開き、一覧に加わっているDay-and-NightSkyboxShaderをインストールしてください。

### Package Manager - ***推奨***
Unityのタブメニューから、**Window -> Package Manager**を押してPackage Managerを開きます。<br>
Package Managerの左上にある**+**ボタンを押して、**Add package from git URL...**を押します。<br>
開かれた入力ダイアログに以下のリンクを張り付けて、**Add**を押して加えてください。<br>
```
https://github.com/r-delta-c/Day-and-NightSkyboxShader.git
```
**[Requirements | 環境要件]に前提パッケージが記載されていた場合は、先にそちらをインポートしてください。**

### .unitypackage
[リリースデータ](https://github.com/r-delta-c/Day-and-NightSkyboxShader/releases)から任意のバージョンを探して、Assets内の末尾が **.unitypackage**になっているデータをDLしてください。<br>
DLした.unitypackageは、起動したUnity上へ**ドラッグ&ドロップ**することでインポートできます。



## How to Use | 使い方
以下のページを参照してください。<br>
[Properties | プロパティ](https://github.com/r-delta-c/Day-and-NightSkyboxShader/blob/main/Documentation~/properties.md "Documentation~/properties.md")

## License | ライセンス
このシェーダーはMIT Licenseによって提供されます。
[LICENSE.md](https://github.com/r-delta-c/Day-and-NightSkyboxShader/blob/main/LICENSE.md)の内容に則ってご利用ください。
