import { Instruccion } from "../Abstract/Instruccion";
import { Expresion } from "../Abstract/Expresion";
import { Entorno } from "../Symbol/Entorno";
import { BloqueInstrucciones } from "./BloqueInstrucciones";

export class If extends Instruccion{

    constructor(private condicion : Expresion, private code : BloqueInstrucciones , private elsSt : any){
        super();
    }

    public traducir(entorno : Entorno ) : string {

        let condicion = this.condicion.traducir(entorno);
        let codigo = this.code.traducir(entorno);

        let traduccion = `if(${condicion}){\n${codigo}\n}`;
        
        if(this.elsSt != null){
            traduccion += `else ${this.elsSt.traducir(entorno)}`;            
            return traduccion;
        }
        return traduccion;
    }
}