require_relative 'db_connection';
require_relative 'sql_object';
require_relative 'associatable';

DBConnection.reset

class Chicken < SQLObject
end

class Farmer < SQLObject
end

class Farm < SQLObject
end

Chicken.finalize!
Farmer.finalize!
Farm.finalize!

Chicken.belongs_to :owner,
  class_name: 'Farmer',
  foreign_key: :owner_id,
  primary_key: :id

Farmer.has_many :chickens
