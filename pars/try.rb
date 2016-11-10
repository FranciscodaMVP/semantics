require_relative 'parsing'
require 'pp'

parser = MyOwn.new
trans = Trans.new

 cadena =''
 File.open("algo.txt", "r") do |t|
   t.each_line do |line|
     cadena += line
   end
 end

 #debug
 # puts 'debugger'
 # parse (cadena)
 #fin debug


 parseo = parser.parse(cadena)
 #pp parseo = parser.parse(cadena)
 pp final = trans.apply(parseo)

 puts 'arbol- recorrido'
 sem = Semantics.new(final)
 sem.recorrer_arbol(final)
 puts 'fin recorrido'

 puts 'Tabla de Simbolos : '

  pp $tablas_simbolos
