class Code
  attr_accessor :lista
  def initialize (lista)
    @lista = lista
    @code = String.new
    @temps = 0
    @datos_hash = String.new
    @lista_exp = Hash.new
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
      r = recorrer_expresion(valor)
    end
    pp 'wat----------' + r.to_s
  end

  def recorrer_expresion (expre)
    lista_expresones = Hash.new
    @datos_hash += "\n"+'---------- DENTRO DEL HASH ----------'
    @datos_hash << "\n"+'recorriendo expresion'
    expre.each do |key, value|
      if value.is_a?(Hash)
        if value.has_key?(:izq)
          @datos_hash << "\n"+ 'adnetro del hash'
          @datos_hash << "\n"+ value.to_s
          @datos_hash << "\n" + 'datos a guardar'
          @datos_hash << "\n" + value.keys[0].to_s
          @datos_hash << "\n" + value.values[0].to_s
          @datos_hash << "\n" + value.values[0].values.to_s + 'guardar'
          @datos_hash << "\n" + 'operador'
          @datos_hash << "\n" + value.values[1].to_s + 'op'
          # a = genera_aux
          # @lista_exp[a]= {value.values[0].values => value.values[1].to_s }
          # @datos_hash << "\n" + value.keys[0].identi
          # genera_aux
          aux = expresiones(value)
          pp 'aux'
          pp aux[1]
          lista_expresones[aux[1]] = aux[0]
        else
          @datos_hash << "\n"+ 'fin hash'
          @datos_hash << "\n"+ value.to_s
        end
      end
    end
    return lista_expresones
  end

  def expresiones (expre)
    wat = Hash.new
    expre.each do |key, value|
      if value.is_a?(Hash)
        if value.has_key?(:izq)
          @datos_hash << "\n"+ 'adnetro del hash'
          @datos_hash << "\n"+ value.to_s
          @datos_hash << "\n" + 'datos a guardar'
          @datos_hash << "\n" + value.keys[0].to_s
          @datos_hash << "\n" + value.values[0].to_s
          @datos_hash << "\n" + value.values[0].values.to_s + 'guardar'
          @datos_hash << "\n" + 'operador'
          @datos_hash << "\n" + value.values[1].to_s + 'op'
          a = genera_aux
          wat[a]= {value.values[0].values => value.values[1].to_s }
          expresiones(value)
          pp 'what i am doing'
          pp wat
          return wat, a
        end
      end
    end
  end

  def genera_inter()#op)

  end

  def genera_aux # generacion de temporales
    nombre_aux = 't'+@temps.to_s
    # pp nombre_aux
    @temps += 1
    # pp 'el valor de en temporal es = '+@temps.to_s
    return nombre_aux
  end

  def imp_has
    puts @datos_hash
    puts ' lista operadores'
    # pp @lista_exp
  end

end
