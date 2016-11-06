class Tokens
  attr_accessor :token_tok, :token_lexema, :token_linea
  def initialize(token, lexema, linea)
    @token_tok = token
    @token_lexema = lexema
    @token_linea = linea
  end
end

class Estructura_sintactica
  attr_accessor :nombre, :permite_llamar, :estructura
  #self.estructura []
  def initialize (nombre, permite_llamar, estructura)
    @nombre = nombre
    @permite_llamar = permite_llamar
    @estructura = estructura
  end
end

class Lista_estructuras
  attr_accessor :lista
  def initialize (lista)
    @lista=lista
  end
end

#cambiar instruccion por using, solo fue para prueba
a_clase = ["clase", "id", "barra", "alcance", "declaracion", "PyC","vacio","parI","tipoDato", "id","parD", "id","barra","limite","instruccion", "llaveDer"]
a_doWhile = [["haz",true], "instruccion" , ["mientras",true], "Jordan" , "llaveDer"]
a_arreglo = ["tipoDato", "flI", "flD", "id", "igual", "tipoDato", "flI", "dato", "flD", "nuevo"]
a_listas = ["barra","tipoC", "barra", "id", "list", "igual", "barra", "tipoC","barra", "id", "nuevo", "barra", "barra", "PyC"]
a_si = ["si", "condicion", "instrucciones", "llaveDer", "entonces", "si", "condicion", "instrucciones", "entonces", "instrucciones", "llaveDer"]
a_while = ["mientras", "condicion", "instruccion", "llaveDer"]
a_para = ["para", "id", "en", "tipo", "llaveIzq", "instrucciones", "llaveDer"]
a_importar = ["importar", "id"]

=begin
a_clase = ["clase", "id", "barra", "alcance", "declaracion", "PyC","vacio","parI","tipoDato", "id","parD", "id","barra","limite","instruccion", "llaveDer"]
# lista de arreglos
a_arreglo = ["tipoDato", "flI", "flD", "id", "igual", "tipoDato", "flI", "dato", "flD", "nuevo"]
a_listas = ["barra","tipoC", "barra", "id", "list", "igual", "barra", "tipoC","barra", "id", "nuevo", "barra", "barra", "PyC"]
a_si = ["si", "condicion", "instrucciones", "llaveDer", "entonces", "si", "condicion", "instrucciones", "entonces", "instrucciones", "llaveDer"]
a_while = ["mientras", "condicion", "instruccion", "llaveDer"]
a_para = ["para", "id", "en", "tipo", "llaveIzq", "instrucciones", "llaveDer"]
a_importar = ["importar", "id"]
a_estruck = ["estructura", "id", "tipoDato", "id", "llaveDer"]
#var funcion = [funcion, "id", "parametro"?, "flD", "tipoDato", "instruccion", "llaveDer"]
a_guard = ["guard", "condicion", "entonces", "instruccion", "llaveDer"]
#switch que meter en los espacios en blanco?
a_seleccion = ["seleccion", "id", "barra", "caso",, "tipo", "barra", "instruccion", "caso",, "tipo", "barra", "instruccion", , "default", "instruccion", "llaveDer"]
# switch
a_inicializacion = ["iniciar", "parametro", "id", "instruccion", "llaveDer"]
#diccio [] = ["corI", ,"tipoDato", "barra", "tipoDato", "corD",, "id", "diccionario", "igual", "corI",, "comilla", "tipo", "barra", "tipo", ("tipo", "barra", "tipo",)?, "corD",]
a_tryCatch = ["probar", "barra", "instruccion", "llaveDer", "pescar", "barra", "id", "punto", "id", "instruccion", "llaveDer"]
a_enume = ["enumera", "id", "barra", "id", "barra", "caso",, "id", ("caso",, "id")?, "llaveDer"]
a_liberar = ["liberar", "barra", "instruccion", "llaveDer"]
a_generico = ["funcion", "id", "corI",, "generic", "corD",, "parI", "id", "barra", "generic", "coma", "id", "barra", "generic", "instruccion", "llaveDer"]
#bloque [] = ["corI",, "tipoDato", "corD",, "id", "parI", "id", "barra", "tipoDato", "coma", "id", "barra", "tipoDato", "parD", "barra", "instruccion", "llaveDer"]
a_protocolo = ["protocolo", "id", "barra", "id", "barra", "tipodato", "corI",, ("toma", "asigna")?, "llaveDer"]
a_metodo = ["metodo", "id", "parI", "id", "barra", "tipoDato", "parD", "instruccion", "llaveDer"]
a_extender = ["extra", "id", "barra", "instruccion", "llaveDer"]
a_preProceso = ["gato", "importar", "instruccion", "llaveDer"]
a_imprimir = ["imprimir", "parI", "comilla", "dato", "comilla", "parD"]
a_comentario = ["diagonal", "admiracion", "dato", "admiracion", "diagonal"]
a_defTipo = ["defTipo", "tipoDato", "id", "barra", "instrucciones", "llaveDer"]
a_aleatorio = ["aleatorio", "punto", "id", "igual", "tipoDato" "parI", ("tipo", "punto", "punto", "punto", "tipo")?, "parD"]
a_agregar = ["agregar", "punto", "id", "igual", "tipoDato", "parI", "id", "coma", "tipo", "parD"]
=end

ARREGLO_ESTRUCTURAS = [
(Estructura_sintactica.new(nombre = 'Do while', permite_llamar=false, estructura = a_doWhile)),
(Estructura_sintactica.new(nombre = 'Clase', permite_llamar=false, estructura = a_clase)),
(Estructura_sintactica.new(nombre = 'Arreglo', permite_llamar = false, estructura = a_arreglo)),
(Estructura_sintactica.new(nombre = 'Lista', permite_llamar = false, estructura = a_listas)),
(Estructura_sintactica.new(nombre = 'Lista', permite_llamar = false, estructura = a_listas)),
(Estructura_sintactica.new(nombre = 'Si', permite_llamar = false, estructura = a_si)),
(Estructura_sintactica.new(nombre = 'While', permite_llamar = false, estructura = a_while)),
(Estructura_sintactica.new(nombre = 'Para', permite_llamar = false, estructura = a_para)),
(Estructura_sintactica.new(nombre = 'Importar', permite_llamar = false, estructura = a_importar))]

#puts arreglo_estructuras.to_s

=begin
arreglo_estructuras.each do |estruc|
  puts estruc.estructura.first.is_a? String
=end
