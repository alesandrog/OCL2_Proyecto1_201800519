import { Instruccion } from "../Abstract/Instruccion";
import { Expresion } from "../Abstract/Expresion";
import { Entorno } from "../Symbol/Entorno";
import { MapTraducidos } from "../MapsGlobales";


export class LlamadaFuncion extends Instruccion{

    public puntoc : string = "";
    constructor(private id: string,  public parametros : Expresion[] | null){
        super();
    }

    public traducir(entorno : Entorno) :string {
        let params = "";
        if(this.parametros != null){
            for(let i = 0; i < this.parametros.length; i++){
                if(i != this.parametros.length-1){
                    params += `${this.parametros[i].traducir(entorno)},`;                
                }else{
                    params += `${this.parametros[i].traducir(entorno)}`;                                
                }
            }
        }
        let id = "";
        if(MapTraducidos.has(this.id)){
            id = MapTraducidos.get(this.id);
            return `${id}(${params})${this.puntoc}`;
        }
        return `${this.id}(${params})${this.puntoc}`;
    }
}
