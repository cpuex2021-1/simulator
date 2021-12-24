# simulator

## ビルド方法(CLI)

```$ make cli```

## 実行方法(CLI)

```$ ./simulator```

## 説明(CLI)

はじめてつかうときはhelpとタイプすると使い方が表示されます

通常モード／高速モード（run/frun）が選択できます。

## ビルド方法(GUI on Ubuntu)

```shell
sudo apt install qtbase5-dev qttools5-dev-tools qt5-default cmake
make gui
```
すると、`gui-simulator`ができる。

## ビルド方法(GUI on Windows)
ビルドがバグってます（工事中）

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
