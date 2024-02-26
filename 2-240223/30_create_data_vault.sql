-- Entfernen des Schemas für Data Vault
DROP SCHEMA IF EXISTS data_vault CASCADE;

-- Erstellung des Schemas für Data Vault
CREATE SCHEMA IF NOT EXISTS data_vault;

-- Hubs

-- Hub für Fahrzeuge
CREATE TABLE data_vault.hub_fahrzeug (
    hub_id SERIAL PRIMARY KEY,
    fin CHAR(17) NOT NULL UNIQUE,
    record_source VARCHAR(50),
    load_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Hub für Kunden
CREATE TABLE data_vault.hub_kunde (
    hub_id SERIAL PRIMARY KEY,
    kunde_account VARCHAR(50) NOT NULL UNIQUE,
    record_source VARCHAR(50),
    load_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Satelliten

-- Satellit für Fahrzeuge (angepasst, um alle relevanten Felder einzuschließen)
CREATE TABLE data_vault.sat_fahrzeug (
    hub_id INTEGER NOT NULL,
    hersteller_code CHAR(3),
    modell VARCHAR(200),
    produktionsdatum DATE,
    quelle VARCHAR(50),
    load_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (hub_id, load_date),
    FOREIGN KEY (hub_id) REFERENCES data_vault.hub_fahrzeug(hub_id)
);

-- Satellit für Hersteller
CREATE TABLE data_vault.sat_hersteller (
    hub_id INTEGER NOT NULL,
    hersteller_code CHAR(3) NOT NULL,
    hersteller_name VARCHAR(200),
    quelle VARCHAR(20),
    load_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (hub_id, load_date),
    FOREIGN KEY (hub_id) REFERENCES data_vault.hub_fahrzeug(hub_id)
);

-- Satellit für Land
CREATE TABLE data_vault.sat_land (
    hub_id INTEGER NOT NULL,
    land_id INTEGER NOT NULL,
    land VARCHAR(200),
    quelle VARCHAR(20),
    load_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (hub_id, load_date),
    FOREIGN KEY (hub_id) REFERENCES data_vault.hub_kunde(hub_id)
);

-- Satellit für Ort
CREATE TABLE data_vault.sat_ort (
    hub_id INTEGER NOT NULL,
    ort_id INTEGER NOT NULL,
    ort VARCHAR(200),
    land_id INTEGER,
    quelle VARCHAR(20),
    load_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (hub_id, load_date),
    FOREIGN KEY (hub_id) REFERENCES data_vault.hub_kunde(hub_id)
);

-- Satellit für Kunden (angepasst, um alle relevanten Felder einzuschließen)
CREATE TABLE data_vault.sat_kunde (
    hub_id INTEGER NOT NULL,
    vorname VARCHAR(200),
    nachname VARCHAR(200),
    geschlecht VARCHAR(20),
    geburtsdatum DATE,
    wohnort_id INTEGER,
    quelle VARCHAR(50),
    load_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (hub_id, load_date),
    FOREIGN KEY (hub_id) REFERENCES data_vault.hub_kunde(hub_id)
);

-- Link zwischen Fahrzeug und Kunde (angepasst für Käufe)
CREATE TABLE data_vault.link_fahrzeug_kunde (
    link_id SERIAL PRIMARY KEY,
    hub_fahrzeug_id INTEGER NOT NULL,
    hub_kunde_id INTEGER NOT NULL,
    load_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(50),
    FOREIGN KEY (hub_fahrzeug_id) REFERENCES data_vault.hub_fahrzeug(hub_id),
    FOREIGN KEY (hub_kunde_id) REFERENCES data_vault.hub_kunde(hub_id)
);

-- Satellit für Fahrzeugkauf
CREATE TABLE data_vault.sat_fzg_kauf (
    link_id INTEGER NOT NULL,
    kfz_kennzeichen VARCHAR(20),
    kaufdatum DATE,
    lieferdatum DATE,
    kaufpreis INTEGER,
    rabatt_pct INTEGER,
    quelle VARCHAR(50),
    load_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (link_id, load_date),
    FOREIGN KEY (link_id) REFERENCES data_vault.link_fahrzeug_kunde(link_id)
);
