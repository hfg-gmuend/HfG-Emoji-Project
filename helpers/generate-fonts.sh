#!/bin/bash
set -ueo pipefail

# -- prepare assets --
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"/.. || exit 1

# generate css file for OpenMoji fonts
echo "👉 generate-font-css.js"
helpers/generate-font-css.js


# -- OpenMoji COLR TTF font generator via nanoemoji container --
version=$(git describe --tags)

# If we're connected to a terminal, don't flood it with ninja output,
# and enable ^C.
if [[ -t 1 ]]; then
    tty=(--tty --interactive)
else
    tty=()
fi

image=registry.gitlab.com/mavit/nanoemoji-container:master
case "${CONTAINER_ENGINE:-docker}" in
podman)
    container_engine=podman
    ;;
*)
    container_engine=docker
    ;;
esac

$container_engine pull $image

# FIXME: Upgrade glyf_colr_0 to glyf_colr_1 once
# https://github.com/googlefonts/colr-gradients-spec stabilises.
#
for saturation in black color; do
    name=OpenMoji-${saturation^}
    build_dir=/mnt/build/$saturation

    case $saturation in
    black)
        formats=(glyf)
        ;;
    color)
        formats=(glyf_colr_0 picosvgz)
        ;;
    esac

    for format in "${formats[@]}"; do
        mkdir -p "font/$format"

        $container_engine run \
            --volume="$PWD":/mnt:Z \
            --rm \
            "${tty[@]}" \
            $image \
            bash /mnt/helpers/generate-ttf.sh \
                "$name" "$saturation" "$version" "$format" "$build_dir"
    done
done
