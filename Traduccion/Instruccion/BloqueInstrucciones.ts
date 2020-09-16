import { Instruccion } from "../Abstract/Instruccion";
import { Entorno } from "../Symbol/Entorno";

export class BloqueInstrucciones extends Instruccion{

    constructor(private code : Instruccion[]){
        super();
    }

    public traducir(entorno : Entorno) : string {
        const newEnv = new Entorno(entorno);
        let res = "";
        for(const instr of this.code){
            res += instr.traducir(newEnv) + "\n";
        }
        return res;
    }
}