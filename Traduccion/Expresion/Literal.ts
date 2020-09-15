import { Expresion } from "../Abstract/Expresion";
import { Entorno } from "../Symbol/Entorno";


export class Literal extends Expresion  {

    private valor : string;
    constructor( valor : string ) {
      super();
      this.valor = valor;
  }

  public traducir(entorno : Entorno) :string{
    return this.valor;
  }
}