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
    #puts @token_list.to_s
    #puts 'tam'
    #puts @token_list.size
    while @error == 0 || @contador_tokens < @token_list.size-1

      ARREGLO_ESTRUCTURAS.each do |una|
  #comprueba si se trata de una cadena
        if una.estructura[@contador_tokens].is_a? String
          if @token_list[@contador_tokens].token_tok.to_s == una.estructura.first
            @match = 1
            puts 'match'
            puts @match
            analizador(una.estructura)
#=begin DEBUGGER
puts 'debugger cadena'
puts @token_list[@contador_tokens].token_tok.to_s
puts una.estructura.first
#=end
          # else
          #   puts 'error linea'
          #   puts una.estructura.first
          #   @error = 3
          #   error_messager(3)
          #   @token_list[@contador_tokens].token_tok.to_s
          end
        else
          if @token_list[@contador_tokens].token_tok.to_s == una.estructura.first[0]
            @match = 1
            puts 'match'
            puts @match
            analizador(una.estructura)
#=begin DEBUGGER
            puts 'debugger tupla'
            puts @token_list[@contador_tokens].token_tok.to_s
            puts una.estructura.first[0]
#=end
          # else
          #   puts 'error tupla'
          #   puts una.estructura.first[0]
          #   @error = 3
          #   error_messager(3)
          #   puts @token_list[@contador_tokens].token_tok.to_s
          end
        end # fin else
      end # fin arreglo estructuras
      @error = 3
      error_messager(3)
      #error_messager(3) ERROR - NO CORRESPONDE CON NINGUNA ESTRUCTURA

    end
  end #fin de iniciar

  def analizador (estructura)
    @estructura = estructura
    @contador_estructura = 0
    while @error == 0 && @contador_estructura < @estructura.size# metodo del analizador
      #comprobar cadenas
      if @estructura[@contador_estructura].is_a? String # si el primero no es tupla

        # agregar la comprobacion de recursividad
        if @token_list[@contador_tokens].token_tok.to_s == @estructura[@contador_estructura].to_s
          avanzar_contador_token
          @contador_estructura +=1
          puts 'a'
        elsif @estructura[@contador_estructura].to_s == 'instruccion'
            puts 'iniciar llamada'
            iniciar
        else
          error_messager(2)
          @error = 2
          puts 'b'

        end
      else
        # comprobar tuplas
        # agregar la comprobacion de recursividad
          if @token_list[@contador_tokens].token_tok.to_s == @estructura[@contador_estructura][0].to_s
          @contador_estructura +=1
          avanzar_contador_token





          puts 'c'

        else
          @contador_estructura +=1
          puts 'd'

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
      puts 'No se reconocio ninguna estructura en la linea '+ @token_list[@contador_tokens].token_linea.to_s
      puts 'token :'
      puts @token_list[@contador_tokens].token_lexema.to_s
    elsif @codigo == 4
      puts 'Se esperaba ' + @estructura[@contador_estructura][0].to_s
    end
  end

end
