import { Expresion  } from "./Abstract/Expresion"
import { Instruction  } from "./Abstract/Instruccion"
import { Retorno  } from "./Abstract/Retorno"
import { Tipos  } from "./Abstract/TablaTipos"

import { Entorno } from "./Symbol/Entorno"
import { Simbolo } from "./Symbol/Simbolo"

import { ExpresionAritmetica } from "./Expression/ExpresionAritmetica";
import { ExpresionLogica , OperacionLogica } from "./Expression/ExpresionLogica";
import { Access } from "./Expression/Access";
import { Literal } from "./Expression/Literal";
import { ExpresionUnaria, OperacionUnaria } from "./Expression/OperacionUnaria";

import { BloqueInstrucciones } from "./Instruction/BloqueInstrucciones";
import { If } from "./Instruction/If";
import { Declaration } from "./Instruction/Declaracion"
import { Console } from "./Instruction/Console";
import { Asignacion } from "./Instruction/Asignacion";
import { While } from "./Instruction/While";
import { DoWhile } from "./Instruction/DoWhile";
import { Switch } from "./Instruction/Switch";
import { Case } from "./Instruction/Case";
import { Funcion } from "./Instruction/Funcion";
import { LlamadaFuncion } from "./Instruction/LLamadaFuncion";
import { Break } from "./Instruction/Break";
import { Continue } from "./Instruction/Continue";
import { Return } from "./Instruction/Return";
import { Parametro } from "./Instruction/Parametro";

console.log("tsc finished");