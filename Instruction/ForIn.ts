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

export class ForIn extends Instruction {
 
    private declaracion : Declaration;
    private arreglo: Expresion;
    private limite : number;
    private code: BloqueInstrucciones;

  constructor( declaracion : Declaration , arreglo : Expresion, code : BloqueInstrucciones, linea: number, columna: number) {
    super(linea, columna);
    this.declaracion = declaracion;
    this.arreglo = arreglo;
    this.code = code;
    this.limite = 0;
  }

  //TODO validaciones de errores

  public execute(entorno: Entorno) {
    
    //Declarar la variable en un nuevo entorno

    const iterador = this.arreglo.execute(entorno);

    if(iterador.tipo != Tipo.ARRAY)
        return;    //error

    //establecer limite del for
    this.limite = iterador.value.length;
    
    for(let i = 0; i < this.limite; i++){
        entorno.guardarVariable(this.declaracion.id, i, Tipo.NUMBER, this.declaracion.variable);
        this.code.execute(entorno);    
    }
    
  }
}