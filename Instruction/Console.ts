import { Instruction } from "../Abstract/Instruccion";
import { Expresion } from "../Abstract/Expresion";
import { Entorno } from "../Symbol/Entorno";

export class Console extends Instruction{

    constructor(private value : Expresion, line : number, column : number){
        super(line, column);
    }

    public execute(entorno : Entorno) {
        const value = this.value.execute(entorno);
        console.log(value.value);
    }
}