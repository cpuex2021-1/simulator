# simulator (CPU実験 2021)

## ビルド方法(CLI on Ubuntu)

```shell
sudo apt install cmake
make cli
```

or

```shell
sudo apt install cmake ninja-build
make ninja
```

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

or

```shell
sudo apt install qtbase5-dev qttools5-dev-tools qt5-default cmake ninja-build
make ninja
```
すると、`gui-simulator`ができる。

## ビルド方法(GUI on Windows)

QtCreatorでビルド

## 実行方法

`$ ./gui-simulator [assembly file name(optional)]`

## 説明(GUI)

GUIのシミュレータです

FPUを自作仕様にあわせるときはトップの`CMakeLists.txt`の`add_definition(-DSTDFPU)`をコメントアウトしてください

## 補足

長いこと更新していないので、正常に動作しない可能性があります。
