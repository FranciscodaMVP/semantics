require 'parslet'
require 'pp'
include Parslet
# semantico
class Trans < Parslet::Transform

  rule( :identi =>  simple(:iden),
        :id =>  subtree(:valor)) do {id.to_s => valor} end
#test con clase
  rule( :clase     =>  simple(:clase),
        :id  =>  subtree(:clasid)) do { clase.to_s => clasid}end# bloque_actual[id.to_s]=valor end#; }end

#funca
  rule( :entero =>  simple(:y)) do { "entero" =>  y } end

  rule( :cadena =>  simple(:y))  {"cadena"}

  rule( :id     =>  simple(:d)) {d.to_s}

  rule( :id     =>  simple(:id),
        :valor  =>  subtree(:valor)) do { id.to_s => valor}end# bloque_actual[id.to_s]=valor end#; }end

  rule( :id     => simple(:i),
        :opLL   => subtree(:l),
        :entero => subtree(:le),
        ) { i.to_s + l.to_s+le.to_s }

  rule( :condicion  =>  simple(:con),) {con.to_s}
end
# fin semantico

class CodeTrans < Parslet::Transform

  rule( :identi =>  simple(:id)) {id.to_s}
#test con clase
  rule( :clase     =>  simple(:clase),
        :id  =>  subtree(:clasid)) do { clase.to_s => clasid}end# bloque_actual[id.to_s]=valor end#; }end

#funca
  rule( :entero =>  simple(:y)) do { "entero" =>  y } end

  rule( :cadena =>  simple(:y))  {"cadena"}

  rule( :id     =>  simple(:d)) {d.to_s}

  rule( :id     =>  simple(:id),
        :valor  =>  subtree(:valor)) do { id.to_s => valor}end# bloque_actual[id.to_s]=valor end#; }end

  rule( :id     => simple(:i),
        :opLL   => subtree(:l),
        :entero => subtree(:le),
        ) { i.to_s + l.to_s+le.to_s }

  rule( :condicion  =>  simple(:con),) {con.to_s}
end
