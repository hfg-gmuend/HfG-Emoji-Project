#!/bin/bash
set -ueo pipefail

# This script may be executed or sourced from any directory.
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"/..

# -- svg and png --
helpers/lib/create-zip.sh color/svg/ _tmp/openmoji-svg-color.zip
helpers/lib/create-zip.sh color/72x72/ _tmp/openmoji-72x72-color.zip
helpers/lib/create-zip.sh color/618x618/ _tmp/openmoji-618x618-color.zip

helpers/lib/create-zip.sh black/svg/ _tmp/openmoji-svg-black.zip
helpers/lib/create-zip.sh black/72x72/ _tmp/openmoji-72x72-black.zip
helpers/lib/create-zip.sh black/618x618/ _tmp/openmoji-618x618-black.zip

# -- fonts --
(
  cd font
  zip -x ".*" -x "__MACOSX" \
      glyf/OpenMoji-Black.ttf \
      glyf/demo.html \
      glyf/openmoji.css \
      glyf_colr_0/OpenMoji-Color.ttf \
      glyf_colr_0/demo.html \
      glyf_colr_0/openmoji.css \
      scfbuild/OpenMoji-Color.ttf \
      scfbuild/demo.html \
      scfbuild/openmoji.css \
      openmoji-font.zip
  mv openmoji-font.zip ../_tmp/
)
