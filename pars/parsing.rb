require 'parslet'
require 'pp'
include Parslet

# sintactico
class MyOwn < Parslet::Parser
  #espacios
  rule(:espacio)      { match('\s').repeat(1)  }
  rule(:espacio?)     { espacio.maybe }

  # rule(:linea)        { match('\n').repeat(1)  }
  # rule(:linea?)       {linea.maybe}

  # chars
  rule(:parenIz)      { str('(')  >>  espacio?  }
  rule(:parenDer)     { str(')')  >>  espacio?  }
  rule(:coma)         { str(',')  >>  espacio?  }
  rule(:quadDer)      { str(']')  >>  espacio?  }
  rule(:quadIz)       { str('[')  >>  espacio?  }
  rule(:pYc)          { str(';')  >>  espacio?  }
  rule(:dosPuntos)    { str(':')  >>  espacio?  }
  rule(:igual)        { str('=')  >>  espacio?  }
  rule(:punto)        { str('.')  >>  espacio?  }
  rule(:comillas)     { str('"')  >>  espacio?  }
  rule(:barra)        { str('|')  >>  espacio?  }
  rule(:llaveDer)     { str('}')  }#>>  espacio?  }
  rule(:llaveIzq)     { str('{')  >>  espacio?  }

  # operadores
  rule(:mas)        { match('[+]').as(:op)  >>  espacio?  }
  rule(:mult)       { match('[*]').as(:op)  >>  espacio?  }
  rule(:menos)      { match('[-]').as(:op)  >>  espacio?  }
  rule(:division)   { match('[/]').as(:op)  >>  espacio?  }
  rule(:pow)        { match('[^]').as(:op)  >>  espacio?  }
  rule(:operador)   { mas|menos|division|mult}
  rule(:yy)         { str('and')    >>  espacio?  }
  rule(:oo)         { str('or')     >>  espacio?  }
  rule(:extras)     { yy | oo  }
  rule(:plusy)      { mas >>  mas >>  espacio?}
  rule(:potencia)   { entero  | flotante  | identificador >>  pow >>  entero  | flotante  | identificador }

# nose
rule(:inicio)       { str('->')     >>  espacio?  }
rule(:fin)          { str('>|')     >>  espacio?  }
rule(:nil)          { str('nil')    >>  espacio?  }
rule(:siIF)         { str('if')     >>  espacio?  }
rule(:para)         { str('for')    >>  espacio?  }
rule(:entonces)     { str('then')   >>  espacio?  }
rule(:clase)        { str('class')  >>  espacio?  }
rule(:haz)          { str('do')     >>  espacio?  }
rule(:mientras)     { str('while')  >>  espacio?  }
rule(:importa)      { str('import') >>  espacio?  }
rule(:para)         { str('for')    >>  espacio?  }
rule(:rango)        { str('range')  >>  espacio?  }
rule(:funcion)      { str('funky')  >>  espacio?  }
rule(:en)           { str('in')     >>  espacio?  }


#operadores logicos
  rule(:asignar)    { str('==')}# >>  espacio? }
  rule(:distinto)   { str('!=')}# >>  espacio?}
  rule(:mayorigual) { str('>=')}# >>  espacio?}
  rule(:menorIgual) { str('<=')}# >>  espacio?}
  rule(:mayorQue)   { str('>') }# >>  espacio? }
  rule(:menorQue)   { str('<') }# >>  espacio? }
  rule(:opLogicos)  { (asignar  | distinto  |  mayorigual  | menorIgual  | mayorQue  | menorQue).as(:opLL) >>  espacio? }

# expresion
  rule(:operacion)  { (tipoDato).as(:izq)  >>  operador	>>	expresion.as(:der)  }
  rule(:listaArg)	  {	expresion >>	(coma	>> expresion).repeat	}
  rule(:funcionLla)	{	identificador.as(:funcionLla)	>>	parenIz	>>	listaArg.as(:listaArg)	>>	parenDer}
  rule(:expresion)  {  funcionLla	| operacion	|	tipoDato }
  rule(:expresionF) { identificador >>  dosPuntos >>  igual >>  expresion }

=begin
# expresion
  rule(:valor)      { (entero  | flotante).as(:numero)  >>  expresion }
  rule(:producto)   { mult  | division  }
  rule(:suma)       { mas | menos }
  rule(:expresion)  { producto | suma  | valor  }
=end

  # objetos
    #main

    #tipos de datos (AGREGAR MAS TIPOS DE DATOS?)
  rule(:digito)         { match('[0-9]').repeat(1)  }
  rule(:entero)         { (digito  >> digito.repeat(0)).as(:entero) >>  espacio? }#>> linea?  }
  rule(:flotante)       { entero  >>  punto >>  entero }
  rule(:flotis)         { flotante >> espacio? }
  rule(:cadena)         { comillas  >>  (match('[\w]').repeat(1)  >>  match('[\w]').repeat(0)) >> comillas  }
  rule(:identificador)  { (match['a-zA-z'].repeat(1) >>  match('\w').repeat(0)).as(:id) >> espacio?  }
  #tipo dato
  #rule(:tipoDato)       { flotante.as(:flotante)  | entero  | cadena.as(:cadena)  | identificador.as(:identificador) }
  rule(:tipoDato)       { cadena.as(:cadena)  | flotis.as(:flotante)  | entero  | identificador.as(:identi) }

  rule(:llave)          { identificador  >>  espacio? >>  igual >> espacio? }

  #palabras

#  rule(:)

=begin
# sintaxis
  rule(:operacion)    { (entero).as(:izqueirdo) >>  expresion.as(:op)  >>  instruccion.as(:derecho)  }
  rule(:lista_op)     { instruccion >> (coma  >> instruccion).repeat(0) }
  rule(:operaciones)  { identificador.as(:funcion)  >>  parenIz >>  lista_op.as(:lista) >>  parenDer  }
=end
# condicion
  rule(:parteCon)     { (identificador | entero) }
  rule(:condicion)    { parteCon.as(:izqCon)  >>  opLogicos.as(:op) >>  parteCon.as(:derCon) }
  # rule(:condicionEx)  { extras  >>  condicion }
  # rule(:condiciones)  { condicion.as(:condicion) >>  condicionEx.maybe }
  rule(:condicionF)   { condicion >>  dosPuntos }
# definir rango
  #rule FALTA DEFINIR ARREGLO
  rule(:tiposrango)   { (tipoDato  | tipoDato)  >>  (coma  >>  tipoDato).repeat(1)  }
  rule(:rangos)       { tiposrango  | arreglo   }
  rule(:rangoF)       { rangos >>  dosPuntos  }
  rule(:params)       { identificador >>  (coma  >>  params).maybe  }
#BLOQUE?rule(:condicion)    { identificador | entero  >>  (bloque >> pYc).as(:instruccion)  >>  }
# el bloque tiene que estar lleno de todas las condiciones

  #instrucciones
  rule(:declaracion)  { (llave >>  tipoDato.as(:valor)).as(:declaracion) }
  rule(:instSi)       { siIF  >>   condicionF.as(:logica)  >> entonces  >>  bloques  >>  llaveDer.as(:finBloqueSI)  >>  espacio?} # .as(:instruccion) NOMBRAR A BLOQUE INSTRUCCION?
  rule(:instClase)    { clase >>  identificador.as(:claseId)  >> dosPuntos  >>  bloque >>  llaveDer.as(:finBloque)  }
  rule(:instDo)       { haz   >>  bloque.maybe   >>  mientras  >>  condicionF >>  llaveDer.as(:finBloque)}
  rule(:instWhile)    { mientras  >>  condicionF  >>  dosPuntos >>  bloque  >>  llaveDer.as(:finBloque) }
  rule(:instImport)   { importa >>  identificador }
  rule(:instPara)     { para  >>  identificador >>  en  >>  rangoF  >>  bloque  >>  llaveDer.as(:finBloque)}
  rule(:instFunc)     { funcion >>  identificador.as(:funcId) >>  parenIz  >>  params.maybe  >>  parenDer  >>  dosPuntos >>  bloque  >>  llaveDer.as(:finBloque)}
  #bloque de codigo (DEFINIR BLOQUE)
  #rule(:bloque)       { (declaracion.as(:declaracion)  |  instSi.as(:siTest)  | instClase.as(:clase) | instDo.as(:inst_Do)  | instWhile.as(:cicloWhile) | instImport.as(:importar)  | instPara.as(:para)) }


  # rule(:bloque)       { instSi.as(:bloqueExpresion)}# | declaracion.as(:bloqueDeclaracion) |  ( instFunc.as(:bloqueFuncion) |  instSi.as(:bloqueSi)  | instClase.as(:clase) | instDo.as(:inst_Do)  | instWhile.as(:cicloWhile) | instImport.as(:importar)  |

  rule(:bloque)       { expresionF.as(:bloqueExpresion) | declaracion.as(:bloqueDeclaracion) |  instFunc.as(:bloqueFuncion) |  instSi.as(:bloqueSi)  | instClase.as(:clase) | instDo.as(:inst_Do)  | instWhile.as(:cicloWhile) | instImport.as(:importar)  |
    instPara.as(:para) }

  #main
  rule(:bloques)      { bloque.as(:wat)  >>  bloques.maybe.as(:fuck) }
  # rule(:bloques)      { bloque  >>  bloques.maybe }
  rule(:instruccion)  { inicio.as(:inicio) >>  bloques  >>  fin.as(:fin) }
  # rule(:instruccion)  { condicionF }
  # rule(:instruccion)  { opLogicos }
  root :instruccion
end

# fin sintactico

#DEBUGGING
def parse(str)
  own = MyOwn.new
  own.parse(str)
rescue Parslet::ParseFailed => failure
  puts failure.cause.ascii_tree
end

#parse("-> if a >= 4: then a = 3 } >|")
#parse("-> if a >= 4: then a = 3 } >|")
#pp
#parseo = parser.parse("-> 4 + 66 >|")


# pruebas hashing
# puts 'fetch'
#  puts final.fetch(:bloqueDeclaracion).keys[0]
=begin
cadena =''
File.open("algo.txt", "r") do |t|
  t.each_line do |line|
    cadena += line
  end
end
--parseo = parser.parse(cadena)
#pp parseo = parser.parse(cadena)
pp final = trans.apply(parseo)
--puts 'arbol- recorrido'
sem = Semantics.new(final)
sem.recorrer_arbol(final)
puts 'fin recorrido'
--puts 'Tabla de Simbolos : '
 pp $tablas_simbolos
=end
