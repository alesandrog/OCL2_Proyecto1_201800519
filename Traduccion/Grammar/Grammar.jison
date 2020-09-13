%{
    const { MapTraducidos } = require('../MapTraducidos');
    const { ListaInstrucciones } = require('../ListaInstrucciones');    


%}
/*
HijosFun
    : InstruccionesFun HijosFun
    | funcionFun HijosFun
;
*/
%lex
%options case-sensitive
entero  [0-9]+
decimal {entero}"."{entero}
cadena  (\"[^"]*\")
%%
\s+                   /* skip whitespace */
"//".*										// comentario simple línea
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]			// comentario multiple líneas

{entero}                return 'ENTERO'
{decimal}               return 'DECIMAL'
{cadena}                return 'CADENA'

//Operaciones Aritmeticas
"*"                     return '*'
"/"                     return '/'
"+="                    return '+='
"++"                    return '++'
"--"                    return '--'
"-"                     return '-'
"+"                     return '+'
"^"                     return '^'
"%"                     return '%'



//Operaciones Relacionales
"<="                    return '<='
">="                    return '>='
"<"                     return '<'
">"                     return '>'
"=="                    return '=='
"!="                    return '!='
"="                     return '='

//Operaciones Logicas
"||"                    return '||'
"&&"                    return '&&'
"!"                     return '!'

//Elementos de sintaxis
"("                     return '('
")"                     return ')' 
"{"                     return '{'
"}"                     return '}'
";"                     return ';'
":"                     return ':'
"["                     return '['
"]"                     return ']'
","                     return ','
"."                     return '.'
"`"                     return '`'
"$"                     return '$'
"?"                     return '?'
"\""                    return '"'
"\'"                    return '\''

/*-----------RESERVADAS-------------------*/

//Estructuras de Control
"if"                    return 'IF'
"else"                  return 'ELSE'
"switch"                return 'SWITCH'
"case"                  return 'CASE'
"default"               return 'DEFAULT'
"while"                 return 'WHILE'
"do"                    return 'DO'
"for"                   return 'FOR'
"in"                    return 'IN'
"of"                    return 'OF'
"true"                  return 'TRUE'
"false"                 return 'FALSE'

//Sentencias de transferencia
"return"                return 'RETURN'
"break"                 return 'BREAK'
"continue"              return 'CONTINUE'

//Funciones y declaracciones
"function"              return 'FUNCTION'
"let"                   return 'LET'
"const"                 return 'CONST'
"console"               return 'CONSOLE'
"log"                   return 'LOG'
"graficar_ts"           return 'GRAFICAR'


//Arrays
"push"                  return 'PUSH'
"pop"                   return 'POP'
"length"                return 'LENGTH'

//Tipos de dato
"void"                  return 'VOID'
"number"                return 'NUMBER'
"string"                return 'STRING'
"boolean"               return 'BOOLEAN'
"type"                  return 'TYPE'


([a-zA-Z_])[a-zA-Z0-9_ñÑ]*	return 'ID';
<<EOF>>		            return 'EOF'
.   { 
    let error_lexico = new Error_(yylloc.first_line, yylloc.first_column, 'Lexico', yytext);
    errores.push(error_lexico);
    }

/lex

%left '||'
%left '&&'
%left '==', '!='
%left '>=', '<=', '<', '>'
%left '+' '-'
%left '*' '/'
%right '!'

%start Init

%%

Init    
    : Instrucciones EOF 
    {
        return $1;
    } 
;

Instrucciones
    : Instrucciones instruccion{
        $1.push($2);
        $$ = $1;
    }
    | instruccion{
        $$ = [$1];
    }
;

instruccion
    : declaracion 
    | asignacion ';'
    | funcion
    {
        console.log($1.traduccion);
        for(let i = ListaInstrucciones.length -1; i >= 0; i--){
            console.log(ListaInstrucciones[i]);
        }
    }
    | 'GRAFICAR' '(' ')'
    {
        //$$ = new Graficar(@1.first_line , @1.first_column);
    }
    | 'BREAK' ';'
    {
       // $$ = new Break(@1.first_line , @1.first_column);
    }
    | 'CONTINUE' ';'
    {
     //   $$ = new Continue(@1.first_line , @1.first_column);
    }
    | 'RETURN' Expr ';'
    {
     //   $$ = new Return($2 , @1.first_line , @1.first_column);
    }
    | 'RETURN' ';'
    {
       // $$ = new Return(null , @1.first_line , @1.first_column);
    }
    | 'ID' '++'
    {
      //  $$ = new Incremento( $1 , $2 , @1.first_line , @1.first_column);
    }
    | 'ID' '--'
    {
     //   $$ = new Incremento( $1 , $2 , @1.first_line , @1.first_column);
    }    
    | error  { 
//    let error_sintactico = new Error_(this._$.first_line, this._$.first_column, 'Sintactico', yytext);
//    errores.push(error_sintactico);
    }
;
/*--------------------------------------Declaracion y Asignacion de variables----------------------------------*/

declaracion
    : 'LET'   'ID' ':' tipo corchetes '=' Expr ';'
    { 
    }
    | 'LET'   'ID' ':' tipo '=' '{' atributosType '}'
    { 
    }    
    | 'LET'   'ID' ':' tipo  corchetes ';'
    { 
    }        
    | 'LET'   'ID' ':' tipo '=' Expr ';'
    { 
    }
    | 'LET'   'ID' ':' tipo ';'
    { 
    }   
    | 'LET'   'ID'  '=' Expr ';'
    {
        $$ = { traduccion : `let ${$2} = ${$4};` };
    }    
    | 'LET' 'ID' ';'
    {
    }
    | 'CONST' 'ID' ':' tipo corchetes '=' Expr ';'
    { 
    }    
    | 'CONST' 'ID' ':' tipo '=' Expr ';'
    { 
    }
    | 'CONST' 'ID' '=' Expr ';'
    { 

    }
;

corchetes
    : corchetes '[' ']'
    {

    }
    | '[' ']'
    {
    }
;


tipo
    : 'NUMBER'
    {
    }
    | 'STRING'
    {
    }    
    | 'BOOLEAN'
    {
    }
    | 'VOID'
    {
    }
    | 'ID'
    {
    }
;



asignacion    
    : 'ID' accesosCorchetes '=' Expr 
    {

    }
    | 'ID' '+=' Expr 
    {
    }    
    | 'ID' '=' Expr 
    {
    }
;


/*-----------------------------------------FUNCIONES------------------------------------------------*/


//Funcion Global
funcion
    : 'FUNCTION' idFuncion '(' parametrosFuncion ')' tipoFuncion  '{' InstruccionesFun '}' 
    {
        var trad = `function ${$2.id}() { \n ${$8.traduccion}\n }`;
        $$ = { traduccion: trad };
    }
;

idFuncion
    : 'ID'
    {
        $$ = {
            padre : "",
             id : $1
        };
    }       
;

parametrosFuncion
    : parametros { $$ = { traduccion : " " }; }
    | { $$ = { traduccion : " " }; }
;

tipoFuncion
    : ':' tipo { $$ = { traduccion : " " }; }
    | { $$ = { traduccion : " " }; }
;


InstruccionesFun
    : instrFor InstruccionesFun
    {
        $$ = { traduccion : $1.traduccion + "\n" + $2.traduccion };
    } 
    | 
    {
        $$ = { traduccion : "" };
    }
;

instrFor
    : declaracion
    { 
        var pila = eval('$$');
        var tope = pila.length - 1;
        console.log("ando en decla");
        console.log(pila);
        if(pila[tope - 1] == "{"){
        console.log(pila[tope - 4]);            
        console.log(pila[tope - 5]);            
        console.log(pila[tope - 6].id);
        console.log(pila[tope - 7]);
        $$ = { padre : pila[tope - 6].id , traduccion : $1.traduccion  }; 
        }else{
        console.log("else decla");
        console.log(pila);
        $$ = { padre : pila[tope - 1].padre , traduccion : $1.traduccion }; 
        }
    }
    | asignacion  
    { 
        $$ = { padre : "piola asig" };
    }
    | funcionFun 
    { 
        var pila = eval('$$');
        var tope = pila.length - 1;
        $$ = { padre : pila[tope - 1].padre ,  traduccion : $1.traduccion }; 

    }
;

funcionFun
    : 'FUNCTION' idFunAnid '(' parametrosFuncion ')' tipoFuncion  '{' InstruccionesFun '}'
    {
        var t = `function ${$2.id} () { \n ${$8.traduccion} \n}`;
        ListaInstrucciones.push(t);

        $$ = { traduccion : "" };
    } 
;
idFunAnid
    : 'ID'
    {
        //pushear a map traducidas
        var pila = eval('$$');
                console.log("ando en funcion");
        console.log(pila);
        var tope = pila.length - 1;
        if(pila[tope - 2] == '{'){
            $$ = { padre : pila[tope - 6].id , id: pila[tope - 6].id + `_${$1}`  }; 
        }else{
            $$ = { padre : pila[tope - 2].padre , id: pila[tope - 2].padre + "_" + $1 }; 
        }
    }
;
parametros
    : parametros ',' parametro
    {
    }    
    | parametro
    {
    }    
;

parametro
    : 'ID' ':' tipo
    {
    }
;



/*----------------------------------------Expresiones Aritmeticas y Logicas--------------------------------------*/
Expr
    : Expr '+' Expr
    {
        $$ = $1 + $2 + $3;
    }       
    | Expr '-' Expr
    {
        $$ = $1 + $2 + $3;
    }
    | Expr '*' Expr
    { 
        $$ = $1 + $2 + $3;
    }       
    | Expr '/' Expr
    {
        $$ = $1 + $2 + $3;
    }
    | Expr '<' Expr
    {
        $$ = $1 + $2 + $3;
    }
    | Expr '<=' Expr
    {
        $$ = $1 + $2 + $3;
    }
    | Expr '>' Expr
    {
        $$ = $1 + $2 + $3;
    }
    | Expr '>=' Expr
    {
        $$ = $1 + $2 + $3;
    }
    | Expr '==' Expr
    {
        $$ = $1 + $2 + $3;
    }
    | Expr '!=' Expr
    {
        $$ = $1 + $2 + $3;
    }
    | Expr '&&' Expr
    {
        $$ = $1 + $2 + $3;
    }
    | Expr '||' Expr
    {
        $$ = $1 + $2 + $3;
    }
    | '!' Expr
    {
        $$ = $1 + $2;
    }            
    | F
    {
        $$ = $1;
    }
;


F   : '(' Expr ')'
    { 
        $$ = '('+ $2  +')';
    }
    | 'DECIMAL'
    { 
         $$ = $1;
    }
    | 'ENTERO'
    { 
         $$ = $1
    }
    | 'CADENA'
    {
         $$ = $1.replace(/\"/g,"");
    }
    | 'TRUE'
    { 
        $$ = $1;
    }
    | 'FALSE'
    { 
        $$ = $1;
    }      
    | 'ID' '++'
    {
        $$ = $1 + "++";

    }
    | 'ID' '--'
    {
        $$ = $1 + "--";
    }
    | 'ID' {
         $$ = $1;
    }
;