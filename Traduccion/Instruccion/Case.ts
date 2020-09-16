import { Expresion } from "../Abstract/Expresion";
import { Instruccion } from "../Abstract/Instruccion";
import { Entorno } from "../Symbol/Entorno";

export class Case extends Instruccion{

    constructor(private exp : Expresion , private code : Instruccion[]){
        super();
    }

    public traducir(entorno : Entorno) : string {
        const newEnv = new Entorno(entorno);
        let cod = "";
        for(const instr of this.code){
            cod += `${instr.traducir(newEnv)}\n`;
        }
        let condicion = this.exp.traducir(entorno);
        return `case ${condicion}:\n${cod}`;
    }
}