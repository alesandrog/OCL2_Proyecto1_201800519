%{
    const {ExpresionAritmetica, OperacionesAritmeticas} = require('../Expression/ExpresionAritmetica');
    const { Access } = require('../Expression/Access');
    const { Literal } = require('../Expression/Literal');
    const { Declaration } = require('../Instruction/Declaracion');     
    const { Console } = require('../Instruction/Console');
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
"<"                     return '<'
">"                     return '>'
"<="                    return '<='
">="                    return '>='
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
    | asignacion { $$ = $1; } 
    | While
    | DoWhile
    | Switch
    | Console
;
/*--------------------------------------Declaracion y Asignacion de variables----------------------------------*/

declaracion
    : 'LET'   'ID' def_tipo asignacion_declaracion
    { $$ = new Declaration( $2 , $4 , @1.first_line , @1.first_column);}
    | 'CONST' 'ID' def_tipo '=' Expr ';'
    { $$ = new Declaracion( $2 , $5 , @1.first_line , @1.first_column);}
;

def_tipo 
    : ':' tipo
    |
;

asignacion_declaracion
    : '=' Expr ';' { $$ = $2; }
    | ';'
;

tipo
    : 'NUMBER'
    | 'STRING'
    | 'BOOLEAN'
    | 'VOID'
    | 'ID'
;

asignacion
    : 'ID' '=' Expr ';'
;


/*-----------------------------------------Funciones , llamadas y parametros------------------------------------*/

Console 
    : 'CONSOLE' '.' 'LOG' '(' Expr ')' ';'
    {   $$ = new Console($5, @1.first_line, @1.first_column);}
;



/*------------------------------------------- Estructuras de Control ---------------------------------------------*/


If
    : 'IF' '(' Expr ')' BloqueInstrucciones Else
;

Else
    : 'ELSE' BloqueInstrucciones
    | 'ELSE' If 
    | /* epsilon */
;

While
    : 'WHILE' '(' Expr ')' BloqueInstrucciones
;

DoWhile
    : 'DO' BloqueInstrucciones 'WHILE' '(' Expr ')'
;

Switch
    : 'SWITCH' '(' Expr ')' '{' BloqueCase Default '}'
;

BloqueCase
    :  BloqueCase Case
    |  Case
;

Case 
    : 'CASE' Expr ':' Instrucciones
;

Default 
    : 'DEFAULT' ':' Instrucciones
    | /* epsilon */
  ;



BloqueInstrucciones
    : '{'  Instrucciones '}' 
    | '{' '}'
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
      //  $$ = new Relational($1, $3,RelationalOption.LESS, @1.first_line, @1.first_column);
    }
    | Expr '<=' Expr
    {
     //   $$ = new Relational($1, $3,RelationalOption.LESSOREQUAL ,@1.first_line, @1.first_column);
    }
    | Expr '>' Expr
    {
     //   $$ = new Relational($1, $3,RelationalOption.GREATER ,@1.first_line, @1.first_column);
    }
    | Expr '>=' Expr
    {
     //   $$ = new Relational($1, $3,RelationalOption.GREATEROREQUAL ,@1.first_line, @1.first_column);
    }
    | Expr '==' Expr
    {
     //   $$ = new Relational($1, $3,RelationalOption.EQUAL ,@1.first_line, @1.first_column);
    }
    | Expr '!=' Expr
    {
     //   $$ = new Relational($1, $3,RelationalOption.NOTEQUAL ,@1.first_line, @1.first_column);
    }
    | F
    {
      //  $$ = $1;
    }
;


F   : '(' Expr ')'
    { 
      //  $$ = $2;
    }
    | 'DECIMAL'
    { 
         $$ = new Literal($1, @1.first_line, @1.first_column, 0);
    }
    | 'ENTERO'
    { 
         $$ = new Literal($1, @1.first_line, @1.first_column, 1);
    }
    | 'CADENA'
    {
         $$ = new Literal($1.replace(/\"/g,""), @1.first_line, @1.first_column, 2);
    }
    | 'ID' {
         $$ = new Access($1, @1.first_line, @1.first_column);
    }
    //LLAMADA A FUNCION

;
