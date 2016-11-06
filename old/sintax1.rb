class Analizer
  def initialize (token_list)
    @contador_tokens = 0
    @token_list = token_list
    @error = 0
  end

  # movimiento inicial del ciclo
  # agregar un error 3 quiere decir que el codigo no empieza con ninguno de las instrucciones que existen dentro de la lista
  def iniciar
    ARREGLO_ESTRUCTURAS.each do |una|
#comprueba si se trata de una cadena
      if una.estructura.first.is_a? String

        if @token_list.first.token_tok.to_s == una.estructura.first
          analizador(una.estructura)
        end
      else
        if @token_list.first.token_tok.to_s == una.estructura.first[0]
          analizador(una.estructura)
        end
      end
    end
    #error_messager(3)
  end

# hace avanzar el arreglo de tokens y determina el momento en que la lista de tokens se termino
# si el error es igual a 1 quiere decir que la lista de tokens se termino antes que la estructuras
# si el error es igual a 2 quiere decir que la lista de tokens no corresponde con la lista de estructuras
# agregar un evento que guarde las variables cuando se declaren, junto con su tipo de dato (de ser posible)

  def avanzar_contador_token
    if @contador_tokens < @token_list.size-1
      @contador_tokens += 1
      puts 'bitach'
    else
        error_messager(1)
        @error = 1
        puts 'fuckD'
        puts 'error ='
        puts (@error)
      #mandar aviso y averiguar si la estructura estaba completa.
    end
  end

# analiza la lista de tokens con la estructura que se le da como parametro
  def analizador (estructura)
    @estructura = estructura
    @contador_estructura = 0
    #p @estructura
    begin
      #puts 'token + '+@token_list[@contador_tokens].token_tok.to_s
      #puts 'Estructura + '+ @estructura[@contador_estructura][0].to_s
#=begin
      if @estructura[@contador_estructura].is_a? String
# llamar a comprobar
          comprobar
      else
# llamar a comprobar_tuplas
          comprobar_tuplas
      end
      #@contador_estructura +=1
      #avanzar_contador_token
    end while @error == 0 || (@contador_estructura < @estructura.size)
  end

  def error_messager(codigo_error)
    @codigo = codigo_error
    if @codigo == 1
      puts 'Se esperaba '
    elsif @codigo == 2
      puts 'Se esperaba '+ @estructura[@contador_estructura].to_s
    elsif @codigo == 3
      puts 'No se reconocio ninguna estructura'
    elsif @codigo == 4
      puts 'Se esperaba ' + @estructura[@contador_estructura][0].to_s
    end

    # agregar un metodo para determinar si el archivo es dupla
    # pero si es dupla quiere decir que era opcional
    # checar primero si el archivo es tupla para determinar si es opcional
    # crear un arreglo hash con la lista de errores
    # definir una instruccion o bloque
    # determinar como se van a llamar funciones entre si
    #puts 'Se esperaba un '+@estructura[@contador_estructura].to_s
  end

  def comprobar_tuplas
    if @token_list[@contador_tokens].token_tok.to_s == @estructura[@contador_estructura][0].to_s
      @contador_estructura +=1
      avanzar_contador_token
      puts '1'

    else
      avanzar_contador_token
    end
  end

  def comprobar
    if @token_list[@contador_tokens].token_tok.to_s == @estructura[@contador_estructura].to_s
      puts '3'
      avanzar_contador_token
      @contador_estructura +=1

    else
      puts '4'
      error_messager(2)
      @error = 2


    end
  end

end
#------------------------------------------------------
#FUNCIONA TODO
#------------------------------------------------------
class Analizer
  def initialize (token_list)
    @contador_tokens = 0
    @token_list = token_list
    @error = 0
  end

  def avanzar_contador_token
    if @contador_tokens < @token_list.size-1
      @contador_tokens += 1
    else
        error_messager(1)
        @error = 1
      #mandar aviso y averiguar si la estructura estaba completa.
    end
  end

  def iniciar
    ARREGLO_ESTRUCTURAS.each do |una|
#comprueba si se trata de una cadena
      if una.estructura.first.is_a? String

        if @token_list.first.token_tok.to_s == una.estructura.first
          analizador(una.estructura)
        end
      else
        if @token_list.first.token_tok.to_s == una.estructura.first[0]
          analizador(una.estructura)
        end
      end # fin else
    end # fin arreglo estructuras
    #error_messager(3)
  end #fin de iniciar

  def analizador (estructura)
    @estructura = estructura
    @contador_estructura = 0
    while @error == 0 && @contador_estructura < @estructura.size# metodo del analizador
      #comprobar cadenas
      if @estructura[@contador_estructura].is_a? String # si el primero no es tupla
        if @token_list[@contador_tokens].token_tok.to_s == @estructura[@contador_estructura].to_s
          avanzar_contador_token
          @contador_estructura +=1
        else
          error_messager(2)
          @error = 2
        end
      else
        # comprobar tuplas
          if @token_list[@contador_tokens].token_tok.to_s == @estructura[@contador_estructura][0].to_s
            @contador_estructura +=1
            avanzar_contador_token
          else
            @contador_estructura +=1
          end
      end # fin tupla
    end  #termina metodo del analizador
  end

  def error_messager(codigo_error)
    @codigo = codigo_error
    if @codigo == 1
      puts 'Falta, se esperaba ' + @estructura[@contador_estructura].to_s
    elsif @codigo == 2
      puts 'Se esperaba '+ @estructura[@contador_estructura].to_s
    elsif @codigo == 3
      puts 'No se reconocio ninguna estructura'
    elsif @codigo == 4
      puts 'Se esperaba ' + @estructura[@contador_estructura][0].to_s
    end
  end

end
