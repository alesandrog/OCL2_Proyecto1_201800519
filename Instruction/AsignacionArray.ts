import { Instruction } from "../Abstract/Instruccion";
import { Entorno } from "../Symbol/Entorno";
import { Expresion } from "../Abstract/Expresion";
import { env } from "process";
import { Error_ } from "../Error/Error";
import { Tipo } from "../Abstract/Retorno";

export class AsignacionArray extends Instruction{

    private id : string;
    private value : Expresion;
    private accesos : Expresion[];

    constructor(id: string, value : Expresion, accesos : Expresion[], linea : number, columna: number){
        super(linea, columna);
        this.id = id;
        this.value = value;
        this.accesos = accesos;
    }

    public execute(entorno : Entorno) {
        const val = this.value.execute(entorno);
        const variable = entorno.getVariable(this.id);
        if(variable != null && variable != undefined){
            if(variable.variable == true){
                if(variable.tipo != Tipo.NULL){

                    //Accesar al array y verificar el tipo de variable
                    let result : any;
                    result = variable.valor;
                    for( let i = 0; i < this.accesos.length; i++){
                        if( i != this.accesos.length -1){
                            const indice = this.accesos[i].execute(entorno).value;
                            result = result[indice].value;
                        }else{
                            const indice = this.accesos[i].execute(entorno).value;
                            result = result[indice];
                        }
                    }
                    if(result == undefined || result == null)
                        throw new Error_(this.linea, this.columna, 'Semantico', 'Indice invalido ');
                    

                    if(result.tipo == val.tipo){
                        //Modificar el arreglo y guardarlo
                        result.value = val.value;                 
                    }else{
                        throw new Error_(this.linea, this.columna, 'Semantico', 'Tipos incompatibles ' + Tipo[val.tipo] + ' no asignable a ' +  Tipo[variable.tipo]);
                    }
                
                }else{
                    //Variable existe pero no ha sido asignada
                    //entorno.guardarVariable(this.id, val.value, val.tipo, true );
                }
            }else{
                throw new Error_(this.linea, this.columna, 'Semantico',   'const ' + this.id +' no puede ser re definido');
            }
        }else{
            throw new Error_(this.linea, this.columna, 'Semantico','La variable ' + this.id +  ' no esta definida');
        }           
    }
}