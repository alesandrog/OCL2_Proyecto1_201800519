import { Entorno } from "./Symbol/Entorno";
import { errores } from './Error/Errores';
import { Error_ } from "./Error/Error";

try{
    const parser = require('./Grammar/Grammar');
    const fs = require('fs');
    
    const entrada = fs.readFileSync('./entrada.ts');
    const ast = parser.parse(entrada.toString());
    const env = new Entorno(null);
    
    for(const instr of ast){
        if(instr instanceof Function)
            continue;
        try {
            const actual = instr.execute(env);
            if(actual != null || actual != undefined){
                errores.push(new Error_(actual.line, actual.column, 'Semantico', actual.type + ' fuera de un ciclo'));
            }
        } catch (error) {
            errores.push(error);  
        }
    }
}catch(error){
    errores.push(error);
}


console.log(errores);
