import { Expresion } from "../Abstract/Expresion";
import { Retorno, Tipo } from "../Abstract/Retorno";
import { Entorno } from "../Symbol/Entorno";
import { AtributoType } from "../Expression/AtributoType";
import { Instruction } from "../Abstract/Instruccion";

export class Type extends Instruction{
    
    public value : Map<string, Retorno> | null | any = new Map<string, Retorno>();
    private atributos : Array<AtributoType>;
    public linea : number;
    public columna : number;
    private id : string;

    constructor(id: string ,valor : Array<AtributoType> , linea : number, columna: number){
        super(linea, columna);
        this.id = id;
        this.atributos = valor;
        this.linea = linea;
        this.columna = columna;
    }

    public execute(entorno : Entorno){

        for(const instr of this.atributos){
            const exe = instr.execute(entorno);
            this.value.set(instr.id , exe);
        }
        entorno.guardarVariable(this.id, this.value, Tipo.TYPE, true);
    }    
}