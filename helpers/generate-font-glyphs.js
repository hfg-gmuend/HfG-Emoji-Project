#!/usr/bin/env node
'use strict';

const glob = require('glob').sync;
const fs = require('fs');
const path = require('path');
const _ = require('lodash');

const args = process.argv.slice(2);
const build_dir = args[0];
fs.mkdirSync(path.join(build_dir, 'color'), {recursive: true})
fs.mkdirSync(path.join(build_dir, 'black'), {recursive: true})

let hexcodes = [];
const missingGlyphBlack = './black/svg/25A1.svg';
const missingGlyphColor = './color/svg/25A1.svg';
// find exported svg files
const svgFiles = glob('./color/svg/*.svg');

svgFiles.forEach(f => {
  // existing filenames can be composed of multiple hexcodes
  const basename = path.basename(f, '.svg');
  hexcodes = [...hexcodes, ...basename.split('-')];

  //copy files
  const filename = path.basename(f);
  fs.copyFileSync(path.join('./color/svg/', filename) , path.join(build_dir, 'color', filename));
  fs.copyFileSync(path.join('./black/svg/', filename) , path.join(build_dir, 'black', filename));
});

// filter to uniq hexcodes
hexcodes = _.uniq(hexcodes);

// font generator expects for every hexcode a svg file
// if we don't have a svg file for an hexcode -> provide missing glyph svg
hexcodes.forEach(h => {
  const filename = `${h}.svg`;
  if (!fs.existsSync(path.join('./color/svg/', filename))) {
    console.log(`${h} is missing -> substitute with "Missing Glyph": ${filename}`);
    fs.copyFileSync(missingGlyphColor, path.join(build_dir, 'color', filename));
    fs.copyFileSync(missingGlyphBlack, path.join(build_dir, 'black', filename));
  }
});
