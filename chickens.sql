CREATE TABLE chickens (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  breed VARCHAR(255),
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES farmers(id)
);

CREATE TABLE farmers (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  farm_id INTEGER,

  FOREIGN KEY(farm_id) REFERENCES farms(id)
);

CREATE TABLE farms (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

INSERT INTO
  chickens (id, name, breed, owner_id)
VALUES
  (1, "Mr. Fluffy Pants", "Silkie", 1),
  (2, "Princess Fluffy Butt", "Silkie", 1),
  (3, "Lindsey LoHen", "Silkie", 1),
  (4, "Tyrannosaurus Pecks", "Plymouth Rock", 2),
  (5, "Heidi Plume", "Welsummer", 2),
  (6, "Larry Bird", "Wyandotte", 3),
  (7, "Annie Yolkley", "Orpington", 2),
  (8, "Eggdar Allan Poe", "Houdan", 3),
  (9, "Hen Solo", "Jersey Giant", 2),
  (10, "Yolko Ono", "Andalusian", 1);


INSERT INTO
  farmers (id, name, farm_id)
VALUES
  (1, "Old McDonald", 1),
  (2, "The Farmer in the Dell", 2),
  (3, "Jimmy Carter", 3);

INSERT INTO
  farms (id, name)
VALUES
  (1, "The Olde McDonald Estate"),
  (2, "Dell Farms"),
  (3, "Jimmy Carter National Historic Site");
