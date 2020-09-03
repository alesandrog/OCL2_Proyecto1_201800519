import { Expresion } from "../Abstract/Expresion";
import { Retorno, Tipo } from "../Abstract/Retorno";
import { Entorno } from "../Symbol/Entorno";
import { Error_ } from "../Error/Error";

export enum OperacionesAritmeticas {
  SUMA,
  RESTA,
  MULTIPLICACION,
  DIVISION,
}

export class ExpresionAritmetica extends Expresion {
  constructor(
    private izq: Expresion,
    private der: Expresion,
    private tipo: OperacionesAritmeticas,
    linea: number,
    columna: number
  ) {
    super(linea, columna);
  }

  public execute(entorno: Entorno): Retorno {
    const izq = this.izq.execute(entorno);
    const der = this.der.execute(entorno);
    let result: Retorno;
    const tipoDominante = this.tipoDominante(izq.tipo, der.tipo);

    if (this.tipo == OperacionesAritmeticas.SUMA) {
      if (tipoDominante == Tipo.STRING)
        result = {
          value: izq.value.toString() + der.value.toString(),
          tipo: Tipo.STRING,
        };
      else if (tipoDominante == Tipo.NUMBER)
        result = { value: izq.value + der.value, tipo: Tipo.NUMBER };
      else
        throw new Error_(
          this.linea,
          this.columna,
          "Semantico",
          "No se puede operar: " + Tipo[izq.tipo] + " + " + Tipo[der.tipo]
        );
    } else if (this.tipo == OperacionesAritmeticas.RESTA) {
      if (tipoDominante != Tipo.NUMBER)
        throw new Error_(
          this.linea,
          this.columna,
          "Semantico",
          "No se puede operar: " + Tipo[izq.tipo] + " - " + Tipo[der.tipo]
        );
      result = { value: izq.value - der.value, tipo: Tipo.NUMBER };
    } else if (this.tipo == OperacionesAritmeticas.MULTIPLICACION) {
      if (tipoDominante != Tipo.NUMBER)
        throw new Error_(
          this.linea,
          this.columna,
          "Semantico",
          "No se puede operar: " + Tipo[izq.tipo] + " * " + Tipo[der.tipo]
        );
      result = { value: izq.value * der.value, tipo: Tipo.NUMBER };
    } else {
      if (der.value == 0) {
        throw new Error_(
          this.linea,
          this.columna,
          "Semantico",
          "No se puede operar: " + Tipo[izq.tipo] + " / 0"
        );
      }
      if (tipoDominante != Tipo.NUMBER)
        throw new Error_(
          this.linea,
          this.columna,
          "Semantico",
          "No se puede operar: " + Tipo[izq.tipo] + " / " + Tipo[der.tipo]
        );
      result = { value: izq.value / der.value, tipo: Tipo.NUMBER };
    }
    return result!;
  }
}
