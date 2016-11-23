class Traductor
  attr_accessor :lista
  def initialize (lista)
    @traduccion = lista
    @final = String.new
  end

  def traducir
    @final <<  "--------- CODIGO INTERMEDIO ---------" + "\n"
    @traduccion.each do |ob|
      # pp ob[0]
      evaluar(ob)
    end
  end

  def evaluar(algo)
    # pp algo[0]
    case algo[0]
    when "suma"
      @final <<  algo[1] + " = " + algo[2] + " + "+ algo[3]+ "\n"
    when "asign"
      @final <<  algo[1] + " = " + algo[2] + "\n"
    when "mayor"
      @final <<  algo[1] + " = "+ algo[2] + " > " + algo[3] + "\n"
    when "si_falso"
      @final <<  'if_falso ' + algo[1] + "  " + algo[2] + "\n"
    when "multi"
      @final <<  algo[1] + " = " + algo[2] + " * "+ algo[3]+ "\n"
    when "GOTO"
      @final << "GOTO " + algo[1] + "\n"
    when "ETI"
      @final <<  algo[1] + "\n"
    when "DECLARA"
      @final <<  algo[1] + " = " + algo[2] + "\n"

    end
  end

  def imprime
    puts @final
  end

end
