import { Instruccion } from "../Abstract/Instruccion";
import { Expresion } from "../Abstract/Expresion";
import { Entorno } from "../Symbol/Entorno";

export class SentenciaSalida extends Instruccion{

    constructor(private tipo : number, private code : Expresion | null ){
        super();
    }

    public traducir(entorno : Entorno ) : string {

        if(this.tipo == 1){ //return
            if(this.code != null){
                let exp = this.code.traducir(entorno);
                return `return ${exp};`;
            }else{
                return `return;`;
            }
        }else if(this.tipo == 2){ //break
            return `break;`;
        }else { //continue
            return `continue;`;
        }
    }
}