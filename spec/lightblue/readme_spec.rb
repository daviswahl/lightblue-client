require 'spec_helper'
describe 'read me spec' do
  describe 'the examples' do
    it 'should work' do

      foo = Lightblue.entity(:foo, '1.0.0')
      find_query = foo.find
                   .query(foo[:bar].eq(foo[:batz]))
                   .project(Lightblue.star)
      expect(find_query.to_query).to eq({
        entity: :foo,
        entityVersion: "1.0.0",
        query: {
          field: :bar,
          op: :$eq,
          rfield: :batz
        },
        projection: {
          field: :*,
          include: true,
          recursive: true
        }
      })
    end
  end
end
