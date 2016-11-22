class Code
  attr_accessor :lista
  def initialize (lista)
    @lista = lista
    @code = Array.new
    @temps = 0
    @datos_hash = String.new
    # @lista_exp = Hash.new
  end

  def recorrer_arbol (arbol)
      arbol.each do |key, value|
        if value.is_a?(Hash)
          # puts "llave : #{key} -- iterando en codes"
          genera(key, value)
          recorrer_arbol(value)
        else
          # puts "llave : #{key}, valor : #{value} en codes"
          # puts 'clase'
          # puts key.class
          genera(key,value)
        end
      end
  end

  def genera(llave, valor)
    if llave == :bloqueExpresion
      recorrer_expresion(valor)
      id = valor[:id]
      temp = 't'+(@temps-1).to_s
      genera_inter('asigna', id, temp, nil )
    end
  end

  def recorrer_expresion(expre)
    a =false
    @datos_hash << "\n"+ 'expresion'
    @datos_hash << "\n"+ expre.to_s

    if expre[:der].is_a?(Hash)
      @datos_hash << "\n"+ 'hashi'
      @datos_hash << "\n"+ expre[:der].to_s
      recorrer_expresion(expre[:der])
      a =true
    else
      aux = genera_aux
      @datos_hash << "\n"+ genera_inter(expre[:op], expre[:izq], expre[:der], aux).to_s
      @datos_hash << "\n"+ @temps.to_s
    end

    if a
      @datos_hash << "\n" + "final de la vuelta"
      expre[:der] = 't'+(@temps-1).to_s
      @datos_hash << "\n" + expre.to_s
      recorrer_expresion(expre)
    end
  end

  def genera_inter(instruccion, izq, der, aux)#op)
    case
      # formato = op, resultado, arg1, arg2
    when instruccion == "*"
      b = ["multi", aux, izq, der]

    when instruccion == "-"
      b = ["resta", aux, izq, der]
    when instruccion == "+"
      b = ["suma", aux, izq, der]
    when instruccion == "/"
      b = ["divs", aux, izq, der]
    when instruccion == "asigna"
      b = ["asign", izq, der, '--']
    end
    @code << b
    # pp b

  end

  def genera_aux # generacion de temporales
    nombre_aux = 't'+@temps.to_s
    # pp nombre_aux
    @temps += 1
    # pp 'el valor de en temporal es = '+@temps.to_s
    return nombre_aux
  end

  def imp_has
    # puts @datos_hash
    pp @code
  end
end


  # def recorrer_expresion (expre)
  #   @datos_hash += "\n"+'---------- DENTRO DEL HASH ----------'
  #   @datos_hash << "\n"+'recorriendo expresion'
  #   @datos_hash << expre.to_s
  #   expre.each do |key, value|
  #
  #     if value.is_a?(Hash)
  #       if value.has_key?(:izq) #&& value.has_key?()
  #         @datos_hash << "\n"+ 'adnetro del hash'
  #
  #         @datos_hash << "\n" + 'cada hash'
  #         @datos_hash << "\n" + ' key ' + expre.keys.to_s
  #         @datos_hash << "\n" + ' value ' + expre.values.to_s
  #
  #         @datos_hash << "\n" + 'GOING DEEPER' + "\n"
  #         @datos_hash <<
  #
  #         @datos_hash << "\n" + 'QUIEN SABE' + "\n"
  #         @datos_hash << "\n"+ value.to_s
  #         @datos_hash << "\n" + 'datos a guardar'
  #         @datos_hash << "\n" + value.keys[0].to_s
  #         @datos_hash << "\n" + value.values[0].to_s
  #         @datos_hash << "\n" + value.values[0].values.to_s + 'guardar'
  #         @datos_hash << "\n" + 'operador'
  #         @datos_hash << "\n" + value.values[1].to_s + 'op'
  #
  #         @datos_hash << "\n" + 'Guardando datos en el hash' + "\n"
  #
  #         a = genera_aux
  #         @lista_exp[a]= {value.values[0].values => value.values[1].to_s }
  #         # @datos_hash << "\n" + value.keys[0].identi
  #         # genera_aux
  #         puts ' lista operadores'
  #         recorrer_expresion(value)
  #       else
  #         @datos_hash << "\n"+ 'fin hash'
  #         @datos_hash << "\n"+ value.to_s
  #       end
  #     end
  #   end
  # end

  # t = expre[:der]
  # expre.each do |key, value|
  #   if value.is_a?(Hash)
  #     @datos_hash << "\n"+ 'key - SI ES HASH'
  #     @datos_hash << "\n"+ value.keys.to_s
  #
  #     # @datos_hash << "\n"+ 'fin hash'
  #     # @datos_hash << "\n"+ value.to_s
  #   end
  #     @datos_hash << "\n"+ 'NIGGA WHO KNOWS'
  #     @datos_hash << "\n"+ value[:izq]
  #
  #     if value[:izq]
  #       @datos_hash << "\n"+ 'volvemos a rntra'
  #       recorrer_expresion(value[:der])
  #     else
  #       @datos_hash << "\n"+ 'genera inter'
  #       @datos_hash << "\n"+ aux = genera_aux.to_s
  #       @datos_hash << "\n"+ genera_inter(value[:op], value[:izq], value[:der], aux).to_s
  #     end
  #   end
  # end
  # genera_inter('asigna', expre[:id], aux, nil)

#  j := a * b + c * d
# k > p:
# then
  # c = + 1 }
