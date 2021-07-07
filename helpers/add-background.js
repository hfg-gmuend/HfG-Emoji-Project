#!/usr/bin/env node


const path = require('path');
const fs = require('fs');
const SVGO = require('svgo');

const openmojis = require("../data/openmoji.json");

const {
    createDoc
} = require('../test/utils/utils');

svgo = new SVGO();

openmojis.forEach(emoji => {
    const svgFile = path.join("src", emoji.group, emoji.subgroups, emoji.hexcode + '.svg')
    const doc = createDoc(emoji);

    const root = doc.querySelector("#emoji")

    // create background and insert it
    const backgroundGroup = doc.createElement('g')
    backgroundGroup.setAttribute('id', "white-padding")
    backgroundGroup.setAttribute('stroke-linecap', "round")
    backgroundGroup.setAttribute('stroke-miterlimit', "10")
    backgroundGroup.setAttribute('stroke-width', "6")
    backgroundGroup.setAttribute('stroke', "#fff")
    backgroundGroup.setAttribute('fill', "none")
    backgroundGroup.setAttribute('stroke-linejoin', "round")

    const beforeNode = doc.querySelector("#grid").nextSibling
    root.insertBefore(backgroundGroup, beforeNode)


    // duplicate all but grid
    var nongrid = doc.querySelectorAll('svg > :not(#grid):not(#white-padding)');
    console.log(nongrid.length);
    for (var value of nongrid.values()) {
        console.log(value.id);

        backgroundGroup.appendChild(value.cloneNode(true))
    }

    // remove fill and stroke attributes
    var items = backgroundGroup.getElementsByTagName("*");
    for (let item of items) {
        item.removeAttribute("fill");
        item.removeAttribute("stroke");
        item.removeAttribute("stroke-linecap");
        item.removeAttribute("stroke-linejoin");
        item.removeAttribute("stroke-miterlimit");
        item.removeAttribute("stroke-width");
    }

    svgo.optimize(doc.documentElement.querySelector("svg").outerHTML).then(function (result) {
        svgo.optimize(result.data).then(function (result) {

            fs.writeFile(svgFile, result.data, function (err) {
                if (err) return console.log(err);
                console.log('Successful');
            });
        });
    });
})