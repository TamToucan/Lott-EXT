#!/bin/bash
opt=""
target=""

[[ -z "$1" ]] && echo "$0 <core | godot | all>" && exit 1

[[ $1 == "core" ]] &&
opt="-DBUILD_GODOT=OFF" && target="core"

[[ $1 == "godot" ]] &&
opt="-DBUILD_GODOT=ON" && target="godot"

[[ $1 == "all" ]] &&
opt="-DBUILD_GODOT=ON" && target=""

cmake --preset=mingw64 -S . -B build $opt
cmake --build build --target $target

