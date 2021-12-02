# simulator

***GUIはgui branchにあります***

***gui branchのWindowsディレクトリ内のファイルをいじらずにOreOre-V.exeを実行すればWindowsでも動きそう***

## ビルド方法(CLI)

```$ make```

## 実行方法

```$ ./simulator```

## 説明

はじめてつかうときはhelpとタイプすると使い方が表示されます

トップのディレクトリで

```$ make```

すると、アセンブラとシミュレータが同時にビルドできます。

## ビルド方法(GUI on Ubuntu)

```shell
sudo apt install qtbase5-dev qttools5-dev-tools qt5-default
mkdir OreOre-V/build
cd OreOre-V/build
qmake ../OreOre-V.pro
make
```
すると`OreOre-V/build/`下に実行ファイル`OreOre-V`が生成される。

## fsinとfcosの検証
`$make fver`をすると、`fverify`という実行ファイルができる。

fsinの検証
`fsin.s`があるディレクトリで、`$./fverify sin`とする。

fcosの検証
`fcos.s`があるディレクトリで、`$./fverify cos`とする。