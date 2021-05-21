OpenMoji Fonts
==============

* [OpenMoji-Color.ttf](https://github.com/hfg-gmuend/openmoji/blob/master/font/glyf_colr_0/OpenMoji-Color.ttf) (COLR/CPAL)
* [OpenMoji-Color.ttf](https://github.com/hfg-gmuend/openmoji/blob/master/font/scfbuild/OpenMoji-Color.ttf) (SVG)
* [OpenMoji-Black.ttf](https://github.com/hfg-gmuend/openmoji/blob/master/font/glyf/OpenMoji-Black.ttf) (black glyphs only)


💁‍♂️ The OpenMoji color fonts are produced in two formats:
- [SVG in Open Type](https://docs.microsoft.com/en-gb/typography/opentype/spec/svg) standard, which allows to embed complete SVG files within a font enabling full color.
- [COLR/CPAL in Open Type](https://docs.microsoft.com/en-us/typography/opentype/spec/colr), which is more limited but more similar to traditional font formats.

⚠ Support for the two font formats varies by operating system and application. We suggest SVG for macOS users, and COLR/CPAL for everyone else.

🙏 The SVG fonts are generated with the [SVGinOT Color Font Builder](https://github.com/13rac1/scfbuild) by Brad Erickson. Many thanks for open sourcing this tool and the help!
🙏 The remaining fonts are generated with [nanoemoji](https://github.com/googlefonts/nanoemoji) from Google Fonts.

Developer
---------

If you are adventurous and you would like to generate the fonts on your own, here is how:

### Setup

1. Install [node.js](https://nodejs.org) (see version in file [`.nvmrc`](https://github.com/hfg-gmuend/openmoji/blob/master/.nvmrc#L1))
2. Install [Docker](https://www.docker.com/) (tested with Docker 2.2.0.0, engine 19.03.5) or [Podman](https://podman.io/).

### Generate Fonts

1. Make sure that Docker is running in background
2. Open Terminal and go to OpenMoij folder 
```bash
cd path/to/openmoji
```
3. Generate the OpenMoji font files
```bash
./helpers/generate-fonts.sh
```

Done! ✅

You can change the parameters of the OpenMoji fonts via the two config files:
- `OpenMoji-Color.ttx`
- `scfbuild-color.yml`
