-- Load data into dimension tables

-- Load fahrzeug data from staging-schema to dim_fahrzeug in mart-schema
INSERT INTO mart.dim_fahrzeug (fin, hersteller_code, hersteller_name, modell, produktionsdatum)
SELECT 
    f.fin, 
    f.hersteller_code, 
    h.hersteller_name, 
    f.modell, 
    f.produktionsdatum
FROM staging.fahrzeug f
JOIN staging.hersteller h ON f.hersteller_code = h.hersteller_code;

-- Load kunde data from staging-schema to dim_kunde in mart-schema
INSERT INTO mart.dim_kunde (kunde_account, vorname, nachname, geschlecht, geburtsdatum, wohnort, land)
SELECT 
    k.kunde_account, 
    k.vorname, 
    k.nachname, 
    k.geschlecht, 
    k.geburtsdatum, 
    o.ort, 
    l.land
FROM staging.kunde k
JOIN staging.ort o ON k.wohnort_id = o.ort_id
JOIN staging.land l ON o.land_id = l.land_id;

-- Load fzg_kauf data from staging-schema to dim_kfz in mart-schema
INSERT INTO mart.dim_kfz (kfz_kennzeichen)
SELECT DISTINCT
    fzg_kfz.kfz_kennzeichen
FROM staging.fzg_kauf fzg_kfz;

-- Load data into fact table

-- Load fzg_kauf data from staging-schema to fact_kauf in mart-schema
INSERT INTO mart.fact_kauf (dim_fahrzeug_id, dim_kunde_id, dim_kfz_id, kauf_kalender_datum, liefer_kalender_datum, kaufpreis, rabatt_pct)
SELECT 
    df.dim_fahrzeug_id, 
    dk.dim_kunde_id, 
    dkfz.dim_kfz_id, 
    fk.kaufdatum, 
    fk.lieferdatum, 
    fk.kaufpreis, 
    fk.rabatt_pct
FROM staging.fzg_kauf fk
JOIN mart.dim_fahrzeug df ON fk.fin = df.fin
JOIN mart.dim_kunde dk ON fk.kunde_account = dk.kunde_account
JOIN mart.dim_kfz dkfz ON fk.kfz_kennzeichen = dkfz.kfz_kennzeichen;
