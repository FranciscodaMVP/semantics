
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
    @lista_errores = Hash.new
    @log = String.new
    @ob_exp = Hash.new
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
		# @log += "\n----------------DECLARACION-----------------"
        # @log << "\nllave\n"
		# @log << llave.to_s
		# @log << "\nvalor \n"
		# @log << valor.to_s
		# @log += "\n----------------FIN DECLARACION-----------------"
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

      @log += "\n----------------EXPRESION-----------------"
      @log << "\nllave\n"
      @log << llave.to_s
      @log << "\nvalor \n"
      @log << valor.to_s
      @old_padre = padre
      @padre = @bloque_actual[:nombre]
      simb_expresion(valor)
      @log += "\n----------------FIN EXPRESION-----------------"
      @padre = @old_padre
    end

    if llave == :bloqueFuncion
      @log += "\n----------------FUNCION-----------------"
      @log << "\nllave\n"
      @log << llave.to_s
      @log << "\nvalor \n"
      @log << valor.to_s
      @log += "\n----------------FIN FUNCION-----------------"
    end
  end

# Creacion de simbolos
  def funcion(bloque)

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
    @log << "\nbloque actual\n"
    @log <<   @bloque_actual.to_s
    @contador_exp += 1
    nombre = 'param'+@contador_exp.to_s
    if bloque[:izq].is_a?(Hash)
      id = bloque[:izq][:identi]
      @log << "\nid - variable\n"
      @log << id.to_s

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
      @log << "\ntipo del objeto\n"
      @log << tipo.to_s

      # gurdar tipos
      a = {:nombre => nombre, :padre => @padre, :tipo => tipo}
      @bloque_actual[@bloques] = a
      @bloques +=1
    end

    @log << "\nid\n"
    @log << nombre.to_s
    @log << "\nllaves\n"
    @log << bloque.keys.to_s

    # RECURSIVIDAD
    if bloque[:der].is_a?(Hash)
      a = bloque[:der]
      # LADO DERECHO VAR
      if a[:identi]
        @log << "entramos al identi"
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
        @log << "\nLETS GO DEEPER\n"
      end
    else
      @log << "\nNo SE LLEGAR AQUI\n"
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
      @log << "\n\nFETCHING DE LA TABLA DE SIMBOLOS"
      @log << fetch[:tipo]
      @log << "\n\nFETCHING DE LA TABLA DE SIMBOLOS"
      return fetch[:tipo]
    else
      @log << "\n\n"+buscar.to_s
      @log << "\n\nNOPENOPENOPE\n\n"
      return 'NOPE'
    end
  end

  def imprime_log
      puts @log
  end

end
