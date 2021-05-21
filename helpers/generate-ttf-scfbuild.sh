#!/bin/bash

set -o errexit
set -o nounset

saturation=$1
version=$2
format=$3
method=$4
build_dir=$5
name=OpenMoji-${saturation^}

/scfbuild/bin/scfbuild --yaml-conf="/mnt/font/scfbuild-$saturation.yml" \
                       --font-version="$version" \
                       --glyph-svg-dir="$build_dir/$method/black" \
                       --color-svg-dir="$build_dir/$method/color" \
                       --output="/mnt/font/$method/$name$format.ttf"
