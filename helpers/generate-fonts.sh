#!/bin/bash
set -ueo pipefail

# -- prepare assets --
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"/.. || exit 1


# -- OpenMoji COLR TTF font generator via nanoemoji container --
version=$(git describe --tags)

# If we're connected to a terminal, don't flood it with ninja output,
# and enable ^C.
if [[ -t 1 ]]; then
    tty=(--tty --interactive)
else
    tty=()
fi

case "${CONTAINER_ENGINE:-unset}" in
podman)
    container_engine=podman
    ;;
docker)
    container_engine=docker
    ;;
*)
    for ce in podman docker; do
        if type -t $ce >/dev/null; then
            container_engine=$ce
            break
        fi
    done
    ;;
esac

for saturation in black color; do
    build_dir=/mnt/build/$saturation

    case $saturation in
    black)
        methods=(glyf)
        ;;
    color)
      # FIXME: Upgrade glyf_colr_0 to glyf_colr_1 once
      # https://github.com/googlefonts/colr-gradients-spec stabilises.
      #
      # FIXME: Remove untouchedsvgz once we're happy that picosvgz is
      # compatible with macOS, Adobe CC, etc.
      #
      methods=(glyf_colr_0 picosvgz untouchedsvgz)
      ;;
    esac

    for method in "${methods[@]}"; do
        mkdir -p "font/$method"

        case "$method" in
        cbdt)
          generator=nanoemoji
          format=.CBDT
          ;;
        *_colr_0)
          generator=nanoemoji
          format=.COLRv0
          ;;
        *_colr_1)
          generator=nanoemoji
          format=.COLRv1
          ;;
        glyf)
          generator=nanoemoji
          format=
          ;;
        sbix)
          generator=nanoemoji
          format=.sbix
          ;;
        *svg*)
          generator=nanoemoji
          format=.SVG
          ;;
        scfbuild)
          generator=scfbuild
          format=.SVG
          ;;
        esac

        case "$generator" in
        nanoemoji)
          image=registry.gitlab.com/mavit/nanoemoji-container:latest
          ;;
        scfbuild)
          image=ghcr.io/b-g/scfbuild/scfbuild:latest
          helpers/generate-font-glyphs.js "build/$saturation/$method"
          ;;
        esac

        $container_engine run \
          --volume="$PWD":/mnt:Z \
          --rm \
          "${tty[@]}" \
          --pull=always \
          "$image" \
          /mnt/helpers/generate-ttf-$generator.sh \
            "$saturation" "$version" "$format" "$method" "$build_dir"

        helpers/generate-font-css.js "$format" "font/$method/openmoji.css"
    done
done
