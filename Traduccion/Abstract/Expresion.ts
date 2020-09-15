import { Entorno } from "../Symbol/Entorno"

export abstract class Expresion {


    constructor() {
    }

    public abstract traducir(entorno : Entorno): string;

}