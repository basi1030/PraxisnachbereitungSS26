-- TODO: Inventar-Schema für Tag 3
--
-- Legt hier euer Datenmodell für die Inventar-App an.
-- Vorschlag für die Reihenfolge:
--   1. Stammdaten-Tabellen (department, person, device_type, location)
--   2. device
--   3. assignment
--
-- Ergänzt anschließend kleine Seed-Daten, damit ihr eure Flows testen könnt.

-- 001_schema.sql
-- Schema für Student / Module / Grade mit ein paar Seeddaten

create table if not exists department (
  id   serial primary key,
  department_name text not null unique
);

create table if not exists device_type (
  id   serial primary key,
  device_type_name text not null unique
);

create table if not exists location (
  id   serial primary key,
  location_name text not null unique
);

create table if not exists person (
  id    serial primary key,
  first_name text not null,
  last_name text not null,
  department_id int not null references department(id) on delete cascade,
  location_id int not null references location(id) on delete cascade
);

create table if not exists device (
  id serial primary key,
  serial_number text not null unique,
  device_type_id int not null references device_type(id) on delete cascade,
  location_id int references location(id) on delete cascade,
  model text,
  buy_date timestamp,
  purchase_price float
);

create table if not exists assignment (
  id   serial primary key,
  person_id int not null references person(id) on delete cascade,
  device_id int not null references device(id) on delete cascade,
  issued_at timestamp,
  returned_at timestamp
);

insert into device_type (device_type_name) values
    ('Laptop'),
    ('Smartphone'),
    ('Tablet')
on conflict do nothing;

insert into location (location_name) values
    ('Gebäude E'),
    ('Gebäude F'),
    ('Gebäude H')
on conflict do nothing;

insert into department (department_name) values
    ('IWI'),
    ('AB'),
    ('MME')
ON conflict do nothing;

insert into device (serial_number, device_type_id, location_id, model, buy_date, purchase_price) values
    ('G001', 1, 1, 'ThinkPad', '01-01-2001', 100.00),
    ('G002', 2, 2, 'Samsung', '01-01-2002', 200.00),
    ('G003', 3, 3, 'IPhone', '01-01-2003', 300.00),
    ('G004', 1, 1, 'MacBook', '01-01-2004', 400.00),
    ('G005', 2, 2, 'IPad', '01-01-2005', 500.00)
on conflict do nothing;

insert into person (first_name, last_name, department_id, location_id) values
    ('Max', 'Muster', 1, 1),
    ('Sabine', 'Muster', 2, 2),
    ('Sarah', 'Muster', 3, 3),
    ('Michael', 'Muster', 1, 1),
    ('Anton', 'Muster', 1, 1)
on conflict do nothing;

insert into assignment (person_id, device_id, issued_at, returned_at) values
    (1, 1, '02-01-2001', null),
    (2, 2, null, null),
    (3, 3, '02-01-2003', '03-01-2003'),
    (4, 4, null, null),
    (5, 5, null, null)
on conflict do nothing;