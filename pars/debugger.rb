require "rspec"
require 'parslet/rig/rspec'
require 'parslet'
require_relative 'parsing'

RSpec.describe MyOwn::Parser do
  let(:parser)  { MyOwn::Parser.new }
  context "value parsing" do
    let(:value_parser)  { parser.value  }

    it "tipo de datos" do
      expect(value_parser).to parse("wat")
      expect(value_parser).to parse("waripolo")
    end

  end

end

RSpec::Core::Runner.run(['--format', 'documentation'])
