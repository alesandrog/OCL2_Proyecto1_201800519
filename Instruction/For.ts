import { Instruction } from "../Abstract/Instruccion";
import { Expresion } from "../Abstract/Expresion";
import { Entorno } from "../Symbol/Entorno";
import { Tipo } from "../Abstract/Retorno";
import { Error_ } from "../Error/Error";
import { BloqueInstrucciones } from "./BloqueInstrucciones";
import { Break } from "./Break";
import { Continue } from "./Continue";
import { Asignacion } from "./Asignacion";
import { Declaration } from "./Declaracion";

export class For extends Instruction {
  constructor(
    private declaracion : Declaration | Asignacion,
    private condicion: Expresion,
    private actualizacion : Asignacion,
    private code: BloqueInstrucciones,
    linea: number,
    columna: number
  ) {
    super(linea, columna);
  }

  public execute(entorno: Entorno) {
    let env = new Entorno(entorno);
    this.declaracion.execute(env);
    let condicion = this.condicion.execute(env);
    if(condicion.tipo != Tipo.BOOLEAN)
        return;    
        //throw error
    while (condicion.value == true) {
        env.cantidadCiclos++;
        const exec = this.code.execute(env);
        env.cantidadCiclos--;
        if (exec instanceof Break) {
          break;
        }
        else if( exec instanceof Continue)
          continue;
        
        this.actualizacion.execute(env);
        condicion = this.condicion.execute(env);
        if (condicion.tipo != Tipo.BOOLEAN) {
          //errpr
        }
      }
    
  }
}