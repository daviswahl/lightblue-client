require 'spec_helper'
describe 'Data Operations' do
  describe 'find' do
    context 'query' do
      it 'sets the query attribute' do
        find = Lightblue.find
        query = Lightblue.field(:foo).eq(10)
        find.query(query)
        expect(find.query).to eq(Lightblue::Expressions::Query.new(query))
      end
    end

    context 'project' do
      it 'sets the project attribute' do
        find = Lightblue.find
        projection = Lightblue.field(:*)
        find.project(projection)
        expect(find.project).to eq(Lightblue::Expressions::Projection.new(projection))
      end
    end

    context 'sort' do
      it 'sets the project attribute' do
        find = Lightblue.find
        sort = Lightblue.field(:foo)
        find.sort(sort)
        expect(find.sort).to eq(Lightblue::Expressions::Sort.new(sort))
      end
    end

    context 'range' do
      it 'sets the project attribute' do
        find = Lightblue.find
        range = Lightblue.range(1..100)
        find.range(range)
        expect(find.range).to eq(Lightblue::Expressions::Range.new(1..100))
      end
    end

    context 'to_query' do
      it 'generates a query' do
        find = Lightblue.find
        find.entity(:batz, '1.0.0')
        find.range(1..100, :max)
        find.query(Lightblue.field(:bar).eq(1))
        find.sort(Lightblue.field(:foo).asc)
        find.project(Lightblue.field(:*))

        expected = { :entity=>:batz,
                     :entityVersion=>"1.0.0",
                     :query=>{:field=>:bar, :op=>:$eq, :rvalue=>1},
                     :projection=>{:field=>:*},
                     :range=>{:from => 1, :maxResults => 100},
                     :sort=>{ foo: :$asc }
                   }
        expect(find.to_query).to eq(expected)
      end
    end
  end
end
