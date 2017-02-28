require_relative 'db_connection'
require_relative '01_sql_object'
require 'byebug'
module Searchable
  def where(params)

    where_arr = []
    params.each do |attr_name, attr_value|
      where_arr << "#{attr_name} = '#{attr_value}'"
    end
    where_str = where_arr.join(' AND ')

    data = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
       #{where_str}
    SQL

  self.parse_all(data)
  
  end
end

class SQLObject
  # Mixin Searchable here...
  extend Searchable



end
