class Assembler
  attr_accessor :lista
  def initialize (lista)
    @traduccion = lista
    @final = String.new
    @declarado = String.new
  end

  def traducir
    @declarado <<  "\n.data\n"
    @final <<  "\n.code\n"
    @final <<  "\nMAIN: \n"

    @traduccion.each do |ob|
      # pp ob[0]
      evaluar(ob)
    end
    @final <<  "\nCODE ENDS\n"
    @final <<  "\nEND MAIN\n"

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
      # @final <<  "\nsuma\n"
      @final <<  "  LDA " + algo[3]+"\n"
      @final <<  "  ADC " + algo[2]+"\n"
      @final <<  "  MOV " + algo[1] +", "+"LDA\n"
      # @final <<  "  " + algo[1] + " = " + algo[2] + " + "+ algo[3]+ "\n"
    when "asign"
      # @final <<  "  " + algo[1] + " = " + algo[2] + "\n"
      @final <<  "  MOV " + algo[1] +", "+ algo[2] +"\n"
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
      # @final <<  "\multi\n"
      @final <<  "  LDA " + algo[3]+"\n"
      @final <<  "  MUL " + algo[2]+"\n"
      @final <<  "  MOV " + algo[1]+", LDA\n"
      # @final <<  "  " + algo[1] + " = " + algo[2] + " * "+ algo[3]+ "\n"
    when "GOTO"
      @final << " GOTO " + algo[1] + "\n"
    when "ETI"
      @final <<  "\n" + algo[1] + "\n"
    when "DECLARA"
      @declarado <<  "  " + algo[1] + " = " + algo[3] + " - " +tipo_dato(algo[2])+"\n"
    when "declaracionparam"
      @final <<  "  MOV " + algo[2] +", "+ algo[1] +"\n"
      # @final <<  "  " + algo[2] + " = " + algo[1] +"\n"
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
    File.open("test.txt", 'a') { |file| file.write(@declarado + @final) }

  end

end
