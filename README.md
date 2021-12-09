# simulator

***Windows binaryは浮動小数点演算がバグってます（32-bitなので）***

## ビルド方法(CLI)

```$ make```

## 実行方法(CLI)

```$ ./simulator```

## 説明(CLI)

はじめてつかうときはhelpとタイプすると使い方が表示されます

トップのディレクトリで

```$ make```

すると、アセンブラとシミュレータが同時にビルドできます。

## ビルド方法(GUI on Ubuntu)

```shell
sudo apt install qtbase5-dev qttools5-dev-tools qt5-default
make gui
```
すると、`gui-simulator`ができる。

## ビルド方法(GUI on Windows)

一番楽なのは以下の手順

1. QtCreatorをインストール
2. OreOre-V/OreOre-V.proを開く
3. ビルドボタンを押す


## 実行方法

`$ ./gui-simulator [assembly file name(optional)]`

## 説明(GUI)

GUIのシミュレータです

フィーリングで操作してください（雑）

## fsinとfcosの検証
`$make fver`をすると、`fverify`という実行ファイルができる。

fsinの検証
`fsin.s`があるディレクトリで、`$./fverify sin`とする。

fcosの検証
`fcos.s`があるディレクトリで、`$./fverify cos`とする。
