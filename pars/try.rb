require_relative 'parsing'
require_relative 'semantics'
require_relative 'transform'
require_relative 'code'
require_relative 'traductor'

require 'pp'

parser = MyOwn.new
trans = Trans.new

 cadena =''
 File.open("code.txt", "r") do |t|
   t.each_line do |line|
     cadena += line
   end
 end

debugger = false
parssing = false
transformado = false
semantico = false
semantico_errores = false
simbolos = false
transFormer = true
coder = true
coder_debugger = true
cuadruplas = false

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

sem = Semantics.new(final)
if semantico
  puts '------------------------------------------------------------------
  arbol- recorrido
  ------------------------------------------------------------------'
  sem.recorrer_arbol(final)
  sem.imprime_log
  puts '------------------------------------------------------------------
  fin recorrido
  ------------------------------------------------------------------'
else
  sem.recorrer_arbol(final)
  if semantico_errores
	sem.errores
  end
end


if simbolos
   puts '------------------------------------------------------------------
   Tabla de Simbolos :
   ------------------------------------------------------------------'
    pp $tablas_simbolos
end

# if coder
#   code = Code.new(final)
#   code.recorrer_arbol(final)
#   code.imp_has
# end
  #opciones
testTrans = CodeTrans.new
if transFormer
  puts "\n" + "wat \n\n"
  pp wat = testTrans.apply(parseo)
else
  wat = testTrans.apply(parseo)
end

# puts 'PERRO'
# testTrans.imp_has

if coder
  code = Code.new(wat)
  code.recorrer_arbol(wat)

  if coder_debugger
    pp 'nuevo'
    code.imp_has
  end
  if cuadruplas
    pp 'cuadruplas'
    code.imp_cuad
  end

  # pp t.class

  t = code.get_code
  traduccion = Traductor.new(t)
  traduccion.traducir
  traduccion.imprime
end
