import { Instruction } from "../Abstract/Instruccion";
import { Entorno } from "../Symbol/Entorno";
import { Expresion } from "../Abstract/Expresion";
import { errores } from "../Error/Errores";


export class Case extends Instruction{
    
    public condicion : Expresion;
    private code : Instruction[];
    
    constructor(condicion : Expresion, code : Instruction[] , linea :number , columna : number){
        super(linea , columna);
        this.condicion = condicion;
        this.code = code;
    }

    public execute(entorno:Entorno) {
        const newEnv = new Entorno(entorno);
        newEnv.cantidadCiclos = entorno.cantidadCiclos;
        newEnv.cantidadCiclos++;
        newEnv.cantidadFunciones = entorno.cantidadFunciones;
        for(const instr of this.code){
            try {
                const element = instr.execute(newEnv);
                if(element != undefined || element != null)
                    return element;                
            } catch (error) {
                errores.push(error);
            }
        }
        newEnv.cantidadCiclos--;
    }
}