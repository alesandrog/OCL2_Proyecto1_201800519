import { Instruction } from "../Abstract/Instruccion";
import { Entorno } from "../Symbol/Entorno";
import { Expresion } from "../Abstract/Expresion";
import { Case } from "./Case";
import { errores } from "../Error/Errores";


export class Switch extends Instruction{
    
    public condicion : Expresion;
    private cases : Case[];
    private def : Instruction[] | null;

    constructor(condicion : Expresion, cases : Case[] , def : Instruction[] | null, linea :number , columna : number){
        super(linea , columna);
        this.condicion = condicion;
        this.cases = cases;
        this.def = def;
    }
    //TODO validar errores
    public execute(entorno:Entorno) {
        const switchVal = this.condicion.execute(entorno);
        for(const instr of this.cases){
            let caseVal = instr.condicion.execute(entorno);
            if(switchVal.value == caseVal.value){
                instr.execute(entorno);
                return;
            }
         }
         if(this.def != null){
             entorno.cantidadCiclos++;            
             for(const instr of this.def){
                instr.execute(entorno)
            }
            entorno.cantidadCiclos--;
         }
    }
}