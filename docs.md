# API Reference for datastORM 

## SQLObject::methods

### all

Returns a list of all objects in the database

### find(id)

Returns a single object with id matching input.

### save

Saves an object to the database, updating if it already exists or creating it if it doesn't. Returns the object.

### where(attribute: value, attribute2: value2)

Returns a single object with attribututes that match the input hash.


