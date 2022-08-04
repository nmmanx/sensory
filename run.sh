#!/bin/bash

if [ $1 = "-r" ]; then rm -rf build; fi

meson build --prefix=/usr
cd build
ninja

[ 0 -eq $? ] && ./com.github.nmmanx.temon
