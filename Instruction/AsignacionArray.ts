import { Instruction } from "../Abstract/Instruccion";
import { Entorno } from "../Symbol/Entorno";
import { Expresion } from "../Abstract/Expresion";
import { env } from "process";
import { Error_ } from "../Error/Error";
import { Tipo } from "../Abstract/Retorno";
import { AccesoIndice } from "../Expression/AccesoIndice";

export class AsignacionArray extends Instruction{

    private id : string;
    private value : Expresion;
    private accesos : AccesoIndice;

    constructor(id: string, value : Expresion, accesos : AccesoIndice, linea : number, columna: number){
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
                    let valIndex = this.accesos.execute(entorno);


                    if(valIndex == undefined || valIndex == null)
                        throw new Error_(this.linea, this.columna, 'Semantico', 'Indice invalido ');
                    
                    if(valIndex.tipo == val.tipo){
                        //Modificar el arreglo y guardarlo
                        valIndex.value = val.value;                 
                    }else{
                        throw new Error_(this.linea, this.columna, 'Semantico', 'Tipos incompatibles ' + Tipo[val.tipo] + ' no asignable a ' +  Tipo[valIndex.tipo]);
                    }
                
                }else{
                    //Variable existe pero no ha sido asignada
                    entorno.guardarVariable(this.id, val.value, val.tipo, true );
                }
            }else{
                throw new Error_(this.linea, this.columna, 'Semantico',   'const ' + this.id +' no puede ser re definido');
            }
        }else{
            throw new Error_(this.linea, this.columna, 'Semantico','La variable ' + this.id +  ' no esta definida');
        }           
    }
}