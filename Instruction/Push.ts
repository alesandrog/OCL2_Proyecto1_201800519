import { Instruction } from "../Abstract/Instruccion";
import { Entorno } from "../Symbol/Entorno";
import { Error_ } from "../Error/Error";
import { Retorno, Tipo } from "../Abstract/Retorno";
import { Expresion } from "../Abstract/Expresion";
import { AccesoIndice } from "../Expression/AccesoIndice";

export class Push extends Instruction{

    private line : number;
    private column : number;
    private id : string;
    public value : Expresion;
    public accesos : AccesoIndice | null;

    constructor(id : string , accesos : AccesoIndice | null,  value : Expresion  , line : number, column : number){
        super(line, column);
        this.line = line;
        this.column = column;
        this.id = id;
        this.value = value;
        this.accesos = accesos;
    }

    public execute(environment : Entorno)  {
        if(this.accesos != null){
            let arreglo = this.accesos.execute(environment);
            if(arreglo == null || arreglo == undefined){
                return; //error
            }

            if(arreglo.tipo != Tipo.ARRAY){
                return; //error
            }
            const valor = this.value.execute(environment);
            arreglo.value.push(valor);
        }else{
            let arreglo : any;
            arreglo = environment.getVariable(this.id);
            if(arreglo == null || arreglo == undefined){
                return; //error
            }

            if(arreglo.tipo != Tipo.ARRAY){
                return; //error
            }
            const valor = this.value.execute(environment);
            arreglo.valor.push(valor);
        }
    }
}