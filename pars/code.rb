class Code
  attr_accessor :lista
  def initialize (lista)
    @lista = lista
    @code = String.new
    @temps = 0
  end

  def recorrer_arbol (arbol)
      arbol.each do |key, value|
        if value.is_a?(Hash)
          puts "llave : #{key} -- iterando en codes"
          genera(key, value)
          recorrer_arbol(value)
        else
          puts "llave : #{key}, valor : #{value} en codes"
          # puts 'clase'
          # puts key.class
          genera(key,value)
        end
      end
  end

  def genera(llave, valor)
    if llave == :bloqueExpresion
      recorrer_expresion(valor)
    end
  end

  def recorrer_expresion (expre)
    pp 'recorriendo expresion'
    expre.each do |key, value|
      if value.is_a?(Hash)
        if value.has_key?(:izq)
          puts value
          pp 'fuck'
          recorrer_expresion(value)
        else
          pp 'the UFCKS'
          puts value
        end
      end
    end
  end

  def genera_inter()#op)

  end

  def genera_aux
    nombre_aux = 't'+@temps.to_s
    # pp nombre_aux
    @temps += 1
    # pp 'el valor de en temporal es = '+@temps.to_s
  end
end
