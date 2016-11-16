require "rspec"
require 'parslet/rig/rspec'
require 'parslet'
require_relative 'parsing'

RSpec.describe MyOwn::Parser do
  let(:parser)  { MyOwn.new }

  context "tipoDato" do
    it "tipo de datos" do
      expect(parser.tipoDato).to parse("wat")
      expect(parser.tipoDato).to parse("34")
      expect(parser.tipoDato).to parse("2.1")
      expect(parser.tipoDato).to_not parse("3waripolo")
    end

  end

  context "wat" do
    it "declaracion"  do
      expect(parser.declaracion).to parse("a = 3")
    end
  end

  context "condicion f"  do
    it "partes" do
      expect(parser.condicion).to parse("43 >= 45")
    end
  end

  context "main"  do
    it "inicio" do
      expect(parser.inicio).to parse("->")
    end
    it "fin" do
      expect(parser.fin).to parse(">|")
    end

  end

  context "expresiones"  do
    it "expresion" do
      expect(parser.expresion).to parse("6.2  + 64")
    end
  end

  context "llaves" do
    it "llave" do
      expect(parser.instSi).to parse("if a > 4: then a = 3 }")
      expect(parser.instSi).to_not parse("if a > 4: then a = 3 }")
    end
  end
end

RSpec::Core::Runner.run(['--format', 'documentation'])
