
#Objeto
class Semantics
  attr_accessor :lista
  def initialize (lista)
    @lista=lista
    @bloques = 0
    @padre = 'main'
    $tablas_simbolos = Hash.new
    $tablas_simbolos['main']={:nombre => 'main', :padre => nil}
    @bloque_actual = $tablas_simbolos['main']
    @lista_errores = Hash.new
    # puts 'bloque inicial'
    # pp @bloque_actual
    @log = String.new
  end

  def recorrer_arbol(arbol)
      arbol.each do |key, value|
        if value.is_a?(Hash)
          # puts "llave : #{key} -- iterando"
          evalua_llave(key, value)
          recorrer_arbol(value)
        else
          # puts "llave : #{key}, valor : #{value}"
          # puts 'clase'
          # puts key.class
          evalua_llave(key,value)
        end
      end
  end

  def evalua_llave(llave, valor)
    #@padre = @padre_root
    # puts 'evalua llave UFCK'
    # pp (@padre)
    # padre = @bloque_actual[:nombre]
    if llave == :bloqueSi
      a = {:nombre => @bloques,:clase => 'if', :padre => @padre}
        $tablas_simbolos[@bloques]=a
        @bloque_actual = $tablas_simbolos[@bloques]
      @bloques +=1
      @padre = @bloque_actual[:nombre]
    end

  	if llave == :bloqueDeclaracion
      a = {:tipo => valor[:declaracion].values[0],:clase => valor.keys[0], :padre => @padre, :nombre => valor[:declaracion].keys[0], :numero => @bloques}
        @bloque_actual[valor[:declaracion].keys[0]]= a
        # pp 'bloque actual y llave'
        # pp [valor[:declaracion].keys[0]]
        # pp @bloque_actual
        # @bloque_actual = $tablas_simbolos[@bloques]
      @bloques +=1
  	end
    if llave == :bloqueExpresion
      a = {:nombre  =>  @bloques, :clase => 'expresion', :padre => @padre, :izq => valor[:izq], :der => valor[:der] }
        $tablas_simbolos[@bloques]=a
        @bloque_actual = $tablas_simbolos[@bloques]
      @bloques +=1
    end
    if llave == :clase
      a = {:nombre => valor[:claseId], :clase =>'clase', :padre => @padre, :variable =>valor[:id]}
        $tablas_simbolos[@bloques]=a
        # @bloque_actual = $tablas_simbolos[@bloques]
        @log += "\n"+("MOTHERFUCKING CLASSS FUCKING ASSHOLE")
      @bloques +=1
      @padre = @bloque_actual[:nombre]
    end

    if llave == :finBloque
      @padre = 'main'
      @log += "\n"+('final del bloque')
      @log += "\n"+(@padre)
      @bloque_actual = $tablas_simbolos['main']
    end
    # Recuerda nada mas hay que checar que la variable este guardada en el arbol de simbolos
    if llave == :identi or llave == :id
      encontrado = 0
      @log += "\n"+('----------------BUSCANDO LLAVES-----------------')
      # pp 'encontrado = '+encontrado.to_s
      @log << "\n"+valor
      # pp @bloque_actual
      @log << "\n"+@bloque_actual.has_key?(valor).to_s
      if @bloque_actual.has_key?(valor)
        encontrado =+ 1
      end
      @log += "\n"+('----------------PADRE-----------------')
      p = $tablas_simbolos[@bloque_actual[:padre]]
      @log += "\n"+p.to_s
      if p
        if p.has_key?(valor)
          encontrado =+ 1
        end
      end
      @log += "\n"+('----------------FIN BUSQUEDA-----------------')
      if encontrado == 0
        @log += "\n"+(valor.to_s + ', no se encuentra definido')
        @lista_errores[valor] = {valor.to_s => 0}
      end
    end

    def imprime_log
      puts @log
    end

    def errores
      if @lista_errores.empty?
        puts 'no se encontro ningun error'
      else
        # puts @lista_errores
        @lista_errores.each do |key, value|
          if value.is_a?(Hash)
            value.each do |key, value|
              puts 'identficador sin declarar - '+key
            end
            end
        end
      end
    end
  end
end
