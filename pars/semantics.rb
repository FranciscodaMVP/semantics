
#Objeto
class Semantics
  attr_accessor :lista
  def initialize (lista)
    @lista=lista
    @bloques = 0
    @old_padre
    @padre = 'main'
    $tablas_simbolos = Hash.new
    $tablas_simbolos['main']={:nombre => 'main', :padre => nil}
    @bloque_actual = $tablas_simbolos['main']
    @lista_errores = String.new
    @log = String.new
    @ob_exp = Hash.new
    @funcion = 0
    @llamafuncion = 0
    @contador_exp = 0

  end
  # RECORRER ARBOL
  def recorrer_arbol(arbol)
      arbol.each do |key, value|
        if value.is_a?(Hash)
          evalua_llave(key, value)
          recorrer_arbol(value)
        else
          evalua_llave(key,value)
        end
      end
  end

# revisa bloques
  def evalua_llave(llave, valor)
  	if llave == :bloqueDeclaracion
		@log += "\n----------------DECLARACION-----------------"
        @log << "\nllave\n"
		@log << llave.to_s
		@log << "\nvalor \n"
		@log << valor.to_s
		@log += "\n----------------FIN DECLARACION-----------------"
		simb_declaracion(valor)
  	end

    if llave == :bloqueExpresion
      nombre = valor[:id]
      clase = "expresion"
      padre = @padre

      a = {:nombre => @bloques, :id => nombre, :clase => clase, :padre => padre}
      $tablas_simbolos[@bloques]=a
      @bloque_actual = $tablas_simbolos[@bloques]
      @bloques +=1

      # @log += "\n----------------EXPRESION-----------------"
      # @log << "\nllave\n"
      # @log << llave.to_s
      # @log << "\nvalor \n"
      # @log << valor.to_s
      @old_padre = padre
      @padre = @bloque_actual[:nombre]
      simb_expresion(valor)
      # @log += "\n----------------FIN EXPRESION-----------------"
      @padre = @old_padre
    end

    if llave == :bloqueFuncion
      #log
      @log += "\n----------------FUNCION-----------------"
      @log << "\nllave\n"
      @log << llave.to_s
      @log << "\nvalor \n"
      @log << valor.to_s
      @log += "\n----------------FIN FUNCION-----------------"
      @log += "\n"+@funcion.to_s
      #crear simbolo
      @funcion = 0
      nombre = valor[:funcId]
      clase = "funcion"
      funcion(valor)
      padre = @padre
      num_datos = @funcion

       a = {:nombre => @bloques, :id => nombre, :clase => clase, :padre => padre, :datos =>num_datos }
      #  $tablas_simbolos[@bloques]=a
       $tablas_simbolos[nombre]=a
       @bloque_actual = $tablas_simbolos[@bloques]
       @bloques +=1
    end

    if llave == :llamadafuncion
      @log += "\n----------------LLAMADA FUNCION-----------------"
      @log << "\nllave\n"
      @log << llave.to_s
      @log << "\nvalor \n"
      @log << valor.to_s
      funcion_llamada(valor)
      @llamafuncion += 1
      @log += "\n----------------LLAMADA FIN FUNCION-----------------"
      @log += "\n"+@llamafuncion.to_s

      #crear simbolo
      nombre = valor[:identificador]
      clase = "llamada"
      padre = @padre
      num_datos = @llamafuncion

       a = {:nombre => @bloques, :id => nombre, :clase => clase, :padre => padre, :datos =>num_datos }
      #  $tablas_simbolos[@bloques]=a
       $tablas_simbolos[@bloques]=a
       @bloque_actual = $tablas_simbolos[@bloques]
       @bloques +=1

      @llamafuncion = 0
    end
  end

# Creacion de simbolos
  def funcion_llamada(bloque)
    if bloque[:paramF]
      if bloque[:paramsF]
        t = bloque[:paramsF]
        @log += "\n----------------IMPRIME PARAMS DE LA LLAMADA-----------------\n"
        @log << bloque[:paramsF].to_s
        funcion_llamada(t)
        @llamafuncion += 1
      end
    elsif bloque[:paramsF]
      # @log += "\n----------------IMPRIME PARAMS DE LA LLAMADA-----------------\n"
      # @log << bloque[:paramsF].to_s
      t = bloque[:paramsF]
      @llamafuncion += 1
      funcion_llamada(t)


    end
  end

  def funcion(bloque)
    if bloque[:parametros]
      @funcion += 1
      t = bloque[:parametros][:parame]
      # @log += "\n----------------IMPRIME PARAMS-----------------\n"
      # @log << bloque[:parametros][:parame].to_s
      funcion(t)
      @funcion += 1
    elsif bloque[:parame]
      # @log += "\n----------------IMPRIME PARAMS-----------------\n"
      # @log << bloque[:parame].to_s
      t = bloque[:parame]
      @funcion += 1
      funcion(t)
    end

  end

	def simb_declaracion(bloque)
	  nombre = bloque.keys.join
	  tipo = bloque.values.join
	  numero = @bloques
	  a = {:tipo => tipo, :clase => "declaracion", :padre => @padre, :nombre => nombre, :numero => numero}
    @bloque_actual[nombre]= a
      @bloques +=1
	end

  def simb_expresion(bloque)
    # @log << "\nbloque actual\n"
    # @log <<   @bloque_actual.to_s
    @contador_exp += 1
    nombre = 'param'+@contador_exp.to_s
    if bloque[:izq].is_a?(Hash)
      id = bloque[:izq][:identi]
      # @log << "\nid - variable\n"
      # @log << id.to_s

      # agregar tipo a los datos
      res = fetching(id)
      case res
      when 'NOPE'
        tipo='no existe'
      else tipo = res
      end
      a = {:nombre => nombre, :padre=> @padre, :id => id, :tipo => tipo}
      # agregar tipo a los datos
      @bloque_actual[@bloques] = a
      @bloques +=1
    else
      tipo = bloque[:izq]
      # @log << "\ntipo del objeto\n"
      # @log << tipo.to_s

      # gurdar tipos
      a = {:nombre => nombre, :padre => @padre, :tipo => tipo}
      @bloque_actual[@bloques] = a
      @bloques +=1
    end

    # @log << "\nid\n"
    # @log << nombre.to_s
    # @log << "\nllaves\n"
    # @log << bloque.keys.to_s

    # RECURSIVIDAD
    if bloque[:der].is_a?(Hash)
      a = bloque[:der]
      # LADO DERECHO VAR
      if a[:identi]
        @log << "entramos al identi\n"
        @log << a.to_s
        id = a[:identi]
        res = fetching(id)

        # agregar tipo a los datos
        case res
        when 'NOPE'
          tipo='no existe'
        else tipo = res
        end
        a = {:nombre => nombre, :padre=> @padre, :id => id, :tipo => tipo}
        # agregar tipo a los datos
        $tablas_simbolos[@bloques]=a
        @bloque_actual[@bloques] = a
        @bloques +=1
      # LADO DERECHO TIPO DATO
      else
        simb_expresion(bloque[:der])
        # @log << "\nLETS GO DEEPER\n"
      end
    else
      # @log << "\nNo SE LLEGAR AQUI\n"
      @log << bloque[:der].to_s
      tipo = bloque[:der]
      a = {:nombre => nombre, :padre => @padre, :tipo => tipo}
      @bloque_actual[@bloques] = a

      @bloques +=1
    end
  end

  def fetching(buscar)
    if $tablas_simbolos['main'].key?(buscar)
      fetch = $tablas_simbolos['main'].fetch(buscar)
      @log << "\n\nFETCHING DE LA TABLA DE SIMBOLOS\n"
      @log << fetch[:tipo]
      @log << "\n\nFETCHING DE LA TABLA DE SIMBOLOS\n"
      return fetch[:tipo]
    else
      @log << "\n\n"+buscar.to_s+" no se encontro"
      # @log << "\n\nNo se encontro\n\n" #+$tablas_simbolos['main'].key.to_s
      return 'NOPE'
    end
  end

  def imprime_simbolos
    puts 'tabla de simbolos'
    pp $tablas_simbolos
  end

  def imprime_log
      puts @log
  end

# REVISAR EL ARBOL DE FUNCIONES
# CREAR UN CASO DE USO PARA CADA TIPO
  def revisar
    # puts 'funcion revisar'
    $tablas_simbolos.each do |key, value|
      if value.key?(:clase)
        # puts "datos de la expresion \n"
        if value[:clase] == 'expresion'
          revisar_expresion(value, value[:id])
        end
        # puts "fin de la expresion"

      end
    end
  end

  def revisar_expresion(algo, id)
    ary = Array.new
    algo.each do |key, value|
        if value.is_a?(Hash)
          if value.key?(:nombre)
            # puts 'cambio'
            # puts value
            # puts value[:tipo]
            if value[:tipo] == 'no existe'
              @lista_errores << "'"+value[:id]+"' no esta definido dentro del programa\n"
              # puts "\n '"+value[:id]+"' no esta definido dentro del programa\n"

            end
            ary << value[:tipo]
          end
        end
    end
    mensaje = id
    revisar_arreglo(ary, mensaje)
  end

  def revisar_arreglo(checks, enviar)
    # pp checks
    # pp checks.uniq.length
    # puts ' el id'
    # pp enviar

    # if checks.uniq.length > 1
    #   @lista_errores << "Error en "+ enviar+" los valores no corresponden\n"
    # end

    if checks.uniq.length == 2 && checks.uniq.include?('flotante') && checks.uniq.include?('entero')
      @lista_errores << "Advertencia "+enviar+" contiene datos de tipo entero y flotante"
    elsif checks.uniq.length > 1
      @lista_errores << "Error en "+ enviar+" los valores no corresponden\n"
    end
  end

  def errores
    if @lista_errores.empty?
      puts "No se detectaron errores"
    else
      puts @lista_errores
    end
  end
end
