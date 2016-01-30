require 'rspec/expectations'
require 'ast_helper'

RSpec::Matchers.define :match_ast do |expected|
  match { |actual| expected == actual.send(:ast) }
  failure_message { |actual| AstHelper.pretty_diff(expected, actual) }
end
