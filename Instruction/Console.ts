import { Instruction } from "../Abstract/Instruccion";
import { Expresion } from "../Abstract/Expresion";
import { Entorno } from "../Symbol/Entorno";
import { Tipo, Retorno } from "../Abstract/Retorno";
import { Arreglo2 } from "../Instruction/Arreglo2";
export class Console extends Instruction{

    constructor(private value : Expresion, line : number, column : number){
        super(line, column);
    }

    public execute(entorno : Entorno) {
        let value : any;
        value = this.value.execute(entorno);

        if(value.tipo == Tipo.ARRAY){
            console.log(this.ejecutar(entorno, value).value);
        }else{
            console.log(value.value);
        }
        
    }

    public ejecutar(entorno : Entorno, arreglo : Retorno): Retorno {
        let res = [];
        for(const instr of arreglo.value){
            if(instr.tipo == Tipo.ARRAY){
                res.push(this.ejecutar(entorno, instr).value);
            }else{
                res.push(instr.value);
            }
        }
        return { value : res, tipo : Tipo.ARRAY };
    }
}