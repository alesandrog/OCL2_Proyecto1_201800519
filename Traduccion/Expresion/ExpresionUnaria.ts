import { Expresion } from "../Abstract/Expresion";
import { Entorno } from "../Symbol/Entorno";


export class ExpresionUnaria extends Expresion  {

    private izq: Expresion;
    private operador: string;

    constructor( izq : Expresion, operador:string  ) {
      super();
      this.izq = izq;
      this.operador = operador;
  }

  public traducir(entorno : Entorno) :string{
    const vizq = this.izq.traducir(entorno);
    if(this.operador == '++'){
        return `${vizq}${this.operador}`;
    }else if(this.operador == '--'){
        return `${vizq}${this.operador}`;
    }else if(this.operador == '!'){
        return `${this.operador}${vizq}`;
    }else if(this.operador == '('){
      return `(${vizq})`;
  }
    return "";
  }
}