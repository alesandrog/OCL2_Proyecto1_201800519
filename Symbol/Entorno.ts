import { Simbolo } from "./Simbolo";
import { Tipo } from "../Abstract/Retorno";
import { Funcion } from "../Instruction/Funcion";
import { SimboloArreglo } from "./SimboloArreglo";
//importar funciones

export class Entorno{
    
    private variables : Map<string, Simbolo>;
    private funciones : Map<string , Funcion>;
    public cantidadCiclos : number;
    public cantidadFunciones : number;
    //map de funciones

    constructor(public anterior : Entorno | null){
        this.variables = new Map();
        this.funciones = new Map();
        this.cantidadCiclos = 0;
        this.cantidadFunciones = 0;
        //inicializar map de funciones
    }

    //TODO errores cuando no existan funciones
    public guardarVariable(id: string, valor: any, tipo:Tipo, variable:boolean ){
        let env : Entorno | null = this;
        while(env != null){
            if(env.variables.has(id)){
                env.variables.set(id, new Simbolo(valor, id, tipo, variable));
                return;
            }
            env = env.anterior;
        }
        this.variables.set(id, new Simbolo(valor, id, tipo, variable));
    }

    public guardarArreglo(id: string, valor: any, tipo:Tipo, variable:boolean, dimension : number, tipoExp : Tipo ){
        let env : Entorno | null = this;
        while(env != null){
            if(env.variables.has(id)){
                env.variables.set(id, new SimboloArreglo(valor, id, tipo, variable, dimension , tipoExp));
                return;
            }
            env = env.anterior;
        }
        this.variables.set(id, new SimboloArreglo(valor, id, tipo, variable, dimension , tipoExp));
    }

    public getVariable(id: string) : Simbolo | undefined | null{
        let env : Entorno | null = this;
        while(env != null){
            if(env.variables.has(id)){
                return env.variables.get(id);
            }
            env = env.anterior;
        }
        return null;
    }   

    public guardarFuncion(id: string, funcion : Funcion){
        let env : Entorno | null = this;
        while(env != null){
            if(env.funciones.has(id)){
                //env.variables.set(id, new Simbolo(valor, id, tipo));
                //throw error
                //TODO error cuando existe la funcion
                return;
            }
            env = env.anterior;
        }
        this.funciones.set(id, funcion);
    }

    public getFuncion(id: string) : Funcion | undefined{
        let env : Entorno | null = this;
        while(env != null){
            if(env.funciones.has(id)){
                return env.funciones.get(id);
            }
            env = env.anterior;
        }
        return undefined;
    }

    public getGlobal() : Entorno{
        let env : Entorno | null = this;
        while(env?.anterior != null){
            env = env.anterior;
        }
        return env;
    }
}