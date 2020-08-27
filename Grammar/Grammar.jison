%{

%}

%lex
%options case-sensitive
entero  [0-9]+
decimal {entero}"."{entero}
id  (\"[^"]*\")
%%
\s+                   /* skip whitespace */

{entero}                return 'ENTERO'
{decimal}               return 'DECIMAL'
{id}                    return 'ID'

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
    : instrucciones EOF 
    {
        return $1;
    } 
;

instrucciones
    : instrucciones instruccion{
       // $1.push($2);
       // $$ = $1;
    }
    | instruccion{
       // $$ = [$1];
    }
;

instruccion
    : declaracion 
;


declaracion
    : 'LET' def_tipo asignacion
    | 'CONST' def_tipo asignacion
;

def_tipo 
    : ':' tipo
    |
;


asignacion_declaracion
    : 'ID' '=' Expr
    | ';'
;

tipo
    : 'NUMBER'
    | 'STRING'
    | 'BOOLEAN'
    | 'VOID'
    | 'ID'
;

Expr
    : Expr '+' Expr
    {
      //  $$ = new Arithmetic($1, $3, ArithmeticOption.PLUS, @1.first_line,@1.first_column);
    }       
    | Expr '-' Expr
    {
      //  $$ = new Arithmetic($1, $3, ArithmeticOption.MINUS, @1.first_line,@1.first_column);
    }
    | Expr '*' Expr
    { 
     //   $$ = new Arithmetic($1, $3, ArithmeticOption.TIMES, @1.first_line,@1.first_column);
    }       
    | Expr '/' Expr
    {
      //  $$ = new Arithmetic($1, $3, ArithmeticOption.DIV, @1.first_line,@1.first_column);
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
    | DECIMAL
    { 
     //   $$ = new Literal($1, @1.first_line, @1.first_column, 0);
    }
    | NUMBER
    { 
      //  $$ = new Literal($1, @1.first_line, @1.first_column, 1);
    }
    | STRING
    {
      //  $$ = new Literal($1.replace(/\"/g,""), @1.first_line, @1.first_column, 2);
    }
    | ID{
      //  $$ = new Access($1, @1.first_line, @1.first_column);
    }
;
