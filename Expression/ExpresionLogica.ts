import { Expresion } from "../Abstract/Expresion";
import { Retorno, Tipo } from "../Abstract/Retorno";
import { Entorno  } from "../Symbol/Entorno";
import { Error_ } from "../Error/Error";

export enum OperacionLogica{
    MENOR,
    MAYOR,
    MENORIG,
    MAYORIG,
    IGIG,
    DIF
}

export class ExpresionLogica extends Expresion{

    constructor(private izq: Expresion, private der: Expresion, private tipo : OperacionLogica, linea: number, columna: number){
        super(linea,columna);
    }

    public execute(entorno : Entorno) : Retorno{
        const izq = this.izq.execute(entorno);
        const der = this.der.execute(entorno);
        let result : Retorno;
        const tipoDominante = this.tipoDominante(izq.tipo, der.tipo);
        
        if(this.tipo == OperacionLogica.MAYOR){
            if(tipoDominante == Tipo.BOOLEAN)
                result = {value : (Boolean(izq.value > der.value )), tipo : Tipo.BOOLEAN};
            else
                throw new Error_(this.linea, this.columna, 'Semantico', 'No se puede operar: ' + Tipo[izq.tipo] + ' > ' +  Tipo[der.tipo]);            
        }
        else if(this.tipo == OperacionLogica.MAYORIG){
            if(tipoDominante == Tipo.BOOLEAN || tipoDominante == Tipo.NUMBER)
                result = {value : (Boolean(izq.value >= der.value )), tipo : Tipo.BOOLEAN};
            else
                throw new Error_(this.linea, this.columna, 'Semantico', 'No se puede operar: ' + Tipo[izq.tipo] + ' >= ' +  Tipo[der.tipo]);            
        }
        else if(this.tipo == OperacionLogica.MENOR){
            if(tipoDominante == Tipo.BOOLEAN || tipoDominante == Tipo.NUMBER)
                result = {value : (Boolean(izq.value < der.value )), tipo : Tipo.BOOLEAN};
            else
                throw new Error_(this.linea, this.columna, 'Semantico', 'No se puede operar: ' + Tipo[izq.tipo] + ' < ' +  Tipo[der.tipo]);            
        }
        else if(this.tipo == OperacionLogica.MENORIG){
            if(tipoDominante == Tipo.BOOLEAN || tipoDominante == Tipo.NUMBER)
                result = {value : (Boolean(izq.value <= der.value )), tipo : Tipo.BOOLEAN};
            else
                throw new Error_(this.linea, this.columna, 'Semantico', 'No se puede operar: ' + Tipo[izq.tipo] + ' <= ' +  Tipo[der.tipo]);            
        }
        else if(this.tipo == OperacionLogica.IGIG){
            if(tipoDominante == Tipo.BOOLEAN || tipoDominante == Tipo.NUMBER)
                result = {value : (Boolean(izq.value == der.value )), tipo : Tipo.BOOLEAN};
            else
                throw new Error_(this.linea, this.columna, 'Semantico', 'No se puede operar: ' + Tipo[izq.tipo] + ' == ' +  Tipo[der.tipo]);            
        }
        else if(this.tipo == OperacionLogica.DIF){
            if(tipoDominante == Tipo.BOOLEAN || tipoDominante == Tipo.NUMBER)
                result = {value : (Boolean(izq.value != der.value )), tipo : Tipo.BOOLEAN};
            else
                throw new Error_(this.linea, this.columna, 'Semantico', 'No se puede operar: ' + Tipo[izq.tipo] + ' != ' +  Tipo[der.tipo]);            
        }
        return result!;
    }
}