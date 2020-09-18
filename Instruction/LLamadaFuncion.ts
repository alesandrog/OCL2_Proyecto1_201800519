  
import { Instruction } from "../Abstract/Instruccion";
import { Expresion } from "../Abstract/Expresion";
import { Entorno } from "../Symbol/Entorno";
import { Error_ } from "../Error/Error";
import { Retorno, Tipo } from "../Abstract/Retorno";
import { Return } from "./Return";
import { AccesoTipoType } from "../Expression/AccesoTipoType";
import { errores } from "../Error/Errores";


export class LlamadaFuncion extends Instruction{

    constructor(private id: string,  public parametros : Expresion[] | null, line : number, column : number){
        super(line, column);
    }

    public execute(entorno : Entorno) : Retorno | null {
        //TODO validar tipo y retorno
        try{
            const func = entorno.getFuncion(this.id);
            if(func != undefined){
                let newEnv = new Entorno(entorno.getGlobal());
                //Validar cantidad de parametros 
                if(this.parametros != null){
                    if(this.parametros.length != func.parametros!.length){
                        if(this.parametros.length > func.parametros!.length)
                            throw new Error_(this.linea, this.columna, 'Semantico', 'Exceso de parametros especificados para la funcion ');
                        else
                            throw new Error_(this.linea, this.columna, 'Semantico', 'Faltan parametros ');
                    }
                    //Validar que los parametros reciban expresiones correctas
                    for(let i = 0; i < this.parametros.length; i++){
                        const value = this.parametros[i].execute(entorno);
                        let variable : any;
                        variable = func.parametros![i];
                        if(variable.tipo instanceof AccesoTipoType){
                            let v = variable.tipo.execute(entorno);
                            if(value.tipo == v.tipo || value.tipo == Tipo.NULL){
                                newEnv.guardarVariable(func.parametros![i].id, value.value, v.tipo, true);
                            }else{
                                throw new Error_(this.linea, this.columna, 'Semantico', 'Tipos incompatibles ' + ' valor no asignable a ' +  v.id);
                            }                        
                        }else{
                            if(variable.tipo < 8){
                                if(Tipo[value.tipo] == Tipo[variable.tipo]){
                                    newEnv.guardarVariable(func.parametros![i].id, value.value, value.tipo, true);
                                }else{
                                    throw new Error_(this.linea, this.columna, 'Semantico', 'Tipos incompatibles ' + Tipo[value.tipo] + ' no asignable a ' +  Tipo[variable.tipo]);
                                }
                            }else{
                                if(value.tipo == variable.tipo || value.tipo == Tipo.NULL){
                                    newEnv.guardarVariable(func.parametros![i].id, value.value, variable.tipo, true);
                                }else{
                                    throw new Error_(this.linea, this.columna, 'Semantico', 'Tipos incompatibles ' + Tipo[value.tipo] + ' no asignable a ' +  Tipo[variable.tipo]);
                                }                                
                            }

                        }
                    }                
                }
                newEnv.cantidadFunciones++;
                for(const instr of func.code){
                    try {
                        if(instr instanceof Instruction){
                            const element = instr.execute(newEnv);
                            if(element != undefined || element != null)
                                return element;

                                            //Verificar si existe return
                if(instr instanceof Return){
                    //Verificar si la funcion tiene tipo explicito
                    if(func.tipo != Tipo.NULL){
                        //Verificar si el retorno y la funcion son del mismo tipo
                        if(instr.result?.tipo == func.tipo){
                            return instr.result;
                        }else{
                            throw new Error_(this.linea, this.columna, 'Semantico', 'Tipos incompatibles ' + Tipo[instr.result?.tipo!] + ' no asignable a ' +  Tipo[func.tipo]);
                        }
                    }else{
                        func.tipo = instr.result?.tipo!;
                        return instr.result;
                    }
                }
                            
                        }else{
                            //errores.push(new Error_(this.linea, this.columna, 'Sintactico', 'Caracter inesperado: ' + instr));
                            throw new Error_(this.linea, this.columna, 'Sintactico', 'Caracter inesperado: ' + instr);
                        }                
                    } catch (error) {
                        errores.push(error);
                    }
                }
                newEnv.cantidadFunciones--;
                //TODO validar que el tipo de retorno se pueda operar
            }else{
                throw new Error_(this.linea, this.columna, ' Semantico ', this.id + ' no esta definida ' );
            }
            return null;
        }catch(error){
            errores.push(error);
        }
        return null;
    }
}
