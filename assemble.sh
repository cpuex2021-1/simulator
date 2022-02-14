#!/bin/bash

echo "[INFO] Translating 1st assembly $1 -> $1.second"
./translator $1 $1.second
echo "[INFO] Complete!"
echo "[INFO] Translating 2nd assembly $1.second -> $1.vliw"
./packer $1.second $1.vliw
echo "[INFO] Complete!"
echo "[INFO] Translating 2nd vliw assembly $1.vliw -> $2"
./assembler $1.vliw $2
echo "[INFO] Complete!"
