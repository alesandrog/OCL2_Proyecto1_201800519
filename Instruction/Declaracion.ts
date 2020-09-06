import { Instruction } from "../Abstract/Instruccion";
import { Entorno } from "../Symbol/Entorno";
import { Expresion } from "../Abstract/Expresion";
import { env } from "process";
import { Tipo } from "../Abstract/Retorno";
import { Error_ } from "../Error/Error";

export class Declaration extends Instruction{

    private id : string;
    private value : Expresion | null;
    private variable : boolean;
    private tipo : Tipo;
    private dimension : number;

    constructor(id: string, value : Expresion | null,  variable : boolean ,tipo : Tipo , dimension : number , linea : number, columna: number){
        super(linea, columna);
        this.id = id;
        this.value = value;
        this.variable = variable;
        this.tipo = tipo;
        this.dimension = dimension;
    }

    public execute(entorno : Entorno) {
        if(this.value != null){
            const val = this.value.execute(entorno);
            //Tiene expresion y tipo declarado
            if(this.tipo != Tipo.NULL){
                if(this.tipo == val.tipo){
                    entorno.guardarVariable(this.id, val.value, val.tipo, this.variable, this.dimension);
                }else{
                    throw new Error_(this.linea, this.columna, 'Semantico', 'Tipos incompatibles ' + Tipo[val.tipo] + ' no asignable a ' +  Tipo[this.tipo]);
                }
            }else{
                //Tiene expresion pero no tiene tipo explicito
                entorno.guardarVariable(this.id, val.value, val.tipo, this.variable, this.dimension);
            }
        }else{
            //no tiene tipo ni valor declarados
            entorno.guardarVariable(this.id, null , Tipo.NULL, this.variable , this.dimension);
        }        
    }
}