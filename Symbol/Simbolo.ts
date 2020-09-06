import { Tipo } from "../Abstract/Retorno";

export class Simbolo{
    public valor :any;
    public id : string;
    public tipo : Tipo;
    public variable : boolean;
    public dimension : number;

    constructor(valor: any, id: string, tipo: Tipo, variable : boolean , dimension : number){
        this.valor = valor;
        this.id = id;
        this.tipo = tipo;
        this.variable = variable;
        this.dimension = dimension;
    }
}