import { Expresion } from "../Abstract/Expresion";
import { Instruccion } from "../Abstract/Instruccion";
import { Entorno } from "../Symbol/Entorno";

export class Switch extends Instruccion{

    constructor(private exp : Expresion , private code : Instruccion[], private def : Instruccion[] | null){
        super();
    }

    public traducir(entorno : Entorno) : string {
        const newEnv = new Entorno(entorno);
        let cod = "";
        for(const instr of this.code){
            cod += `${instr.traducir(newEnv)}\n`;
        }
        let cod_def = "";
        if(this.def != null){
            for(const instr of this.def){
                cod_def += `${instr.traducir(newEnv)}\n`;
            }
            cod += `default : \n${cod_def}\n`;
        }
        let condicion = this.exp.traducir(entorno);
        return `switch(${condicion}){\n${cod}}`;
    }
}