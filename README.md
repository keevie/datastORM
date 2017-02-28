# datastORM - Create Ruby objects from database rows

DatastORM connects Ruby classes to rows in a relational database table<sup>[1](#dbsupport)</sup>, allowing your apps to access and save persistent data with minimal configuration.

The library provides a base class, SQLObject, which defines a relationship between the class and a table in the database. SQLObject can then be extended in order to provide access to the database for any class of your choosing: these classes are commonly referred to as models, and are the first part of the MVC (Model, View, Controller) pattern. Models in datastORM can be connected to other models using associations.

In order to define a model, simply define a class that inherits from SQLObject:

```ruby
class Chicken < SQLObject
end
```

This Chicken class might corrospond to a chickens table in the database, like so:

```SQL
CREATE TABLE chickens (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  breed VARCHAR(255),
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES farmers(id)
);
```

Methods are created for accessing each database row for the new objects: instances of `Chicken` will now have access to the following methods: `id`, `name`, `breed`, and `owner_id`, as well as the corrosponding setter methods.

Using the activesupport library from Rails, datastORM supports automatic table name detection: in the above example, datastORM knows without specifying that the `Chicken` class will corrospond to a `chickens` table.


## Associations

DatastORM supports three types of associations: `belongs_to`, `has_many`, and `has_one_through.`

### Example associations

```ruby
class Chicken
  belongs_to :owner,
    class_name: 'Farmer',
    foreign_key: :owner_id,
    primary_key: :id

  has_one_through :farm,
    :owner,
    :farm
end

class Farmer
  belongs_to :farm,
    class_name: 'Farm',
    foreign_key: :owner_id,
    primary_key: :id

  has_many :chickens,
    class_name: 'Chicken',
    foreign_key: :owner_id,
    primary_key: :id
end
```

The above code will make the following snippets possible:

```ruby
  #chicken belongs to owner
  Chicken.all.first.owner #=> Farmer, id: 1, name: "Old McDonald", farm_id: 1

  #chicken has one farm through owner
  Chicken.all.first.farm #=> Farm, id: 1, name: "The Olde McDonald Estate"
```




<a name='dbsupport'>1</a>: Currently supports sqlite3, postgreSQL support coming.
