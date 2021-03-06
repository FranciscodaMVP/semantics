require_relative 'parsing'
require_relative 'semantics'
require_relative 'transform'
require_relative 'code'
require_relative 'traductor'
require_relative 'assembler'
# require_relative 'semars'

require 'pp'

parser = MyOwn.new
trans = Trans.new

 cadena =''
 File.open("code3.txt", "r") do |t|
   t.each_line do |line|
     cadena += line
   end
 end

debugger = false
parssing = false
transformado = false
semantico = true
semantico_errores = true
simbolos = false
declarar = false
transFormer = false
coder = false
coder_debugger = false
cuadruplas = false
assembler = false

 # debug
if debugger
   puts '------------------------------------------------------------------
   DEBUGGER
   ------------------------------------------------------------------'
   parse(cadena)
   puts '------------------------------------------------------------------
   DEBUGGER
   ------------------------------------------------------------------'
end
 #fin debug

# parseo para proceso final
if parssing
  puts '
  -------------------------------
  INCIO
  -------------------------------
  '
  #  parseo = parser.parse(cadena)
   pp parseo = parser.parse(cadena)
   puts '
   -------------------------------
   FIN
   -------------------------------
   '
else
  parseo = parser.parse(cadena)
end

# transformacion tal vez deprecada
if transformado
   puts '------------------------------------------------------------------
   arbol transformado
   ------------------------------------------------------------------'
   pp final = trans.apply(parseo)
   puts '------------------------------------------------------------------
   transformado
   ------------------------------------------------------------------'
else
  final = trans.apply(parseo)
end

# analisis semantico
sem = Semantics.new(final)
# error = Semans.new(final)
if semantico
  # puts '------------------------------------------------------------------
  # arbol- recorrido
  # ------------------------------------------------------------------'
  sem.recorrer_arbol(final)
  sem.revisar
  # sem.imprime_log
  # sem.imprime_simbolos
  # puts '------------------------------------------------------------------
  # fin recorrido
  # ------------------------------------------------------------------'
    if semantico_errores
		sem.errores
	end

else
  sem.recorrer_arbol(final)
  sem.revisar
  if semantico_errores
	sem.errores
  end
end

# impresion de la tabla de simbolos
if simbolos
   puts '------------------------------------------------------------------
   Tabla de Simbolos :
   ------------------------------------------------------------------'
    sem.imprime_simbolos
end

# if coder
#   code = Code.new(final)
#   code.recorrer_arbol(final)
#   code.imp_has
# end
  #opciones

# transformacion para modificar declaraciones
declara = CodeDeclara.new
if declarar
  pp dec = declara.apply(parseo)
else
  dec = declara.apply(parseo)
end

# transformacion final para codigo intermedio
testTrans = CodeTrans.new
if transFormer
  puts "\n" + "wat \n\n"
  pp wat = testTrans.apply(dec)
else
  wat = testTrans.apply(dec)
end

# generador de codigo intermedio
if coder
  code = Code.new(wat)
  code.recorrer_arbol(wat)

  # debugger del coder
  if coder_debugger
    pp 'nuevo'
    code.imp_has
  end

  # imprime cuadruplas
  if cuadruplas
    pp 'cuadruplas'
    code.imp_cuad
  end
  # convierte las cuadruplas en codigo intermedio
  t = code.get_code
  traduccion = Traductor.new(t)
  traduccion.traducir
  #traduccion.imprime

  assembly = Assembler.new(t)
  assembly.traducir
  assembly.imprime
end
