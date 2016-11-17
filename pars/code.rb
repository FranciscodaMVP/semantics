class Code
  attr_accessor :lista
  def initialize (lista)
    @lista = lista
    @code = String.new
  end

  def recorrer_arbol (arbol)
      arbol.each do |key, value|
        if value.is_a?(Hash)
          puts "llave : #{key} -- iterando"
          genera(key, value)
          recorrer_arbol(value)
        else
          puts "llave : #{key}, valor : #{value}"
          # puts 'clase'
          # puts key.class
          genera(key,value)
        end
      end
  end

  def genera(llave, valor)
    if llave == :bloqueDeclaracion
      pp 'fuckwat'
      pp valor.values[0]
      pp valor.keys[0].value
    end
  end

end
