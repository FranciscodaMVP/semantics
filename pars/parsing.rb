require 'parslet'
include Parslet

# objetos para trabajo
class Symbols_Table
  def new
    tabla = Hash.new
  end

  def agregar_scope(nombre)
    tabla[nombre]
  end

end

# sintactico
class MyOwn < Parslet::Parser
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
  rule(:llaveDer)     { str('}')  >>  espacio?  }
  rule(:llaveIzq)     { str('{')  >>  espacio?  }

  # operadores
  rule(:mas)        { match('[+]')  >>  espacio?  }
  rule(:mult)       { match('[*]')  >>  espacio?  }
  rule(:menos)      { match('[-]')  >>  espacio?  }
  rule(:division)   { match('[/]')  >>  espacio?  }
  rule(:pow)        { match('[^]')  >>  espacio?  }
  rule(:operador)   { mas|menos|division  }
  rule(:yy)         { str('and')    >>  espacio?  }
  rule(:oo)         { str('or')     >>  espacio?  }
  rule(:extras)     { yy | oo  }
  rule(:plusy)      { mas >>  mas >>  espacio?}
  rule(:potencia)   { entero  | flotante  | identificador >>  pow >>  entero  | flotante  | identificador }

#operadores logicos
  #rule(:asignar)    { str('==')   >>  espacio? }
  rule(:distinto)   { str('!=') >>  espacio?}
  rule(:mayorigual) { str('>=') >>  espacio?}
  rule(:menorIgual) { str('<=') >>  espacio?}
  rule(:mayorQue)   { str('>') >>  espacio? }
  rule(:menorQue)   { str('<') >>  espacio? }
  rule(:opLogicos)  { (distinto  |  mayorigual  | menorIgual  | mayorQue  | menorQue).as(:opLL) >>  espacio? }

# expresion
  rule(:valor)      { entero.as(:numero)  | flotante  >>  expresion }
  rule(:producto)   { mult  | division  }
  rule(:suma)       { mas | menos }
  rule(:expresion)  { producto | suma  | valor  }

  #espacios
  rule(:espacio)      { match('\s').repeat(1)  }
  rule(:espacio?)     { espacio.maybe }

  # objetos
    #main

    #tipos de datos (AGREGAR MAS TIPOS DE DATOS?)
  rule(:digito)         { match('[0-9]').repeat(1)  }
  rule(:entero)         { (digito  >> digito.repeat(0)).as(:entero) >>  espacio?  }
  rule(:flotante)       { (entero  >>  punto >>  entero).as(:flotante)  >>  espacio? }
  rule(:cadena)         { comillas  >>  (match('[^;\r\n]').repeat(1)  >>  match('[^;\r\n]').repeat(0)) >> comillas  }
  rule(:identificador)  { (match['a-zA-z'].repeat(1) >>  match('\w').repeat(0)).as(:id) >> espacio?  }
  #tipo dato
  #rule(:tipoDato)       { flotante.as(:flotante)  | entero  | cadena.as(:cadena)  | identificador.as(:identificador) }
  rule(:tipoDato)       { flotante  | entero  | cadena  | identificador }

  rule(:llave)          { identificador  >>  espacio? >>  igual >> espacio? }

  #palabras
  rule(:inicio)       { str('->')     >>  espacio?  }
  rule(:fin)          { str('>|')     >>  espacio?  }
  rule(:nil)          { str('nil')    >>  espacio?  }
  rule(:si)           { str('if')     >>  espacio?  }
  rule(:para)         { str('for')    >>  espacio?  }
  rule(:entonces)     { str('then')   >>  espacio?  }
  rule(:clase)        { str('class')  >>  espacio?  }
  rule(:haz)          { str('do')     >>  espacio?  }
  rule(:mientras)     { str('while')  >>  espacio?  }
  rule(:importa)      { str('import') >>  espacio?  }
  rule(:para)         { str('for')    >>  espacio?  }
  rule(:rango)        { str('range')  >>  espacio?  }
  rule(:en)           { str('in')     >>  espacio?  }
#  rule(:)

=begin
# sintaxis
  rule(:operacion)    { (entero).as(:izqueirdo) >>  operador.as(:op)  >>  instruccion.as(:derecho)  }
  rule(:lista_op)     { instruccion >> (coma  >> instruccion).repeat(0) }
  rule(:operaciones)  { identificador.as(:funcion)  >>  parenIz >>  lista_op.as(:lista) >>  parenDer  }
=end
# condicion
  rule(:parteCon)     { (identificador | entero) }
  rule(:condicion)    { parteCon.as(:izCon)  >>  opLogicos >>  parteCon.as(:derCon) }
  rule(:condicionEx)  { extras  >>  condicion }
  rule(:condiciones)  { condicion.as(:condicion) >>  condicionEx.maybe }
  rule(:condicionF)   { (condiciones) >>  dosPuntos }
# definir rango
  #rule FALTA DEFINIR ARREGLO
  rule(:tiposrango)   { (tipoDato  | tipoDato)  >>  (coma  >>  tipoDato).repeat(1)  }
  rule(:rangos)       { tiposrango  | arreglo   }
  rule(:rangoF)       { rangos >>  dosPuntos  }
#BLOQUE?rule(:condicion)    { identificador | entero  >>  (bloque >> pYc).as(:instruccion)  >>  }
# el bloque tiene que estar lleno de todas las condiciones

  #instrucciones
  rule(:declaracion)  { llave >>  tipoDato.as(:valor)  }
  rule(:instSi)       { (si)  >>   condicionF.as(:logica)  >> entonces  >>  bloque  >>  llaveDer} # .as(:instruccion) NOMBRAR A BLOQUE INSTRUCCION?
  rule(:instClase)    { clase >>  identificador  >> dosPuntos  >>  bloque >>  llaveDer  }
  rule(:instDo)       { haz   >>  bloque.maybe   >>  mientras  >>  condicionF >>  llaveDer}
  rule(:instWhile)    { mientras  >>  condicionF  >>  dosPuntos >>  bloque  >>  llaveDer }
  rule(:instImport)   { importa >>  identificador }
  rule(:instPara)     { para  >>  identificador >>  en  >>  rangoF  >>  bloque }
  #bloque de codigo (DEFINIR BLOQUE)
  #rule(:bloque)       { (declaracion.as(:declaracion)  |  instSi.as(:siTest)  | instClase.as(:clase) | instDo.as(:inst_Do)  | instWhile.as(:cicloWhile) | instImport.as(:importar)  | instPara.as(:para)) }
  rule(:bloque)       { (declaracion.as(:declaracion)  |  instSi.as(:siTest)  | instClase.as(:clase) | instDo.as(:inst_Do)  | instWhile.as(:cicloWhile) | instImport.as(:importar)  | instPara.as(:para)) }

  #main
 rule(:instruccion)       { inicio.as(:inicio) >>  bloque.as(:bloqueIn)  >>  fin.as(:fin) }
  # rule(:instruccion)  { condicionF }
  # rule(:instruccion)  { opLogicos }
  root :instruccion
  # falta construir el bloque
end

# fin sintactico

# estructuras creadas


#fin estructuras

# semantico
class Trans < Parslet::Transform
  rule( :id     =>  simple(:id),
        :valor  =>  subtree(:valor)) do { id.to_s => valor }end
  rule( :derCon =>  simple(:d)) {d.to_s}
  rule( :id     => simple(:i),
        :logica => subtree(:l),
        ) {puts (i)}
  rule( :entero =>  simple(:y))  { Integer(y) }
  #rule( :izCon  =>  )
  #rule( :declaracion => subtree(:der)) {puts (der)} FUNCIONA PARA LAS SUBCADENAS DE HASHES
end
# fin semantico

#sintax

require 'pp'
pp MyOwn.new.parse("-> if a >= 4: then a = 3 } >|")
puts 'cadena'

#Transform

parser = MyOwn.new
trans = Trans.new

final = trans.apply(parser.parse("-> if a > 4: then a = 3 } >|"))
final.each do |key,value|
  puts "#{key}:#{value}"
end

 puts 'Tabla de Simbolos : '








# descontinuado

# primer intento de ramas

# rule(
#   :declaracion => 'declarar'
#   :llave => simple(:llave), :tipoDato =>simple(:tipoDato), :valor => simple(:valor))    { $simbolos_declarados.push(Declarar.new(llave, tipoDato, valor)) } #tabla de simbolos

# primer intento por metodos
# Declarar = Struct.new(:llave, :tipoDato, :valor) do
#   dato = {llave, tipoDato, valor}
# end

=begin
 def parse(str)
   own = MyOwn.new
   own.parse(str)
 rescue Parslet::ParseFailed => failure
   puts failure.cause.ascii_tree
 end

 parse "-> if a > 4: then a = 3 } >|"
  # parse "er34sda >= a:"
  # parse ">= "
=end
