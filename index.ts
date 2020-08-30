const parser = require('./Grammar/Grammar');
const fs = require('fs');

const entrada = fs.readFileSync('./entrada.ts');
const ast = parser.parse(entrada.toString());
console.log("Analisis exitoso");

