require_relative 'parsing'
require_relative 'semantics'
require_relative 'transform'
require_relative 'code'
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
simbolos = true


 # debug
if debugger
   puts '------------------------------------------------------------------
   DEBUGGER
   ------------------------------------------------------------------'
   parse (cadena)
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
  sem.errores
end


if simbolos
   puts '------------------------------------------------------------------
   Tabla de Simbolos :
   ------------------------------------------------------------------'
    pp $tablas_simbolos
end

code = Code.new(final)
code.recorrer_arbol(final)
code.imp_has
  #opciones

# pp 'generacion de variables aleatorias'
# c = 0
# while c < 5 do
#   c += 1
#   code.genera_aux
# end
