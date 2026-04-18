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
  department text not null references department(department_name) on delete cascade,
  location text not null references location(location_name) on delete cascade
);

create table if not exists device (
  id   serial primary key,
  serial_number text not null unique,
  device_type text not null references device_type(device_type_name) on delete cascade,
  model text not null,
  buy_date timestamp not null,
  purchase_price float not null,
  location text references location(location_name) on delete cascade
);

create table if not exists assignment (
  id   serial primary key,
  person_id int not null references person(id) on delete cascade,
  device_id int not null references device(id) on delete cascade
);

insert into device_type (id, device_type_name) values
    (1, 'Laptop'),
    (2, 'Smartphone'),
    (3, 'Tablet')
on conflict do nothing;

insert into location (id, location_name) values
    (1, 'Gebäude E'),
    (2, 'Gebäude F'),
    (3, 'Gebäude H')
on conflict do nothing;

insert into department (id, department_name) values
    (1, 'IWI'),
    (2, 'AB'),
    (3, 'MME')
ON conflict do nothing;

insert into device (id, serial_number, device_type, model, buy_date, purchase_price, location) values
    (1, 'G001', 'Laptop', 'ThinkPad', '01.01.2001', 100.00, 'Gebäude E'),
    (2, 'G002', 'Tablet', 'Samsung', '01.01.2002', 200.00, 'Gebäude F'),
    (3, 'G003', 'Smartphone', 'IPhone', '01.01.2003', 300.00, 'Gebäude H'),
    (4, 'G004', 'Laptop', 'MacBook', '01.01.2004', 400.00, 'Gebäude E'),
    (5, 'G005', 'Tablet', 'IPad', '01.01.2005', 500.00, 'Gebäude F')
on conflict do nothing;

insert into person (id, first_name, last_name, department, location) values
    (1, 'Max', 'Muster', 'IWI', 'Gebäude E'),
    (2, 'Sabine', 'Muster', 'AB', 'Gebäude F'),
    (3, 'Sarah', 'Muster', 'MME', 'Gebäude H'),
    (4, 'Michael', 'Muster', 'IWI', 'Gebäude E'),
    (5, 'Anton', 'Muster', 'IWI', 'Gebäude E')
on conflict do nothing;

insert into assignment (id, person_id, device_id) values
    (1, 1, 1),
    (2, 2, 2),
    (3, 3, 3),
    (4, 4, 4),
    (5, 5, 5)
on conflict do nothing;