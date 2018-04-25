#!/bin/bash
set -e
git clone "$1"
base=$(basename $1)
folder=${base%.git}
[ -d "$folder" ]
cd "$folder"
git checkout "$2"
cp ../client.sh ./
bash client.sh
