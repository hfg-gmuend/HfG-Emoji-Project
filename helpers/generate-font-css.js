#!/usr/bin/env node
'use strict';

const path = require('path');
const fs = require('fs');
const CharacterSet = require('characterset');

const openmojis = require('../data/openmoji.json');

const emojis = openmojis.map(e => { return e.emoji });
const characterSet = new CharacterSet(emojis.join(''));

const css = `
@font-face {
  font-family: "OpenMojiColor";
  src: url("OpenMoji-Color${process.argv[2]}.ttf") format("truetype");
  font-style: Color;
  unicode-range: ${characterSet.toHexRangeString()};
}

@font-face {
  font-family: "OpenMojiBlack";
  src: url("OpenMoji-Black.ttf") format("truetype");
  font-style: Black;
  unicode-range: ${characterSet.toHexRangeString()};
}
`;

fs.writeFileSync(process.argv[3], css);
