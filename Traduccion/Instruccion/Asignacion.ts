import { Entorno } from "../Symbol/Entorno";
import { Expresion } from "../Abstract/Expresion";
import { Instruccion } from "../Abstract/Instruccion"
import { env } from "process";


export class Asignacion extends Instruccion{

    public id : string;
    public expresion : Expresion | null;
    public operador : string;

    constructor(id: string,  expresion:Expresion | null, operador : string ){
        super();
        this.id = id;
        this.expresion = expresion;
        this.operador = operador;
    }

    public traducir(entorno : Entorno):string{  
        const exp = this.expresion.traducir(entorno);
        return `${this.id} ${this.operador} ${exp};`;
    }
}