require 'parslet'
require 'pp'
include Parslet

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
  rule(:linea)        { str('\n') >>  espacio?  }

  # operadores
  rule(:mas)        { match('[+]')  >>  espacio?  }
  rule(:mult)       { match('[*]')  >>  espacio?  }
  rule(:menos)      { match('[-]')  >>  espacio?  }
  rule(:division)   { match('[/]')  >>  espacio?  }
  rule(:pow)        { match('[^]')  >>  espacio?  }
  rule(:operador)   { mas|menos|division|mult}
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
  rule(:operacion)  { (tipoDato).as(:izq)  >>  operador.as(:op)	>>	expresion.as(:der)  }
  rule(:listaArg)	  {	expresion >>	(coma	>> expresion).repeat	}
  rule(:funcionLla)	{	identificador.as(:funcionLla)	>>	parenIz	>>	listaArg.as(:listaArg)	>>	parenDer}
  rule(:expresion)  {  funcionLla	| operacion	|	tipoDato }

=begin
# expresion
  rule(:valor)      { (entero  | flotante).as(:numero)  >>  expresion }
  rule(:producto)   { mult  | division  }
  rule(:suma)       { mas | menos }
  rule(:expresion)  { producto | suma  | valor  }
=end

  #espacios
  rule(:espacio)      { match('\s').repeat(1)  }
  rule(:espacio?)     { espacio.maybe }

  # objetos
    #main

    #tipos de datos (AGREGAR MAS TIPOS DE DATOS?)
  rule(:digito)         { match('[0-9]').repeat(1)  }
  rule(:entero)         { (digito  >> digito.repeat(0)) >>  espacio?  }
  rule(:flotante)       { entero  >>  punto >>  entero }
  rule(:flotis)         { flotante >> espacio? }
  rule(:cadena)         { comillas  >>  (match('[^;\r\n]').repeat(1)  >>  match('[^;\r\n]').repeat(0)) >> comillas  }
  rule(:identificador)  { (match['a-zA-z'].repeat(1) >>  match('\w').repeat(0)).as(:id) >> espacio?  }
  #tipo dato
  #rule(:tipoDato)       { flotante.as(:flotante)  | entero  | cadena.as(:cadena)  | identificador.as(:identificador) }
  rule(:tipoDato)       { flotis.as(:flotante)  | entero.as(:entero)  | cadena.as(:cadena)  | identificador.as(:identi) }

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
  rule(:funcion)      { str('funky')  >>  espacio?  }
  rule(:en)           { str('in')     >>  espacio?  }
#  rule(:)

=begin
# sintaxis
  rule(:operacion)    { (entero).as(:izqueirdo) >>  expresion.as(:op)  >>  instruccion.as(:derecho)  }
  rule(:lista_op)     { instruccion >> (coma  >> instruccion).repeat(0) }
  rule(:operaciones)  { identificador.as(:funcion)  >>  parenIz >>  lista_op.as(:lista) >>  parenDer  }
=end
# condicion
  rule(:parteCon)     { (identificador | entero) }
  rule(:condicion)    { parteCon  >>  opLogicos >>  parteCon }
  rule(:condicionEx)  { extras  >>  condicion }
  rule(:condiciones)  { condicion.as(:condicion) >>  condicionEx.maybe }
  rule(:condicionF)   { (condiciones) >>  dosPuntos }
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
  rule(:instSi)       { si  >>   condicionF.as(:logica)  >> entonces  >>  bloques  >>  llaveDer.as(:finBloque)} # .as(:instruccion) NOMBRAR A BLOQUE INSTRUCCION?
  rule(:instClase)    { clase >>  identificador.as(:claseId)  >> dosPuntos  >>  bloque >>  llaveDer.as(:finBloque)  }
  rule(:instDo)       { haz   >>  bloque.maybe   >>  mientras  >>  condicionF >>  llaveDer.as(:finBloque)}
  rule(:instWhile)    { mientras  >>  condicionF  >>  dosPuntos >>  bloque  >>  llaveDer.as(:finBloque) }
  rule(:instImport)   { importa >>  identificador }
  rule(:instPara)     { para  >>  identificador >>  en  >>  rangoF  >>  bloque  >>  llaveDer.as(:finBloque)}
  rule(:instFunc)     { funcion >>  identificador.as(:funcId) >>  parenIz  >>  params.maybe  >>  parenDer  >>  dosPuntos >>  bloque  >>  llaveDer.as(:finBloque)}
  #bloque de codigo (DEFINIR BLOQUE)
  #rule(:bloque)       { (declaracion.as(:declaracion)  |  instSi.as(:siTest)  | instClase.as(:clase) | instDo.as(:inst_Do)  | instWhile.as(:cicloWhile) | instImport.as(:importar)  | instPara.as(:para)) }

  rule(:bloque)       { ( instFunc.as(:bloqueFuncion) | declaracion.as(:bloqueDeclaracion)  |  instSi.as(:bloqueSi)  | instClase.as(:clase) | instDo.as(:inst_Do)  | instWhile.as(:cicloWhile) | instImport.as(:importar)  |
    instPara.as(:para)  | expresion.as(:bloqueExpresion)) }

  #main
  rule(:bloques)      { bloque.as(:wat)  >>  bloques.maybe.as(:fuck) }
  rule(:instruccion)       { inicio.as(:inicio) >>  bloques  >>  fin.as(:fin) }
  # rule(:instruccion)  { condicionF }
  # rule(:instruccion)  { opLogicos }
  root :instruccion
end

# fin sintactico

# semantico
class Trans < Parslet::Transform

  rule( :identi =>  simple(:iden),
        :id =>  subtree(:valor)) do {id.to_s => valor} end
#test con clase
  rule( :clase     =>  simple(:clase),
        :id  =>  subtree(:clasid)) do { clase.to_s => clasid}end# bloque_actual[id.to_s]=valor end#; }end

#funca
  rule( :entero =>  simple(:y))  { "entero" }

  rule( :id     =>  simple(:d)) {d.to_s}

  rule( :id     =>  simple(:id),
        :valor  =>  subtree(:valor)) do { id.to_s => valor}end# bloque_actual[id.to_s]=valor end#; }end

  rule( :id     => simple(:i),
        :opLL   => subtree(:l),
        :entero => subtree(:le),
        ) { i.to_s + l.to_s+le.to_s }

  rule( :condicion  =>  simple(:con),) {con.to_s}
end
# fin semantico

#Procesado Inicial
parser = MyOwn.new
trans = Trans.new

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

#Objeto
class Semantics
  attr_accessor :lista
  def initialize (lista)
    @lista=lista
    @bloques = 0
    @padre = 'main'
    $tablas_simbolos = Hash.new
    $tablas_simbolos['main']={:nombre => 'main', :padre => nil}
    @bloque_actual = $tablas_simbolos['main']
    puts 'bloque inicial'
    pp @bloque_actual
  end

  def recorrer_arbol(arbol)
      arbol.each do |key, value|
        if value.is_a?(Hash)
          # puts "llave : #{key} -- iterando"
          evalua_llave(key, value)
          recorrer_arbol(value)
        else
          # puts "llave : #{key}, valor : #{value}"
          # puts 'clase'
          # puts key.class
          evalua_llave(key,value)
        end
      end
  end

  def evalua_llave(llave, valor)
    #@padre = @padre_root
    # puts 'evalua llave UFCK'
    # pp (@padre)
    # padre = @bloque_actual[:nombre]
    if llave == :bloqueSi
      a = {:nombre => @bloques,:clase => 'if', :padre => @padre}
        $tablas_simbolos[@bloques]=a
        @bloque_actual = $tablas_simbolos[@bloques]
      @bloques +=1
      @padre = @bloque_actual[:nombre]
    end

  	if llave == :bloqueDeclaracion
      a = {:tipo => valor[:declaracion].values[0],:clase => valor.keys[0], :padre => @padre, :nombre => valor[:declaracion].keys[0], :numero => @bloques}
        @bloque_actual[valor[:declaracion].keys[0]]= a
        # pp 'bloque actual y llave'
        # pp [valor[:declaracion].keys[0]]
        # pp @bloque_actual
        # @bloque_actual = $tablas_simbolos[@bloques]
      @bloques +=1
  	end
    if llave == :bloqueExpresion
      a = {:nombre  =>  @bloques, :clase => 'expresion', :padre => @padre, :izq => valor[:izq], :der => valor[:der] }
        $tablas_simbolos[@bloques]=a
        @bloque_actual = $tablas_simbolos[@bloques]
      @bloques +=1
    end
    if llave == :clase
      a = {:nombre => @bloques, :clase =>'clase', :padre => @padre, :variable =>valor[:id]}
        $tablas_simbolos[@bloques]=a
        # @bloque_actual = $tablas_simbolos[@bloques]
        pp "MOTHERFUCKING CLASSS FUCKING ASSHOLE"
      @bloques +=1
      @padre = @bloque_actual[:nombre]
    end

    if llave == :finBloque
      @padre = 'main'
      pp 'final del bloque'
      pp @padre
      @bloque_actual = $tablas_simbolos['main']
    end
    # Recuerda nada mas hay que checar que la variable este guardada en el arbol de simbolos
    if llave == :identi or llave == :id
      encontrado = 0
      pp '----------------BUSCANDO LLAVES-----------------'
      # pp 'encontrado = '+encontrado.to_s
      # pp valor
      # pp @bloque_actual
      # pp @bloque_actual.has_key?(valor)
      if @bloque_actual.has_key?(valor)
        encontrado =+ 1
      end
      pp '----------------PADRE-----------------'
      pp p = $tablas_simbolos[@bloque_actual[:padre]]
      if p
        if p.has_key?(valor)
          encontrado =+ 1
        end
      end
      pp '----------------FIN BUSQUEDA-----------------'
      if encontrado == 0
        pp valor.to_s + ', no se encuentra definido'
      end
    end
  end
end

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
