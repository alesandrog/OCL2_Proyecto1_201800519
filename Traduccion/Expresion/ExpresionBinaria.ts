import { Expresion } from "../Abstract/Expresion";
import { Entorno } from "../Symbol/Entorno";


export class ExpresionBinaria extends Expresion  {

    private izq: Expresion;
    private der: Expresion;
    private operador: string;

    constructor( izq : Expresion, der : Expresion, operador:string  ) {
      super();
      this.izq = izq;
      this.der = der;
      this.operador = operador;
  }

  public traducir(entorno : Entorno) :string{
    const vizq = this.izq.traducir(entorno);
    const vder = this.der.traducir(entorno);
    return `${vizq}${this.operador}${vder}`;
  }
}