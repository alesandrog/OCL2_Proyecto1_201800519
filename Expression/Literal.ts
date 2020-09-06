import { Expresion } from "../Abstract/Expresion";
import { Retorno, Tipo } from "../Abstract/Retorno";

export class Literal extends Expresion{
    
    constructor(private value : any, linea : number, columna: number, private tipo : number){
        super(linea, columna);
    }

    public execute() : Retorno{
        if(this.tipo == Tipo.NUMBER)
            return {value : Number(this.value), tipo : Tipo.NUMBER};
        else if(this.tipo == Tipo.BOOLEAN){
            if(this.value == "true"){
                return { value : true, tipo: Tipo.BOOLEAN}
            }else{
                return { value : false, tipo: Tipo.BOOLEAN}

            }
        }else if(this.tipo == Tipo.STRING)
            return {value : this.value , tipo : Tipo.STRING};
        else if(this.tipo == Tipo.ARRAY){
            console.log(this.value[0].value[0].value);
            return { value: this.value , tipo : Tipo.NULL};
        }            
        else
            return { value: this.value , tipo : Tipo.NULL};
    }
}

/*

expressions
    : e EOF
        { 
            console.log("final");
            console.log($1);
        }
    ;

e
   : corchs { }
;

corchs 
  :  '[' corchs  ']'  
{ 
var arr = eval('$$'); 
var tope = arr.length;

var res = arr[tope -2];
res = [$2];
console.log(res);
$$ = res;

}
  | '[' lista ']' { $$ = $2;  } 
;

lista 
  : lista 'ID' { $1.push($2) ; $$ = $1; }
  | 'ID' { $$ = [$1]; }
;


*/