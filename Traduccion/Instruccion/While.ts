import { Instruccion } from "../Abstract/Instruccion";
import { Expresion } from "../Abstract/Expresion";
import { Entorno } from "../Symbol/Entorno";
import { BloqueInstrucciones } from "./BloqueInstrucciones";

export class While extends Instruccion{

    constructor(private condicion : Expresion, private code : BloqueInstrucciones , private tipo : number){
        super();
    }

    public traducir(entorno : Entorno ) : string {

        let condicion = this.condicion.traducir(entorno);
        let codigo = this.code.traducir(entorno);

        if(this.tipo == 1){ //while
            return `while(${condicion}){\n${codigo}\n}`;
        }else{
            return `do{\n${codigo}\n}while(${condicion});`;
        }
    }
}