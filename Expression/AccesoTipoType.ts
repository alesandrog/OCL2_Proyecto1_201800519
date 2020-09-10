import { Expresion } from "../Abstract/Expresion";
import { Entorno } from "../Symbol/Entorno";
import { Retorno, Tipo } from "../Abstract/Retorno";
import { Error_ } from "../Error/Error";
import { Arreglo2 } from "../Instruction/Arreglo2";
import { AccesoIndice } from "./AccesoIndice";
import { Types } from "mysql";
import { Type } from "../Instruction/Types";
import { AccesoArray } from "./AccesoArray";

export class AccesoTipoType extends Expresion{

    public id : string;

    constructor(id: string ,linea : number, columna: number){
        super(linea, columna);
        this.id = id;
    }

    //TODO validar null y undefined, mensajes de error

    public execute(entorno : Entorno): any {
        return entorno.getTipo(this.id);
        
    }
}