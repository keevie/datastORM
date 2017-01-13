require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.columns

    @columns ||= DBConnection.execute2("SELECT * FROM #{table_name}")
      .first.map(&:to_sym)
  end

  def self.finalize!
    columns.each do |name|

      define_method("#{name}") do
        attributes[name]
      end

      define_method("#{name}=") do |arg|
        attributes[name] = arg
      end

    end
  end

  def self.all
    data = DBConnection.execute("SELECT * FROM #{table_name}")


    parse_all(data)
  end

  def self.parse_all(results)
    objects = []
    results.each do |result|
      objects << self.new(result)
    end
    objects
  end

  def self.find(id)
    result = DBConnection.execute("SELECT * FROM #{table_name} WHERE id = #{id}")
    return nil if result.empty?
    self.new(result.first)
  end

  def initialize(params = {})
    params.each do |attr_name, val|
      attr_name = attr_name.to_sym
      raise "unknown attribute '#{attr_name}'" unless self.class.columns.include?(attr_name)

      self.send("#{attr_name}=", val)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    values = []
    attributes.each do |k, v|
      values << v
    end

    values
  end

  def insert
    columns_str = self.class.columns.drop(1).join(',')
    question_marks = ['?'] * (self.class.columns.count - 1)
    question_marks = question_marks.join(',')

    DBConnection.execute(<<-SQL, attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{columns_str})
      VALUES
        (#{question_marks})
    SQL

    new_id = DBConnection.last_insert_row_id
    attributes[:id] = new_id
    self.class.new(attributes)
  end

  def update

    columns_str = self.class.columns.join(" = ?,")
    columns_str << " = ?"
    item_id = attributes[:id]

    DBConnection.execute(<<-SQL, attribute_values)
      UPDATE
        #{self.class.table_name}
      SET
        #{columns_str}
      WHERE
        id = #{item_id}
    SQL
  end

  def save
    if attributes[:id].nil?
      insert
    else
      update
    end
  end
end
