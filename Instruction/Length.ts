import { Instruction } from "../Abstract/Instruccion";
import { Entorno } from "../Symbol/Entorno";
import { Error_ } from "../Error/Error";
import { Retorno, Tipo } from "../Abstract/Retorno";
import { Expresion } from "../Abstract/Expresion";
import { AccesoIndice } from "../Expression/AccesoIndice";

export class Length extends Instruction{

    private id : string;
    public accesos : AccesoIndice | null;

    constructor(id : string , accesos : AccesoIndice | null , line : number, column : number){
        super(line, column);
        this.id = id;
        this.accesos = accesos;
    }

    public execute(environment : Entorno) : Retorno | void {
        if(this.accesos != null){
            let arreglo = this.accesos.execute(environment);
            if(arreglo == null || arreglo == undefined)
                return; //error
            if(arreglo.tipo != Tipo.ARRAY)
                return; //error
            return { value : arreglo.value.length , tipo : Tipo.NUMBER} ;
        }else{
            let arreglo : any;
            arreglo = environment.getVariable(this.id);
            if(arreglo == null || arreglo == undefined)
                return; //error
            if(arreglo!.tipo != Tipo.ARRAY)
                return; //error
            return { value : arreglo.valor.length , tipo : Tipo.NUMBER} ;
        }
    }
}