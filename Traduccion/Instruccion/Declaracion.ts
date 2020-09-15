import { Entorno } from "../Symbol/Entorno";
import { Expresion } from "../Abstract/Expresion";
import { Instruccion } from "../Abstract/Instruccion"
import { env } from "process";


export class Declaracion extends Instruccion{

    public id : string;
    public tipo : string;
    public entorno : string;
    public tipoVariable : string;
    public expresion : Expresion | null;

    constructor(id: string, tipo : string, entorno : string, tipoVariable : string, expresion:Expresion | null ){
        super();
        this.id = id;
        this.tipo = tipo;
        this.entorno = entorno;
        this.tipoVariable = tipoVariable;
        this.expresion = expresion;
    }

    public traducir(entorno : Entorno):string{
        //Verificar la expresion
        let exp;
        if(this.expresion != null){
            exp = "= " + this.expresion.traducir(entorno);
        }else{
            exp = "";
        }

        let result = "";
        //Verificar si se encuentra dentro de una funcion
        if(this.entorno != ""){
            let newId = `${entorno}_${this.id}`;
            entorno.declararVariable(newId,  this.tipo);
            result = `${this.tipoVariable} ${newId} ${this.tipo} ${exp}`
        }else{
            entorno.declararVariable(this.id,  this.tipo);
            result = `${this.tipoVariable} ${this.id} ${this.tipo} ${exp}`
        }

        return result;
    }
}