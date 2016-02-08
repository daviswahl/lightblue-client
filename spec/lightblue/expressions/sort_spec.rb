require 'spec_helper'
require 'ast_helper'
include AstHelper

describe Lightblue::Expressions::Sort do
  let(:foo) { Lightblue::Expressions::Field.new(:foo) }
  let(:bar) { Lightblue::Expressions::Field.new(:bar) }

  context 'initialization' do
   let(:foo_sort) do
      exp = new_node(:sort_expression, [new_node(:field, [:foo]),
                                        new_node(:sort_direction, [:$desc])])
    end

    let(:bar_sort) do
      exp = new_node(:sort_expression, [new_node(:field, [:bar]),
                                        new_node(:sort_direction, [:$asc])])
    end
    let(:sort_array) do
      exp = new_node(:sort_expression_array, [foo_sort, bar_sort])
    end

    context 'with a field and direction' do
      it 'returns a sort expression' do
        actual = Lightblue::Expressions::Sort.new(foo, :desc)
        expect(actual).to match_ast(foo_sort)
      end
    end

    context 'with a key and direction' do
      it 'returns a sort expression' do
        actual = Lightblue::Expressions::Sort.new(:foo, :desc)
        expect(actual).to match_ast(foo_sort)
      end
    end

    context 'an array of a keys and directions' do
      it 'returns a sort expression' do
        actual = Lightblue::Expressions::Sort.new([[:foo, :desc], [:bar, :asc]])
        expect(actual).to match_ast(sort_array)
      end
    end

    context 'an array of a fields and directions' do
      it 'returns a sort expression' do
        actual = Lightblue::Expressions::Sort.new([[foo, :desc],
                                                   [bar, :asc]])
        expect(actual).to match_ast(sort_array)
      end
    end
  end

  describe 'to_hash' do
    context 'a single sort expression' do
      it 'generates a hash' do
        actual = Lightblue::Expressions::Sort.new(foo, :desc).to_hash
        expect(actual).to eq({ foo: :$desc })
      end
    end
    context 'an array of sort expressions' do
      it 'generates a hash' do
        actual = Lightblue::Expressions::Sort.new([[foo, :desc],
                                                   [bar, :asc]]).to_hash
        expect(actual).to eq([{ foo: :$desc }, { bar: :$asc }])
      end
    end
  end
end
