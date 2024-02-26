-- Entfernen des Schemas für Star Schema
DROP SCHEMA IF EXISTS star_schema CASCADE;

-- Erstellung des Schemas für Star Schema
CREATE SCHEMA IF NOT EXISTS star_schema;

-- Dimensionstabellen

-- Dimensionstabelle Kunde
CREATE TABLE star_schema.dim_kunde (
  knd_id SERIAL PRIMARY KEY,
  kunde_account VARCHAR(50) NOT NULL,
  vorname VARCHAR(200),
  nachname VARCHAR(200),
  geschlecht VARCHAR(20),
  geburtsdatum DATE,
  ort VARCHAR(200),
  land VARCHAR(200)
);

-- Dimensionstabelle Fahrzeug
CREATE TABLE star_schema.dim_fahrzeug (
  fzg_id SERIAL PRIMARY KEY,
  fin CHAR(17) NOT NULL,
  hersteller_code CHAR(3),
  hersteller_name VARCHAR(200),
  modell VARCHAR(200),
  produktionsdatum DATE
);

-- Dimensionstabelle Kennzeichen
CREATE TABLE star_schema.dim_kennzeichen (
  knz_id SERIAL PRIMARY KEY,
  kfz_kennzeichen VARCHAR(20)
);

-- Faktentabelle

CREATE TABLE star_schema.faktentabelle (
  knd_id INTEGER NOT NULL,
  fzg_id INTEGER NOT NULL,
  knz_id INTEGER NOT NULL,
  kaufdatum DATE,
  lieferdatum DATE,
  kaufpreis INTEGER,
  rabatt_pct INTEGER,
  FOREIGN KEY (knd_id) REFERENCES star_schema.dim_kunde(knd_id),
  FOREIGN KEY (fzg_id) REFERENCES star_schema.dim_fahrzeug(fzg_id),
  FOREIGN KEY (knz_id) REFERENCES star_schema.dim_kennzeichen(knz_id)
);