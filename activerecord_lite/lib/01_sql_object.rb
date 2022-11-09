require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    if instance_variable_get(:@columns).nil?
      result = DBConnection.execute2(<<-SQL)
        SELECT
          *
        FROM
          #{self.table_name}
      SQL
      columns = result[0].map(&:to_sym)
      instance_variable_set(:@columns, columns)
    else
      instance_variable_get(:@columns)
    end
  end

  def self.finalize!
    cols = self.columns

    cols.each do |col|
      # setter
      define_method("#{col}=") do |new_value|
        self.attributes[:"#{col}"] = new_value

        # should not access the data through instance variable?
        # instance_variable_set(:"@#{col}", new_value)
      end

      # getter
      define_method("#{col}") do |*args|

        # should default all getter and setter to attribute hash
        # instead of instance variable as we used to.
        # instance_variable_get(:"@#{col}")
        return self.attributes[:"#{col}"]
      end
    end
  end

  def self.table_name=(table_name)
    instance_variable_set(:@table_name, table_name)
  end

  def self.table_name
    tn = instance_variable_get(:@table_name)
    if tn
      return tn
    else
      instance_variable_set(:@table_name, self.name.tableize)
    end
  end

  def self.all
    # ...
  end

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    # ...
  end

  def attributes
    if instance_variable_get(:@attributes)
      return instance_variable_get(:@attributes)
    else
      instance_variable_set(:@attributes, {})
      instance_variable_get(:@attributes)
    end
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end


class Cat < SQLObject
  self.finalize!
end

c = Cat.new
c.name = "Nick Diaz"

p c.instance_variables.include?(:@attributes)
p c.instance_variables.include?(:@name)

p c.attributes[:name]
