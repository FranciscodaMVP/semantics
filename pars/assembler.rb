class Assembler
  attr_accessor :lista
  def initialize (lista)
    @traduccion = lista
    @final = String.new
    @declarado = String.new
  end

  def traducir
    @declarado <<  "--------- VARS ---------" + "\n"
    @final <<  "--------- CODIGO ---------" + "\n"
    @traduccion.each do |ob|
      # pp ob[0]
      evaluar(ob)
    end
  end

  def tipo_dato(tipo)
    case tipo
    when 'string'
      return 'cadena'
    when 'float'
      return 'flotante'
    when 'int'
      return 'entero'
    end
  end

  def evaluar(algo)
    # pp algo[0]
    case algo[0]
    when "suma"
      @final <<  "  " + algo[1] + " = " + algo[2] + " + "+ algo[3]+ "\n"
    when "asign"
      @final <<  "  " + algo[1] + " = " + algo[2] + "\n"
    when "mayor"
      @final <<  "  cmp " +  algo[2] + ", " + algo[3] + "\n"
      @final <<  "  SETG " + algo[1] + "\n"
    when "menor"
      @final <<  "  cmp " +  algo[2] + ", " + algo[3] + "\n"
      @final <<  "  SETL " + algo[1] + "\n"
    when "mayorIgual"
      @final <<  "  cmp " +  algo[2] + ", " + algo[3] + "\n"
      @final <<  "  SETGE " + algo[1] + "\n"
    when "menorIgual"
      @final <<  "  cmp " +  algo[2] + ", " + algo[3] + "\n"
      @final <<  "  SETLE " + algo[1] + "\n"
    when "igualdad"
      @final <<  "  cmp " +  algo[2] + ", " + algo[3] + "\n"
      @final <<  "  SETE " + algo[1] + "\n"
    when "si_falso"
      @final <<  'if_falso ' + algo[1] + " GOTO " + algo[2] + "\n"
    when "si"
      @final <<  'if ' + algo[1] + " GOTO " + algo[2] + "\n"
    when "multi"
      @final <<  "  " + algo[1] + " = " + algo[2] + " * "+ algo[3]+ "\n"
    when "GOTO"
      @final << " GOTO " + algo[1] + "\n"
    when "ETI"
      @final <<  algo[1] + "\n"
    when "DECLARA"
      @declarado <<  "  " + algo[1] + " = " + algo[3] + " - " +tipo_dato(algo[2])+"\n"
    when "declaracionparam"
      @final <<  "  " + algo[2] + " = " + algo[1] +"\n"
#PUSH y COSAS DE ENSAMBLADOR
    when "PUSH"
      @final <<  " PUSH " + algo[1] +"\n"
      # @final <<  "  " + tipo_dato(algo[2]) + " = " + algo[1] + "\n"
    when "POP"
      @final <<  " POP " + algo[1] +"\n"
    end
  end

  def imprime
    puts @declarado
    puts @final
    File.open("test.txt", 'a') { |file| file.write(@final) }
    
  end

end
