require_relative 'lex'
require_relative 'tokens'
require_relative 'sintax'

#leer el archivo de texto
strings = Array.new # lista de cadenas para trabajar
contents = File.readlines("./poop.txt").each do |line|
  strings.push (line)
end

#arreglo donde se guardan las lineas
lineas_arreglo = []

#guardar las lineas en un nuevo arreglo donde se separan por palabras
strings.each do |linea|
  wat = linea.split(/[\t \n]/)
  lineas_arreglo.push(wat)
end


tokens = []
# asignar tokens a las palabras del sistema
  i = 0
lineas_arreglo.each do |linea|
  linea.each do |palabra|
    tokens.push(Tokens.new(verificar_token(palabra), palabra, i))
    i += 1
    #puts tokens.to_s
  end
end

#obtener el arreglo de estructuras
=begin
ARREGLO_ESTRUCTURAS.each do |una|
  if una.estructura.first.is_a? String
    #puts una.estructura.first
  elsif
    #puts una.estructura.first[0]
  end
end
=end
#llamar a la funcion que compara, creando una instancia del analizador
a = Analizer.new(tokens)
a.iniciar
