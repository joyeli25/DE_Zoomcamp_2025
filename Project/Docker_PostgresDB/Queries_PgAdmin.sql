------Create Materialized View in PgAdmin---------------------------
```sql
CREATE MATERIALIZED VIEW chi_crime_all AS
SELECT * FROM chi_crime_2021
UNION ALL
SELECT * FROM chi_crime_2022
UNION ALL
SELECT * FROM chi_crime_2023
UNION ALL
SELECT * FROM chi_crime_2024
UNION ALL
SELECT * FROM chi_crime_2025;
```
--------Create indexes for better performance------------
CREATE INDEX idx_crime_date ON chi_crime_all("Date");
CREATE INDEX idx_crime_type ON chi_crime_all("Primary Type");
CREATE INDEX idx_crime_location ON chi_crime_all("Location Description");
CREATE INDEX idx_crime_geo ON chi_crime_all("Latitude", "Longitude");


-----------------Analysis Matrics--------------------
--1. Temporal Analysis Matrix
--1--- Crime trends over time
SELECT 
    EXTRACT(YEAR FROM "Date") as year,
    EXTRACT(MONTH FROM "Date") as month,
    "Primary Type",
    COUNT(*) as incident_count,
    AVG(CASE WHEN "Arrest" THEN 1 ELSE 0 END) * 100 as arrest_rate_percent
FROM chi_crime_all
GROUP BY year, month, "Primary Type"
ORDER BY year, month, incident_count DESC;

--2. Geographic Hotspot Matrix
--2--- Spatial crime distribution
SELECT 
    "District",
    "Ward", 
    "Community Area",
    "Primary Type",
    COUNT(*) as incident_count,
    COUNT(DISTINCT "Block") as affected_blocks,
    AVG("Latitude") as avg_lat,
    AVG("Longitude") as avg_lng
FROM chi_crime_all
WHERE "Latitude" IS NOT NULL AND "Longitude" IS NOT NULL
GROUP BY "District",
    "Ward", 
    "Community Area",
    "Primary Type"
ORDER BY incident_count DESC;

------------District, Ward, Community Area-----------------------------------
📍 1. Police District

Purpose: Law enforcement.

Chicago is divided into 22 police districts, each with its own police station.

Example: District 1 = Central (Downtown Loop), District 25 = Grand Central.

Crimes are recorded with the district that responded to or has jurisdiction over that location.

🏛️ 2. Ward

Purpose: Political boundaries for City Council representation.

Chicago has 50 wards, each represented by an alderman.

Wards are used for legislation, zoning, and political purposes, not policing.

🏘️ 3. Community Area

Purpose: Research & urban planning.

Chicago has 77 community areas, which are fixed statistical boundaries (unlike wards, which change with redistricting).

Designed in the 1920s by the University of Chicago for consistent sociological and demographic studies.

Example: Hyde Park = Community Area 41, Englewood = Community Area 68.

🔑 Relationship Between Them

They often overlap, but they are independent boundary systems:

A single community area may span multiple wards or districts.

A police district might include parts of several community areas.

Wards are political and change with redistricting, but community areas never change (making them good for long-term trend analysis).
--------------------------------------------------------------------------------

--3. Crime Type Analysis Matrix
--3--- Crime type effectiveness matrix
SELECT 
    "Primary Type",
    "Description",
    COUNT(*) as total_incidents,
    SUM(CASE WHEN "Arrest" THEN 1 ELSE 0 END) as arrests_made,
    SUM(CASE WHEN "Domestic" THEN 1 ELSE 0 END) as domestic_incidents,
    ROUND(SUM(CASE WHEN "Arrest" THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as arrest_rate_percent,
    ROUND(SUM(CASE WHEN "Domestic" THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as domestic_rate_percent
FROM chi_crime_all
GROUP BY "Primary Type",
    "Description"
ORDER BY total_incidents DESC;

--4. Time-Based Pattern Matrix
--4--- Hourly and daily patterns
SELECT 
    "Primary Type",
    EXTRACT(HOUR FROM "Date") as crime_hour,
    EXTRACT(DOW FROM "Date") as day_of_week,
    COUNT(*) as incident_count,
    ROUND(AVG(CASE WHEN "Arrest" THEN 1 ELSE 0 END) * 100,2) as arrest_rate
FROM chi_crime_all
GROUP BY "Primary Type", crime_hour, day_of_week
ORDER BY "Primary Type", incident_count DESC;

--5. Location Risk Assessment Matrix
--5--- Location-based risk analysis
SELECT 
    "Location Description",
    "Primary Type",
    COUNT(*) as total_incidents,
    COUNT(DISTINCT "Block") as unique_locations,
    ROUND(AVG(CASE WHEN "Arrest" THEN 1 ELSE 0 END) * 100,2) as arrest_rate,
    ROUND(AVG(CASE WHEN "Domestic" THEN 1 ELSE 0 END) * 100,2) as domestic_rate
FROM chi_crime_all
GROUP BY "Location Description",
    "Primary Type"
HAVING COUNT(*) > 100  -- Only significant locations
ORDER BY total_incidents DESC;

--6. FBI Code Severity Matrix
--6--- Crime severity analysis by FBI codes and IUCR Codes
SELECT 
    "FBI Code", 
   cca. "Primary Type",
   cca."IUCR", icl."PRIMARY DESCRIPTION", icl."SECONDARY DESCRIPTION",
    COUNT(*) as incident_count,
    ROUND(AVG(CASE WHEN "Arrest" THEN 1 ELSE 0 END) * 100,2) as arrest_rate,
    MIN("Date") as first_occurrence,
    MAX("Date") as last_occurrence
FROM chi_crime_all cca
inner join iucr_codes_lookup icl on cca."IUCR"=icl."IUCR"
GROUP BY "FBI Code", 
   cca. "Primary Type",
   cca."IUCR", icl."PRIMARY DESCRIPTION", icl."SECONDARY DESCRIPTION"
ORDER BY incident_count DESC;

--------------------------------------------------------------------------------
📌 What is a Beat?

The smallest police geographic area in Chicago.

Each beat is assigned officers who regularly patrol and know the neighborhood.

Beats roll up into sectors → districts → areas (hierarchy of CPD).

🏙️ Hierarchy Example (Chicago PD structure)

Beat → Smallest unit (few blocks to a neighborhood).

Sector → Group of 3–5 beats.

District → Group of sectors (Chicago has 22 police districts).

Area → Larger police area covering multiple districts.

📊 Why it’s in the data

Every crime is reported at the beat level to track local crime trends.

Used for resource deployment (e.g., more patrols in high-crime beats).

Lets you do fine-grained analysis:

Crime hotspots

Correlation with socioeconomic factors

Comparison across beats, districts, wards, or community areas
--------------------------------------------------------------------------------

--7. Beat and District Performance Matrix
--7--- Law enforcement effectiveness by area
SELECT 
    "District",
    "Beat",
    COUNT(*) as total_incidents,
    SUM(CASE WHEN "Arrest" THEN 1 ELSE 0 END) as arrests_made,
    COUNT(DISTINCT "Primary Type") as crime_variety,
    ROUND(SUM(CASE WHEN "Arrest" THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as clearance_rate
FROM chi_crime_all
GROUP BY  "District",
    "Beat"
ORDER BY clearance_rate DESC, total_incidents DESC;

--8. Community Area Vulnerability Matrix
--8--- Community area risk profiling
SELECT 
    "Community Area",
    COUNT(*) as total_crimes,
    COUNT(DISTINCT "Primary Type") as crime_types,
    ROUND(SUM(CASE WHEN "Domestic" THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as domestic_violence_rate,
    ROUND(SUM(CASE WHEN "Arrest"  THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as law_enforcement_presence
FROM chi_crime_all
WHERE "Community Area" IS NOT NULL
GROUP BY "Community Area"
ORDER BY total_crimes DESC;

--9. Seasonal Trend Analysis Matrix
--9--- Seasonal crime patterns
SELECT 
    "Primary Type",
    EXTRACT(QUARTER FROM "Date") as quarter,
    EXTRACT(MONTH FROM "Date") as month,
    COUNT(*) as incident_count,
    ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY "Primary Type")), 2) as seasonal_percentage
FROM chi_crime_all
GROUP BY "Primary Type", quarter, month
ORDER BY "Primary Type", quarter, incident_count DESC;

--10. Comprehensive Dashboard Query
--10--- Executive summary dashboard
SELECT 
    EXTRACT(YEAR FROM "Date") as year,
    COUNT(*) as total_incidents,
    COUNT(DISTINCT "Primary Type") as unique_crime_types,
    SUM(CASE WHEN "Arrest" THEN 1 ELSE 0 END) as total_arrests,
    SUM(CASE WHEN "Domestic" THEN 1 ELSE 0 END) as domestic_incidents,
    ROUND(SUM(CASE WHEN "Arrest" THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as overall_clearance_rate,
    COUNT(DISTINCT "Community Area") as affected_communities,
    COUNT(DISTINCT "Beat") as active_beats
FROM chi_crime_all
GROUP BY year
ORDER BY year;
