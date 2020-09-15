import { Entorno } from "../Symbol/Entorno"

export abstract class Instruccion {


    constructor() {
    }

    public abstract traducir(entorno : Entorno): string;

}