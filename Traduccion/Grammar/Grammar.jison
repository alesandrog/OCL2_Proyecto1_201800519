%{
    const { ListaInstrucciones } = require('../ListaInstrucciones');    
    const { ListaGlobales } = require('../ListaGlobales');        

    /*----------------------------------------------- EXPRESIONES --------------------------------------------------------------*/
    const { ExpresionBinaria } = require('../Expresion/ExpresionBinaria');
    const { Literal } = require('../Expresion/Literal');
    const { ExpresionUnaria } = require('../Expresion/ExpresionUnaria');



    /*----------------------------------------------- INSTRUCCIONES --------------------------------------------------------------*/
    const { Declaracion } = require('../Instruccion/Declaracion');
    const { Asignacion } = require('../Instruccion/Asignacion');   
    const { Funcion } = require('../Instruccion/Funcion'); 
  

    let funcionesAnidadas = [];
%}

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
        $$ = new Declaracion($2, `:${$4}${$5}`, "let", $7 );
    }
    | 'LET'   'ID' ':' tipo '=' '{' atributosType '}'
    { 
//        $$ = new Declaracion($2, "", "", "let", $4 );
    }    
    | 'LET'   'ID' ':' tipo  corchetes ';'
    { 
        $$ = new Declaracion($2, `:${$4}${$5}`, "let", null );
    }        
    | 'LET'   'ID' ':' tipo '=' Expr ';'
    { 
        $$ = new Declaracion($2, `:${$4}`, "let", $6 );
    }
    | 'LET'   'ID' ':' tipo ';'
    { 
        $$ = new Declaracion($2, `:${$4}`, "let", null );
    }   
    | 'LET'   'ID'  '=' Expr ';'
    {
        $$ = new Declaracion($2, "", "let", $4 );
    }    
    | 'LET' 'ID' ';'
    {
        $$ = new Declaracion($2, "", "let", null );
    }
    | 'CONST' 'ID' ':' tipo corchetes '=' Expr ';'
    { 
        $$ = new Declaracion($2, `:${$4}${$5}`, "const", $7 );
    }    
    | 'CONST' 'ID' ':' tipo '=' Expr ';'
    { 
        $$ = new Declaracion($2, `:${$4}`, "const", $6 );
    }
    | 'CONST' 'ID' '=' Expr ';'
    { 
        $$ = new Declaracion($2, "", "const", $4 );
    }
;

corchetes
    : corchetes '[' ']'
    {
        $$ = $1 + "[]";
    }
    | '[' ']'
    {
        $$ = "[]";
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
    : 'ID' '+=' Expr 
    {
        $$ = new Asignacion($1 , $3, $2);
    }    
    | 'ID' '=' Expr 
    {
        $$ = new Asignacion($1 , $3, $2);
    }
;


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////////////////////                                 ////////////////////////////////////////////////////////////////
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\             FUNCIONES            \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////////////////////                                 ////////////////////////////////////////////////////////////////
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/


//Funcion Global
funcion
    : 'FUNCTION' idFuncion '(' parametrosFuncion ')' tipoFuncion  '{' InstruccionesFun '}' 
    {
        $$ = new Funcion($2.id, $4, $6, $8, "", funcionesAnidadas );
        funcionesAnidadas = [];
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
    : parametros 
    | { $$ = ""; }
;

tipoFuncion
    : ':' tipo { $$ = `:${$2}`; }
    | { $$ = ""; }
;


InstruccionesFun
    : InstruccionesFun instrFun
    {
        if($2 instanceof Funcion){
            funcionesAnidadas.push($2);
        }else{
        $1.push($2);
        }
        $$ = $1;
    } 
    | instrFun
    {        
        $$ = [$1];
    }
;

instrFun
    : declaracion
    { 
       $$ = $1;
    }
    | funcionFun 
    | asignacion ';' 
    { 
       $$ = $1;
    }
;



funcionFun
    : 'FUNCTION' idFunAnid '(' parametrosFuncion ')' tipoFuncion  '{' InstruccionesFun '}'
    {
        $$ = new Funcion($2.value, $4, $6, $8, $2.padre );
    } 
;
idFunAnid
    : 'ID'
    {
        //pushear a map traducidas
        var pila = eval('$$');
        var tope = pila.length - 1;
        if(pila[tope - 2] == '{'){
            $$ = { padre : pila[tope - 7].id, id: pila[tope - 7].id + `_${$1}` , value : $1  }; 
        }else{
            $$ = { padre : pila[tope - 8].id, id: pila[tope - 8].id + "_" + $1 , value : $1 }; 
        }
    }
;




parametros
    : parametros ',' parametro
    {
        $$ = `${$1},${$3}`;
    }    
    | parametro
    {
        $$ = $1;
    }    
;

parametro
    : 'ID' ':' tipo
    {
        $$ = `${$1}:${$3}`;
    }
;



/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////////////////////                                 ////////////////////////////////////////////////////////////////
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\          EXPRESIONES             \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///////////////////////////////////////                                 ////////////////////////////////////////////////////////////////
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/




/*----------------------------------------Expresiones Aritmeticas y Logicas--------------------------------------*/
Expr
    : Expr '+' Expr
    {
        $$ = new ExpresionBinaria($1 , $3, $2);
    }       
    | Expr '-' Expr
    {
        $$ = new ExpresionBinaria($1 , $3, $2);
    }
    | Expr '*' Expr
    { 
        $$ = new ExpresionBinaria($1 , $3, $2);
    }       
    | Expr '/' Expr
    {
        $$ = new ExpresionBinaria($1 , $3, $2);
    }
    | Expr '<' Expr
    {
        $$ = new ExpresionBinaria($1 , $3, $2);
    }
    | Expr '<=' Expr
    {
        $$ = new ExpresionBinaria($1 , $3, $2);
    }
    | Expr '>' Expr
    {
        $$ = new ExpresionBinaria($1 , $3, $2);
    }
    | Expr '>=' Expr
    {
        $$ = new ExpresionBinaria($1 , $3, $2);
    }
    | Expr '==' Expr
    {
        $$ = new ExpresionBinaria($1 , $3, $2);
    }
    | Expr '!=' Expr
    {
        $$ = new ExpresionBinaria($1 , $3, $2);
    }
    | Expr '&&' Expr
    {
        $$ = new ExpresionBinaria($1 , $3, $2);
    }
    | Expr '||' Expr
    {
        $$ = new ExpresionBinaria($1 , $3, $2);
    }
    | '!' Expr
    {
        $$ = new ExpresionUnaria($2, $1);
    }            
    | F
    {
        $$ = $1;
    }
;


F   : '(' Expr ')'
    { 
        $$ = new ExpresionUnaria($2, $1);
    }
    | 'DECIMAL'
    { 
         $$ = new Literal($1);
    }
    | 'ENTERO'
    { 
         $$ = new Literal($1);
    }
    | 'CADENA'
    {
         $$ = new Literal($1.replace(/\"/g,""));        
    }
    | 'TRUE'
    { 
         $$ = new Literal($1);
    }
    | 'FALSE'
    { 
         $$ = new Literal($1);
    }      
    | 'ID' '++'
    {
        let val = new Literal($1);
        $$ = new ExpresionUnaria(val, $2);
    }
    | 'ID' '--'
    {
        let val = new Literal($1);
        $$ = new ExpresionUnaria(val, $2);
    }
    | 'ID' {
         $$ = new Literal($1);
    }
;