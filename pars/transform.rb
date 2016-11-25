require 'parslet'
require 'pp'
include Parslet
# semantico
def obtener_tipo(algo)
  case algo
  when '[:cadena]'
    return 'string'
  when '[:flotante]'
    return 'float'
  when '[:entero]'
    return 'int'
  else
    return ('desconocido'+algo.to_s+' class = '+ algo.class.to_s)
  end
end

class CodeDeclara < Parslet::Transform
  # rule( :declaracion =>  simple(:opk)) {opk.to_s}

  rule( :opLL =>  simple(:opk)) {opk.to_s}

  rule( :identi =>  simple(:id)) {id.to_s}
#test con clase
  rule( :clase     =>  simple(:clase),
        :id  =>  subtree(:clasid)) do { clase.to_s => clasid}end# bloque_actual[id.to_s]=valor end#; }end

#partes del TIPO DATO
  # CON ESTO FUNCA
  # rule( :entero    =>  simple(:t)) {t}
  # rule( :flotante =>  simple(:y))  {y}
  # rule( :cadena =>  simple(:y))  {y}

  # rule( :der    =>  simple(:der)
  #       :entero =>  subtree(:p)) { der => p }


  rule( :id     =>  simple(:d)) {d.to_s}

  rule( :id     =>  simple(:id),
        :valor  =>  subtree(:valor)) do { id.to_s => valor}end# bloque_actual[id.to_s]=valor end#; }end

  rule( :id     => simple(:i),
        :opLL   => subtree(:l),
        :entero => subtree(:le),
        ) { i.to_s + l.to_s+le.to_s }

  rule( :condicion  =>  simple(:con),) {con.to_s}

  # rule( :declaracion  =>  subtree(:algo)) do { algo.keys[0] => obtener_tipo(algo.values[0].keys.to_s) } end
  rule( :declaracion  =>  subtree(:algo)) do { :declaracion => {:id => algo.keys[0], :tipo =>obtener_tipo(algo.values[0].keys.to_s), :valor => algo.values[0]}} end
  # rule( :declaracion  =>  subtree(:algo)) { algo.values[0].values}

end

class CodeTrans < Parslet::Transform
  rule( :parame  =>  subtree(:con)) {con}

  rule( :entero    =>  simple(:t)) {t}
  rule( :flotante =>  simple(:y))  {y}
  rule( :cadena =>  simple(:y))  {y}

  rule( :algo  =>  subtree(:con)) {con}
end

class Trans < Parslet::Transform

  # rule( :identi =>  simple(:iden),
        # :id =>  subtree(:valor)) do {id.to_s => valor} end
#test con clase
  rule( :clase     =>  simple(:clase),
        :id  =>  subtree(:clasid)) do { clase.to_s => clasid}end# bloque_actual[id.to_s]=valor end#; }end

#new
  rule( :opLL =>  simple(:opk)) {opk.to_s}
  rule( :op => subtree(:op))
  rule( :entero    =>  simple(:t)) {"entero"}
  rule( :flotante =>  simple(:y))  {"flotante"}
  rule( :cadena =>  simple(:y))  {"cadena"}
  rule( :declaracion     =>  subtree(:d)) {d}

  rule( :id     =>  simple(:d)) {d.to_s}

  rule( :id     =>  simple(:id),
        :valor  =>  subtree(:valor)) do { id.to_s => valor}end# bloque_actual[id.to_s]=valor end#; }end

  rule( :id     => simple(:i),
        :opLL   => subtree(:l),
        :entero => subtree(:le),
        ) { i.to_s + l.to_s+le.to_s }

  rule( :condicion  =>  simple(:con),) {con.to_s}
end

ListaFun = Struct.new(:name, :args, :op) do
  def eval; p args.map { |s| s.eval }; end
end
