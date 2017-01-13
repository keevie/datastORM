require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @name = name
    @foreign_key = options[:foreign_key] || (name + "_id").to_sym
    @class_name = options[:class_name] || name.capitalize
    @primary_key = options[:primary_key] || :id
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @name = name
    @foreign_key = options[:foreign_key] || (self_class_name.downcase + "_id").to_sym
    @class_name = options[:class_name] || name.chomp('s').capitalize
    @primary_key = options[:primary_key] || :id
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    #debugger
    define_method("#{name}") do #|options|
      bt_options = BelongsToOptions.new(options)
      fk = send(options.foreign_key)
      bt_options.model_class.where(options.primary_key => fk).first
    end
  end

  def has_many(name, options = {})
    define_method("#{name}") do |options|
    end
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end
end

class SQLObject
  extend Associatable
  # Mixin Associatable here...
end
