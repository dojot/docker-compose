var fs = require('fs');
var filename = process.argv[2];
var util = require('util');
var objects = {};
var translator = require('../../node-red-translator/node-red-translator.js');


var ret = translator.translate_mashup(process.argv[2]);
console.log('Results: ');
console.log(util.inspect(ret, {showHidden: false, depth: null}));

process.exit();