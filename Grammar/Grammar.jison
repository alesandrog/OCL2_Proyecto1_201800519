%{
    const { Tipo } = require('../Abstract/Retorno');
    const {ExpresionAritmetica, OperacionesAritmeticas} = require('../Expression/ExpresionAritmetica');
    const { Access } = require('../Expression/Access');
    const { AccesoArray } = require('../Expression/AccesoArray');    
    const { Literal } = require('../Expression/Literal');
    const { Arreglo } = require('../Expression/Arreglo');
    const { Declaration } = require('../Instruction/Declaracion');
    const { DeclaracionArreglo } = require('../Instruction/DeclaracionArreglo');    
    const { If } = require('../Instruction/If');     
    const { While } = require('../Instruction/While');
    const { DoWhile } = require('../Instruction/DoWhile');
    const { Asignacion } = require('../Instruction/Asignacion');    
    const { Console } = require('../Instruction/Console');
    const { Switch } = require('../Instruction/Switch');
    const { LlamadaFuncion } = require('../Instruction/LlamadaFuncion');
    const { BloqueInstrucciones } = require('../Instruction/BloqueInstrucciones');    
    const { Case } = require('../Instruction/Case');    
    const { ExpresionLogica , OperacionLogica } = require('../Expression/ExpresionLogica');
    const { ExpresionUnaria , OperacionUnaria } = require('../Expression/OperacionUnaria');
    const { Funcion } = require('../Instruction/Funcion');
    const { Break } = require('../Instruction/Break');
    const { Continue } = require('../Instruction/Continue');
    const { Return } = require('../Instruction/Return');
    const { Parametro } = require('../Instruction/Parametro');

%}

%lex
%options case-sensitive
entero  [0-9]+
decimal {entero}"."{entero}
cadena  (\"[^"]*\")
%%
\s+                   /* skip whitespace */

{entero}                return 'ENTERO'
{decimal}               return 'DECIMAL'
{cadena}                return 'CADENA'

//Operaciones Aritmeticas
"*"                     return '*'
"/"                     return '/'
"-"                     return '-'
"+"                     return '+'
"++"                    return '++'
"--"                    return '--'
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

//Comentarios
"\/\/"                  return '//'
"\/\*"                  return '/*'
"*/"                    return '*/'

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
"Length"                return 'LENGTH'

//Tipos de dato
"void"                  return 'VOID'
"number"                return 'NUMBER'
"string"                return 'STRING'
"boolean"               return 'BOOLEAN'
"type"                  return 'TYPE'


([a-zA-Z_])[a-zA-Z0-9_ñÑ]*	return 'ID';
<<EOF>>		            return 'EOF'


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
    | If         
    | asignacion 
    | While
    | DoWhile
    | Switch
    | Console
    | funcion
    | llamadaFuncion
    | 'BREAK' ';'
    {
        $$ = new Break(@1.first_line , @1.first_column);
    }
    | 'CONTINUE' ';'
    {
        $$ = new Continue(@1.first_line , @1.first_column);
    }
    | 'RETURN' Expr ';'
    {
        $$ = new Return($2 , @1.first_line , @1.first_column);
    }
    | 'RETURN' ';'
    {
        $$ = new Return(null , @1.first_line , @1.first_column);
    }
;
/*--------------------------------------Declaracion y Asignacion de variables----------------------------------*/

declaracion
    : 'LET'   'ID' ':' tipo corchetes '=' Expr ';'
    { 
        /* let arr : number[][] = [[5]];*/
        $$ = new DeclaracionArreglo( $2 , $7 , true, Tipo.ARRAY , $5, $4, @1.first_line , @1.first_column);
    }
    | 'LET'   'ID' ':' tipo  corchetes ';'
    { 
        /* let arr : number[][]; */
        $$ = new DeclaracionArreglo( $2 , null , true, Tipo.ARRAY , $5, $4, @1.first_line , @1.first_column);
    }    
    | 'LET'   'ID' ':' tipo '=' Expr ';'
    { 
        /* let arr : number = 5;*/        
        $$ = new Declaration( $2 , $6 , true, $4,  @1.first_line , @1.first_column);
    }
    | 'LET'   'ID' ':' tipo ';'
    { 
        /* let arr : number;*/        
        $$ = new Declaration( $2 , null , true, $4,  @1.first_line , @1.first_column);
    }   
    | 'LET'   'ID'  '=' Expr ';'
    {
         /* let arr = 5;*/
        $$ = new Declaration( $2 , $4 , true, Tipo.NULL, @1.first_line , @1.first_column);
    }    
    | 'LET' 'ID' ';'
    {
        /* let arr; */
        $$ = new Declaration( $2 , null , true, Tipo.NULL, @1.first_line , @1.first_column);
    }
    | 'CONST' 'ID' ':' tipo corchetes '=' Expr ';'
    { 
        /* const arr : number[][] = [[5]];*/
        $$ = new DeclaracionArreglo( $2 , $7 , false, Tipo.ARRAY , $5, $4, @1.first_line , @1.first_column);
    }    
    | 'CONST' 'ID' ':' tipo '=' Expr ';'
    { 
        /* const arr : number = 5;*/
        $$ = new Declaration( $2 , $6 , false, $4, @1.first_line , @1.first_column);
    }
    | 'CONST' 'ID' '=' Expr ';'
    { 
         /* const arr  = 5;*/
        $$ = new Declaration( $2 , $4 , false, Tipo.NULL, @1.first_line , @1.first_column);
    }
;

corchetes
    : corchetes '[' ']'
    {
        var cantidad = eval('$1');
        $$ = parseInt( cantidad++);
    }
    | '[' ']'
    {
        $$ = 1;
    }
;


tipo
    : 'NUMBER'
    {
        $$ = Tipo.NUMBER;
    }
    | 'STRING'
    {
        $$ = Tipo.STRING;
    }    
    | 'BOOLEAN'
    {
        $$ = Tipo.BOOLEAN;
    }
    | 'VOID'
    {
        $$ = Tipo.VOID;
    }
    | 'ID'
    {
        $$ = Tipo.STRING;
    }
;

asignacion    
    : 'ID' '=' Expr ';'
    {
        $$ = new Asignacion( $1 , $3 , @1.first_line , @1.first_column);
    }
;


/*-----------------------------------------Funciones , llamadas y parametros------------------------------------*/

Console 
    : 'CONSOLE' '.' 'LOG' '(' Expr ')' ';'
    {   $$ = new Console($5, @1.first_line, @1.first_column);}
;



/*------------------------------------------- Estructuras de Control ---------------------------------------------*/


If
    : 'IF' '(' Expr ')' BloqueInstrucciones Else
    {
        $$ = new If($3, $5, $6, @1.first_line, @1.first_column);
    }
;

Else
    : 'ELSE' If
    {
        $$ = $2;
    }
    | 'ELSE' BloqueInstrucciones
    {
        $$ = $2;
    }
    | /* epsilon */ 
    {
        $$ = null;
    }
;

While
    : 'WHILE' '(' Expr ')' BloqueInstrucciones
    {
        $$ = new While( $3 , $5, @1.first_line, @1.first_column );
    }
;

DoWhile
    : 'DO' BloqueInstrucciones 'WHILE' '(' Expr ')' 
    {
        $$ = new DoWhile( $5 , $2, @1.first_line , @1.first_column);
    }
;

Switch
    : 'SWITCH' '(' Expr ')' '{' BloqueCase Default '}'
    {
        $$ = new Switch( $3 , $6 , $7, @1.first_line , @1.first_column);
    }
;

BloqueCase
    :  BloqueCase Case
    {
        $1.push($2);
        $$ = $1;
    }
    |  Case
    {
        $$ = [$1];
    }
;

Case 
    : 'CASE' Expr ':' Instrucciones
    {
        $$ = new Case( $2 , $4, @1.first_line, @1.first_column);
    }
;

Default 
    : 'DEFAULT' ':' Instrucciones
    {
        $$ = $3;
    }
    | /* epsilon */
    {
        $$ = null;
    }
  ;



BloqueInstrucciones
    : '{'  Instrucciones '}'
    {
        $$ = new BloqueInstrucciones($2, @1.first_line , @1.first_column);
    } 
    | '{' '}'
    {
        $$ = null;
    }
  ; 


/*-----------------------------------------FUNCIONES------------------------------------------------*/

funcion
    : 'FUNCTION' 'ID' '(' parametros ')' ':' tipo BloqueInstrucciones 
    {
        $$ = new Funcion($2 , $8,  $4, $7, @1.first_line , @1.first_column);
    }
    | 'FUNCTION' 'ID' '(' parametros ')' BloqueInstrucciones 
    {
        $$ = new Funcion($2 , $6,  $4, Tipo.NULL, @1.first_line , @1.first_column);
    };

parametros
    : parametros ',' parametro
    {
        $1.push($3);
        $$ = $1;
    }    
    | parametro
    {
        $$ = [$1];
    }    
;

parametro
    : 'ID' ':' tipo
    {
        $$ = new Parametro($1 , $3 , @1.first_line , @1.first_column);
    }
;



/*----------------------------------------Expresiones Aritmeticas y Logicas--------------------------------------*/
Expr
    : Expr '+' Expr
    {
        $$ = new ExpresionAritmetica($1, $3, OperacionesAritmeticas.SUMA, @1.first_line,@1.first_column);
    }       
    | Expr '-' Expr
    {
        $$ = new ExpresionAritmetica($1, $3, OperacionesAritmeticas.RESTA, @1.first_line,@1.first_column);
    }
    | Expr '*' Expr
    { 
        $$ = new ExpresionAritmetica($1, $3, OperacionesAritmeticas.MULTIPLICACION, @1.first_line,@1.first_column);
    }       
    | Expr '/' Expr
    {
        $$ = new ExpresionAritmetica($1, $3, OperacionesAritmeticas.DIVISION, @1.first_line,@1.first_column);
    }
    | Expr '<' Expr
    {
        $$ = new ExpresionLogica($1, $3, OperacionLogica.MENOR, @1.first_line,@1.first_column);
    }
    | Expr '<=' Expr
    {
        $$ = new ExpresionLogica($1, $3, OperacionLogica.MENORIG, @1.first_line,@1.first_column);
    }
    | Expr '>' Expr
    {
        $$ = new ExpresionLogica($1, $3, OperacionLogica.MAYOR, @1.first_line,@1.first_column);
    }
    | Expr '>=' Expr
    {
        $$ = new ExpresionLogica($1, $3, OperacionLogica.MAYORIG, @1.first_line,@1.first_column);
    }
    | Expr '==' Expr
    {
        $$ = new ExpresionLogica($1, $3, OperacionLogica.IGIG, @1.first_line,@1.first_column);
    }
    | Expr '!=' Expr
    {
        $$ = new ExpresionLogica($1, $3, OperacionLogica.DIF, @1.first_line,@1.first_column);
    }
    | Expr '&&' Expr
    {
        $$ = new ExpresionLogica($1, $3, OperacionLogica.AND, @1.first_line,@1.first_column);
    }
    | Expr '||' Expr
    {
        $$ = new ExpresionLogica($1, $3, OperacionLogica.OR, @1.first_line,@1.first_column);
    }
    | '!' Expr
    {
        $$ = new ExpresionUnaria($2,  OperacionUnaria.NOT, @1.first_line,@1.first_column);
    }            
    | F
    {
        $$ = $1;
    }
;


F   : '(' Expr ')'
    { 
        $$ = $2;
    }
    | 'DECIMAL'
    { 
         $$ = new Literal($1, @1.first_line, @1.first_column, Tipo.NUMBER);
    }
    | 'ENTERO'
    { 
         $$ = new Literal($1, @1.first_line, @1.first_column, Tipo.NUMBER);
    }
    | 'CADENA'
    {
         $$ = new Literal($1.replace(/\"/g,""), @1.first_line, @1.first_column, Tipo.STRING);
    }
    | 'TRUE'
    { 
         $$ = new Literal($1, @1.first_line, @1.first_column, Tipo.BOOLEAN);
    }
    | 'FALSE'
    { 
         $$ = new Literal($1, @1.first_line, @1.first_column, Tipo.BOOLEAN);
    }     
    | llamadaFuncion
    | '[' paramsExp ']'
    { 
         $$ = new Arreglo($2, @1.first_line, @1.first_column);

    }
    | 'ID' accesosCorchetes {
         $$ = new AccesoArray($1, $2, @1.first_line, @1.first_column);
    }        
    | 'ID' {
         $$ = new Access($1, @1.first_line, @1.first_column);
    }

        
    //LLAMADA A FUNCION

;

accesosCorchetes
    : accesosCorchetes '[' Expr ']'
    {
        $1.push($3);
        $$ = $1;
    }
    | '[' Expr ']'
    {
        $$ = [$2];
    }
;


llamadaFuncion
    : 'ID' '(' paramsExp ')' 
    {
        $$ = new LlamadaFuncion($1 , $3, @1.first_line , @1.first_column);
    }
    ;


paramsExp
    : paramsExp ',' Expr
    {
        $1.push($3);
        $$ = $1;
    }
    | Expr
    {
        $$ = [$1];
    }
;