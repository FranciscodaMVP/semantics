require 'rspec'
require 'parslet/rig/rspec'
require 'parslet'

class ComplexParser < Parslet::Parser
  rule(:simple_rule) { str('a') }
end

describe ComplexParser  do
  let(:parser) { ComplexParser.new }
  context "simple_rule" do
    it "should consume 'a'" do
      expect(parser.simple_rule).to parse('a')
    end
  end
end

RSpec::Core::Runner.run(['--format', 'documentation'])
