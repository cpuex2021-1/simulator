# simulator

***GUIはgui branchにあります***

## ビルド方法(CLI)

```$ make```

## 実行方法

```$ ./simulator```

## 説明

***実行方法が変わりました***

***コマンドの短縮形も追加され、run（最初から実行）とcontinue（続きから実行）が区別されました。`help`で確認してみてください***

*アセンブリとバイナリを読むコマンド(read/eat)がそれぞれ追加されました。シミュレータを立ち上げてからファイルを読み込んでください*

FPUはC++標準で対応

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
すると`OreOre-V/`下に実行ファイル`OreOre-V`が生成される。


