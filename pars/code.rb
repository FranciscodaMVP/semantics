class Code
  attr_accessor :lista
  def initialize (lista)
    @lista = lista
    @code = Array.new
    @temps = 0
    @temps_label = 1
    @datos_hash = String.new
    @params = Array.new
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
      temp = 't'+(@temps).to_s
      genera_inter('asigna', id, temp, nil )
    end

    if llave == :bloqueSi
      recorrer_bloqueSi(valor)
    end

    if llave == :bloqueDeclaracion
      recorrer_declar(valor)
    end

    if llave == :bloqueFuncion
      checa_funcion(valor)
    end

    if llave == :llamadafuncion
      id = valor[:identificador]
      funcion =valor[:funcion]
      aux = genera_aux
      etiqueta = aux+' = CALL _'+funcion
      genera_inter('etiqueta',etiqueta, nil, nil)

      @params.each do |pa|
        genera_inter('PUSH', pa, '--', '--')
      end

      etiqueta2 = id+' = '+aux
      genera_inter('etiqueta', etiqueta2, '--', '--')

    end

    #label para terminar el bloque si que tiene else
    # RECORDATORIO INTENTAR IMPLEMENTAR VERSIONES DISTINTAS DE SI y SI ELSE
    if llave == :finBloqueSI
      etiqueta = 'Label'+(@temps_label-1).to_s
      genera_inter('etiqueta',etiqueta, nil, nil)
    end

    # fin bloque while
    if llave == :finWHile
      etiqueta = 'Label'+(@temps_label-1).to_s
      genera_inter('etiqueta',etiqueta, nil, nil)
    end

    if llave == :finFuncion
      etiqueta = 'END_FUNCTION'
      genera_inter('etiqueta',etiqueta, nil, nil)
    end

    if llave == :cicloWhile
      do_WHILE(valor)
    end
  end

  def checa_funcion(bloque)
    @params.clear
# CABEZA DE LA FUNCION
    @datos_hash << "\n FUNCION \n"
    @datos_hash << "\n"+ bloque.to_s
    @datos_hash << "\n PARAMS \n"
    etiqueta = "_"+bloque[:funcId]
    genera_inter('etiqueta',etiqueta, nil, nil)

# parametros
    if bloque[:parametros]
      @datos_hash <<  "\n"+bloque[:parametros].to_s
      params(bloque[:parametros])
    end

# salida o retorno de params
  # CALL X
  # POP TALGO
  @datos_hash << "\n PARAMETROS \n"
  @datos_hash << "\n"+ @params.to_s
  @datos_hash << "\n FIN PARAMETROS \n"

  # BEGIN FUNCTION
  etiqueta = 'BEGIN_FUNCTION'
  genera_inter('etiqueta',etiqueta, nil, nil)
  # Cuerpo de la funcion

  # etiqueta = 'END_FUNCTION'
  # genera_inter('etiqueta',etiqueta, nil, nil)
  end

  def params (bloque)
    @datos_hash << "\n CICLOS PARAMETROS \n"
    @datos_hash << "\n"+ bloque.to_s
    @datos_hash << "\n FIN CICLOS PARAMETROS \n"

    id = bloque[:param]
    tipo = bloque[:tipo]

    # declaracion
    aux = genera_aux
    genera_inter('declaracionparam', id, aux, '--')
    @params << id
    # PUSH de la var
    genera_inter('POP', aux, '--', '--')

    if bloque[:parame]
      params(bloque[:parame])
    end
  end

  def do_WHILE(bloque)
    @datos_hash << "\n CICLO WHILE \n"
    @datos_hash << "\n"+ bloque.to_s
    @datos_hash << "\n"+ 'FIN CICLO WHILE'

    # PARTE LOGICA
    aux = genera_aux
    aux1 = bloque[:logica][:izqCon]
    aux2 = bloque[:logica][:derCon]
    op = bloque[:logica][:op]
    @datos_hash << "\n GENERA INTER \n"
    @datos_hash << "\n  op = " + op + " aux = " + aux + " aux1 = "+aux1 + " aux 2 " + aux2
    genera_inter(op, aux, aux1, aux2).to_s
    #@datos_hash << "\n" + genera_inter(op, aux, aux1, aux2).to_s
    @datos_hash << "\n FIN GENERA INTER \n"

    #etiqueta do while
    etiqueta = genera_lbl_aux
    genera_inter('si',aux, etiqueta, nil)

    # ir a fin
    etiqueta2 = genera_lbl_aux
    genera_inter('goto',etiqueta2, nil, nil)

    # etiqueta
    genera_inter('etiqueta',etiqueta, nil, nil)

  end

  def recorrer_declar(bloque)
    @datos_hash << "\n"+ 'la declaracion'
    @datos_hash << "\n"+ bloque.to_s
    @datos_hash << "\n"+ 'dentro declaracion'
    @datos_hash << "\n"+ bloque[:declaracion][:id].to_s
    # @datos_hash << "\n"+ '------LLAVE------'
    # @datos_hash << "\n"+ bloque[:declaracion].keys[0].to_s
    # @datos_hash << "\n"+ '------valor------'
    # @datos_hash << "\n"+ bloque[:declaracion].values[0].to_s

    aux = genera_aux
    aux1 = bloque[:declaracion][:id]
    aux2 = bloque[:declaracion][:tipo]# :id, :tipo, :valor
    aux3 = bloque[:declaracion][:valor]# :id, :tipo, :valor
    genera_inter('declaracion', aux1, aux2, aux3)

  end

  def recorrer_bloqueSi(bloque)
  #   @datos_hash << "\n"+ 'el bloqueSi'
  #   @datos_hash << "\n"+ bloque.to_s
  #   @datos_hash << "\n"+ 'inside logica'
  #   @datos_hash << "\n"+ bloque[:logica][:izqCon].to_s
	# if bloque[:elses]
	# 	@datos_hash << "\n\n\n bloque ELSE "
	# 	@datos_hash << "\n"+ bloque[:elses].to_s
  #   @datos_hash << "\n"+ bloque[:elses][:wat].to_s
	# end
    aux = genera_aux
    aux1 = bloque[:logica][:izqCon]
    aux2 = bloque[:logica][:derCon]
    op = bloque[:logica][:op]
	@datos_hash << "\n GENERA INTER \n"
	@datos_hash << "\n  op = " + op + " aux = " + aux + " aux1 = "+aux1 + " aux 2 " + aux2
    genera_inter(op, aux, aux1, aux2).to_s
	#@datos_hash << "\n" + genera_inter(op, aux, aux1, aux2).to_s
	@datos_hash << "\n FIN GENERA INTER \n"

    #etiqueta
    #tp = 't'+(@temp).to_s
    etiqueta = genera_lbl_aux
    genera_inter('si-falso',aux, etiqueta, nil)

    #codigo interior
    @datos_hash << "\n"+ 'wat'
    @datos_hash << "\n"+ bloque[:wat].to_s
    recorrer_arbol(bloque[:wat])

    # goto
    etiqueta2 = genera_lbl_aux
    if bloque[:elses]
      genera_inter('goto',etiqueta2, nil, nil)
      genera_inter('etiqueta',etiqueta, nil, nil)
    else
      genera_inter('etiqueta',etiqueta, nil, nil)
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
	  @datos_hash << "\n Genera cuadrupla de expresion \n"
      @datos_hash << "\n"+ genera_inter(expre[:op], expre[:izq], expre[:der], aux).to_s
      @datos_hash << "\n"+ @temps.to_s
	  # @datos_hash << "\n TEMPORAL MENOS UNO \n"
	  @datos_hash << (@temps -= 1 )
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
	when instruccion == "=="
      b = ["igualdad", izq, der, aux]
    when instruccion == "/"
      b = ["divs", aux, izq, der]
    when instruccion == "asigna"
      b = ["asign", izq, der, '--']
    when instruccion == '>'
      b = ["mayor", izq, der, aux]
    when instruccion == '<'
      b = ["menor", izq, der, aux]
    when instruccion == '>='
      b = ["mayorIgual", izq, der, aux]
    when instruccion == '<='
      b = ["menorIgual", izq, der, aux]
    when instruccion == 'si'
      b = ["si", izq, der, '--']
    when instruccion == 'si-falso'
      b = ["si_falso", izq, der, '--']
    when instruccion == 'goto'
      b = ["GOTO", izq, '--', '--']
    when instruccion == 'etiqueta'
      b = ["ETI", izq, '--', '--']
    when instruccion == 'declaracion'
      b = ["DECLARA", izq, der, aux]
    when instruccion == 'declaracionparam'
      b = ["declaracionparam", izq, der, aux]
    when instruccion == 'PUSH'
      b = ["PUSH", izq, '--', '--']
    when instruccion == 'POP'
      b = ["POP", izq, '--', '--']
	else
	  b = [instruccion, izq, der, 'NOSE']

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

  def genera_lbl_aux
    nombre_label = 'Label'+@temps_label.to_s
    @temps_label += 1
    return nombre_label
  end

  def imp_has
    puts @datos_hash
  end

  def imp_cuad
    pp @code
  end

  def get_code
    return @code
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

# final
# t = "casa"
# M = 3.4
# f = 4
#
# M := t + 44
#
#
#   if n == 15:
#   then
#     t := t + 1
#   algo:
#   then
#     t := M + 1
#
#   }
#
#   funky suma (a entero, b entero, c entero):
#   resultado := a + b
#   return resultado
# }
