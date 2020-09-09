import { Expresion } from "../Abstract/Expresion";
import { Entorno } from "../Symbol/Entorno";
import { Retorno } from "../Abstract/Retorno";
import { Error_ } from "../Error/Error";
import { Arreglo2 } from "../Instruction/Arreglo2";

export class AccesoIndice extends Expresion{

    public id : string;
    public anterior : Expresion | AccesoIndice | null;
    public indice : Expresion;

    constructor(id: string,  anterior : Expresion | AccesoIndice | null, indice : Expresion ,linea : number, columna: number){
        super(linea, columna);
        this.id = id;
        this.anterior = anterior;
        this.indice = indice;
    }

    public execute(entorno : Entorno): any {
        let valor : any;
        if(this.anterior != null){
            if(this.anterior instanceof AccesoIndice){
                this.anterior.id = this.id;
                valor = this.anterior.execute(entorno).value;
                const index = this.indice.execute(entorno);
                return valor[index.value];                   
                //if(valor instanceof Arreglo2){
                //   return valor.get(index.value);         
                //}                
            }
        }else{
            let arreglo : any;
            arreglo = entorno.getVariable(this.id)?.valor;
            //if(arreglo instanceof Arreglo2){
            const index = this.indice.execute(entorno );
            return arreglo[index.value];
            //console.log(arreglo.get(index.value));
                //let ret =  arreglo.get(index.value);
                //console.log(ret);            
                //return ret;
           // }
        }
    }
}