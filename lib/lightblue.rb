require 'lightblue/ast'
require 'lightblue/client'
require 'lightblue/entity'
require 'lightblue/request'
require 'lightblue/expression'
require 'lightblue/version'

require 'lightblue/data_operations/all'

module Lightblue
  def self.field(name)
    Expressions::Field.new(name)
  end

  def self.find
    DataOperations::Find.new
  end

  def self.update
    DataOperations::Update.new
  end

  def self.insert
    DataOperations::Insert.new
  end

  def self.delete
    DataOperations::Delete.new
  end

  def self.save
    DataOperations::Save.new
  end

  def self.range(range, type = :to)
    Expressions::Range.new(range, type)
  end

  def self.entity(name, version = nil)
    Entity.new(name, version)
  end

  def self.star
    Expressions::Projection.new(field(:*).include.recursive)
  end
end
