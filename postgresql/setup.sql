CREATE TABLE employee(
  id serial primary key ,
  name varchar(150),
  email varchar(50) not null unique ,
  salary bigint,
  city varchar(150)
);