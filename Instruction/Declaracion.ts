import { Instruction } from "../Abstract/Instruccion";
import { Entorno } from "../Symbol/Entorno";
import { Expresion } from "../Abstract/Expresion";
import { env } from "process";
import { Tipo } from "../Abstract/Retorno";
import { Error_ } from "../Error/Error";

export class Declaration extends Instruction{

    public id : string;
    public value : Expresion | null;
    public variable : boolean;
    public tipo : Tipo;

    constructor(id: string, value : Expresion | null,  variable : boolean ,tipo : Tipo , linea : number, columna: number){
        super(linea, columna);
        this.id = id;
        this.value = value;
        this.variable = variable;
        this.tipo = tipo;
    }

    public execute(entorno : Entorno) {
        if(this.value != null){
            const val = this.value.execute(entorno);
            //Tiene expresion y tipo declarado
            if(this.tipo != Tipo.NULL){
                if(this.tipo == val.tipo){
                    entorno.guardarVariable(this.id, val.value, val.tipo, this.variable);
                }else{
                    throw new Error_(this.linea, this.columna, 'Semantico', 'Tipos incompatibles ' + Tipo[val.tipo] + ' no asignable a ' +  Tipo[this.tipo]);
                }
            }else{
                //Tiene expresion pero no tiene tipo explicito
                entorno.guardarVariable(this.id, val.value, val.tipo, this.variable);
            }
        }else{
            //No tiene valor explicito pero si tipo
            if(this.tipo != Tipo.NULL){
                entorno.guardarVariable(this.id, null , this.tipo , this.variable);
            }else{
                //No tiene tipo ni valor declarado
                entorno.guardarVariable(this.id, null , Tipo.NULL, this.variable);
            }
        }        
    }
}