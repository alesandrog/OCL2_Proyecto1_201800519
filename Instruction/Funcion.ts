  
import { Instruction } from "../Abstract/Instruccion";
import { Entorno } from "../Symbol/Entorno";
import { BloqueInstrucciones } from "../Instruction/BloqueInstrucciones";
import { Parametro } from "./Parametro";
import { Tipo } from "../Abstract/Retorno";

export class Funcion extends Instruction{

    constructor(private id: string, public code: BloqueInstrucciones, public parametros : Parametro[] | null, public tipo :Tipo,  line : number, column : number){
        super(line, column);
    }

    public execute(entorno : Entorno) {
        entorno.guardarFuncion(this.id, this);
    }
}
