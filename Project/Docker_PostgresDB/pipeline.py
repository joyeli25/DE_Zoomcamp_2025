docker build -t chi_crime_ingest:v001 .

url='https://github.com/user-attachments/files/22035796/Crimes_-_2025_20250828.csv.gz'

docker run -it \
  --network=de_project_2025_default \
  chi_crime_ingest:v001 \
    --user=root \
    --password=root \
    --host=pgdatabase \
    --port=5432 \
    --db=chi_crime \
    --table_name=chi_crime_2025 \
    --url=${url}

url='https://github.com/user-attachments/files/22035794/Crimes_-_2024_20250828.csv.gz'

docker run -it \
  --network=de_project_2025_default \
  chi_crime_ingest:v001 \
    --user=root \
    --password=root \
    --host=pgdatabase \
    --port=5432 \
    --db=chi_crime \
    --table_name=chi_crime_2024 \
    --url=${url}
    
    
url='https://github.com/user-attachments/files/22035793/Crimes_-_2023_20250828.csv.gz'

docker run -it \
  --network=de_project_2025_default \
  chi_crime_ingest:v001 \
    --user=root \
    --password=root \
    --host=pgdatabase \
    --port=5432 \
    --db=chi_crime \
    --table_name=chi_crime_2023 \
    --url=${url}

url='https://github.com/user-attachments/files/22035409/Crimes_-_2022_20250828.csv.gz'

docker run -it \
  --network=de_project_2025_default \
  chi_crime_ingest:v001 \
    --user=root \
    --password=root \
    --host=pgdatabase \
    --port=5432 \
    --db=chi_crime \
    --table_name=chi_crime_2022 \
    --url=${url}
    
url='https://github.com/user-attachments/files/22035790/Crimes_-_2021_20250828.csv.gz'

docker run -it \
  --network=de_project_2025_default \
  chi_crime_ingest:v001 \
    --user=root \
    --password=root \
    --host=pgdatabase \
    --port=5432 \
    --db=chi_crime \
    --table_name=chi_crime_2021 \
    --url=${url}

----------update the ingest_data.py for csv file loading-------------
docker build -t chi_crime_ingest:v002 .

url='https://github.com/user-attachments/files/22036169/Chicago_Police_Department_-_Illinois_Uniform_Crime_Reporting_.IUCR._Codes_20250828.csv'

docker run -it \
  --network=de_project_2025_default \
  chi_crime_ingest:v002 \
    --user=root \
    --password=root \
    --host=pgdatabase \
    --port=5432 \
    --db=chi_crime \
    --table_name=IUCR_codes_lookup_2 \
    --url=${url}
