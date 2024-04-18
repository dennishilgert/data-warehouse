import psycopg2
import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt
from dotenv import load_dotenv
import os
from datetime import datetime

# Load environment variables from a .env file
load_dotenv()

# Retrieve database connection details from environment variables
host = os.getenv("DB_HOST")
port = os.getenv("DB_PORT")
dbname = os.getenv("DB_NAME")
user = os.getenv("DB_USER")
password = os.getenv("DB_PASSWORD")

# Establish a database connection using credentials from .env file
conn = psycopg2.connect(
    host=host,
    port=port,
    dbname=dbname,
    user=user,
    password=password
)

# Current year for age calculation
current_year = datetime.now().year

# SQL command performing two JOINs to connect fact_kauf, dim_fahrzeug, and dim_kunde tables
sql_query = f"""
SELECT 
    fz.hersteller_name, 
    FLOOR((DATE_PART('year', CURRENT_DATE) - DATE_PART('year', k.geburtsdatum)) / 10) * 10 as age_group,
    COUNT(kf.kauf_kalender_datum) as verkaufte_einheiten
FROM 
    mart.fact_kauf kf
JOIN 
    mart.dim_fahrzeug fz 
    ON kf.dim_fahrzeug_id = fz.dim_fahrzeug_id
JOIN 
    mart.dim_kunde k
    ON kf.dim_kunde_id = k.dim_kunde_id
GROUP BY 
    fz.hersteller_name, 
    age_group
ORDER BY 
    fz.hersteller_name, 
    age_group;
"""

# Execute the SQL command and load the data into a Pandas DataFrame
df = pd.read_sql_query(sql_query, conn)

# Close the database connection
conn.close()

# Transform the data for the heatmap (pivot table)
pivot_table = df.pivot(index='hersteller_name', columns='age_group', values='verkaufte_einheiten').fillna(0)

# Create a heatmap
plt.figure(figsize=(12, 8))
ax = sns.heatmap(pivot_table, annot=True, fmt=".0f", cmap="YlGnBu")

# Set the title and axis labels
plt.title('Verkaufte Fahrzeuge pro Hersteller und Kunden-Altersgruppe')
plt.xlabel('Altersgruppe der Kunden')
plt.ylabel('Herstellername')

# Save the heatmap as a PNG file
plt.tight_layout()  # Ensure a better fit for the axis labels
plt.savefig('./5-240418/heatmap-manufacturer-age-group.png')

# Inform the user about the file save location
print("The heatmap has been saved as 'heatmap-manufacturer-age-group.png' in the directory './5-240418/'.")
