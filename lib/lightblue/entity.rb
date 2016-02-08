require 'lightblue/data_operations/all'
module Lightblue
  class Entity
    attr_reader :name, :version

    def initialize(name, version = nil)
      @name = name
      @version = version
    end

    def [](arg)
      Lightblue::Expressions::Field.new(arg)
    end

    def find
      Lightblue::DataOperations::Find.new.entity(self)
    end

    def update
      Lightblue::DataOperations::Update.new
    end

    def insert
      Lightblue::DataOperations::Insert.new
    end

    def delete
      Lightblue::DataOperations::Delete.new
    end

    def save
      Lightblue::DataOperations::Save.new
    end
  end
end
