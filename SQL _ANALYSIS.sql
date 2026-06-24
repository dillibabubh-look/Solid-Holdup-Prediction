
USE CFB;

CREATE TABLE riser (
    Ug INT,
    Gs INT,
    z FLOAT,
    [r/R] FLOAT,
    Solid_holdup FLOAT,
    Particle_velocity FLOAT,
    Solid_flux FLOAT
);

BULK INSERT riser
FROM 'C:\Users\dilli\OneDrive\Desktop\M.TECH_PROJECT\CFB_RISER.csv'
WITH (
    FIRSTROW = 2,              -- skips header row
    FIELDTERMINATOR = ',',     -- comma separated
    ROWTERMINATOR = '\n',      -- new line
    TABLOCK
);


ALTER TABLE riser
ALTER COLUMN z DECIMAL(18,4);

ALTER TABLE riser
ALTER COLUMN [r/R] DECIMAL(18,4);

ALTER TABLE riser
ALTER COLUMN solid_holdup DECIMAL(18,4);

ALTER TABLE riser
ALTER COLUMN particle_velocity DECIMAL(18,4);

ALTER TABLE riser
ALTER COLUMN solid_flux DECIMAL(18,4);


-- 1. View Complete Dataset
SELECT * FROM riser;
GO

-- 2. Count Total Records
SELECT COUNT(*) AS TotalRows FROM riser;
GO

--Distinct 
SELECT DISTINCT *
INTO riser_clean
FROM riser;

select* from riser;

WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY Ug, Gs, Solid_Holdup, Particle_Velocity, Solid_Flux
               ORDER BY (SELECT NULL)
           ) AS rn
    FROM riser
)
DELETE FROM cte
WHERE rn > 1;

select* from riser;

-- 3. Check Missing Values
SELECT
SUM(CASE WHEN Ug IS NULL THEN 1 ELSE 0 END) AS Ug_NULLS,
SUM(CASE WHEN Gs IS NULL THEN 1 ELSE 0 END) AS Gs_NULLS,
SUM(CASE WHEN z IS NULL THEN 1 ELSE 0 END) AS z_NULLS,
SUM(CASE WHEN [r/R] IS NULL THEN 1 ELSE 0 END) AS RR_NULLS,
SUM(CASE WHEN Solid_holdup IS NULL THEN 1 ELSE 0 END) AS Holdup_NULLS,
SUM(CASE WHEN Particle_velocity IS NULL THEN 1 ELSE 0 END) AS Velocity_NULLS,
SUM(CASE WHEN Solid_flux IS NULL THEN 1 ELSE 0 END) AS Flux_NULLS
FROM riser;
GO

-- 4. Descriptive Statistics
SELECT
MIN(Ug) AS Min_Ug, MAX(Ug) AS Max_Ug, AVG(Ug) AS Avg_Ug, STDEV(Ug) AS Std_Ug,
MIN(Gs) AS Min_Gs, MAX(Gs) AS Max_Gs, AVG(Gs) AS Avg_Gs, STDEV(Gs) AS Std_Gs,
MIN(Solid_flux) AS Min_Flux, MAX(Solid_flux) AS Max_Flux,
AVG(Solid_flux) AS Avg_Flux, STDEV(Solid_flux) AS Std_Flux
FROM riser;
GO

-- 5. Top 10 Highest Solid Flux Values
SELECT TOP 10 * FROM riser ORDER BY Solid_flux DESC;
GO

-- 6. Top 10 Highest Particle Velocity
SELECT TOP 10 * FROM riser ORDER BY Particle_velocity DESC;
GO

-- 7. Average Values of Entire Dataset
SELECT
AVG(Ug) AS Avg_Ug,
AVG(Gs) AS Avg_Gs,
AVG(z) AS Avg_z,
AVG(Solid_holdup) AS Avg_Holdup,
AVG(Particle_velocity) AS Avg_Velocity,
AVG(Solid_flux) AS Avg_Flux
FROM riser;
GO

-- 8. Group Analysis by Gas Velocity (Ug)
SELECT
Ug,
COUNT(*) AS Records,
AVG(Solid_flux) AS Avg_Flux,
AVG(Particle_velocity) AS Avg_Velocity,
AVG(Solid_holdup) AS Avg_Holdup
FROM riser
GROUP BY Ug
ORDER BY Ug;
GO

-- 9. Group Analysis by Solid Circulation Rate (Gs)
SELECT
Gs,
COUNT(*) AS Records,
AVG(Solid_flux) AS Avg_Flux,
AVG(Particle_velocity) AS Avg_Velocity
FROM riser
GROUP BY Gs
ORDER BY Gs;
GO

-- 10. Outlier Detection in Solid Flux
SELECT *
FROM riser
WHERE Solid_flux >
(
    SELECT AVG(Solid_flux) + 2 * STDEV(Solid_flux)
    FROM riser
);
GO

-- 11. Height (z) vs Solid Flux
SELECT
z,
AVG(Solid_flux) AS Avg_Flux
FROM riser
GROUP BY z
ORDER BY z;
GO

-- 12. Height (z) vs Particle Velocity
SELECT
z,
AVG(Particle_velocity) AS Avg_Velocity
FROM riser
GROUP BY z
ORDER BY z;
GO

-- 13A. Gas Velocity (Ug) vs Solid Flux
SELECT
Ug,
AVG(Solid_flux) AS Avg_Flux
FROM riser
GROUP BY Ug
ORDER BY Ug;
GO

-- 13B. Solids Circulation Rate (Gs) vs Solid Flux
SELECT
Gs,
AVG(Solid_flux) AS Avg_Flux
FROM riser
GROUP BY Gs
ORDER BY Gs;
GO

-- 14. Rounded Output for Report Preparation
SELECT
Ug,
Gs,
ROUND(z,4) AS z,
ROUND([r/R],4) AS RR,
ROUND(Solid_holdup,4) AS Solid_holdup,
ROUND(Particle_velocity,4) AS Particle_velocity,
ROUND(Solid_flux,4) AS Solid_flux
FROM riser;
GO

-- 15. Summary Table for Final Report
SELECT
COUNT(*) AS TotalRows,
AVG(Ug) AS Avg_Ug,
AVG(Gs) AS Avg_Gs,
AVG(Solid_holdup) AS Avg_Holdup,
AVG(Particle_velocity) AS Avg_Velocity,
AVG(Solid_flux) AS Avg_Flux,
MAX(Solid_flux) AS Max_Flux,
MIN(Solid_flux) AS Min_Flux
FROM riser;
GO


-- 16. Maximum and Minimum Values of Every Parameter
SELECT
MAX(Ug) AS Max_Ug,
MIN(Ug) AS Min_Ug,
MAX(Gs) AS Max_Gs,
MIN(Gs) AS Min_Gs,
MAX(z) AS Max_z,
MIN(z) AS Min_z,
MAX(Solid_holdup) AS Max_Holdup,
MIN(Solid_holdup) AS Min_Holdup,
MAX(Particle_velocity) AS Max_Velocity,
MIN(Particle_velocity) AS Min_Velocity,
MAX(Solid_flux) AS Max_Flux,
MIN(Solid_flux) AS Min_Flux
FROM riser;
GO

-- 17. Average Solid Flux at Each Height
SELECT
z,
AVG(Solid_flux) AS Avg_Solid_Flux
FROM riser
GROUP BY z
ORDER BY z;
GO

-- 18. Average Solid Holdup at Each Height
SELECT
z,
AVG(Solid_holdup) AS Avg_Holdup
FROM riser
GROUP BY z
ORDER BY z;
GO

-- 19. Average Particle Velocity at Each Height
SELECT
z,
AVG(Particle_velocity) AS Avg_Velocity
FROM riser
GROUP BY z
ORDER BY z;
GO

-- 20. Compare Different Gas Velocities
SELECT
Ug,
AVG(Solid_holdup) AS Avg_Holdup,
AVG(Particle_velocity) AS Avg_Velocity,
AVG(Solid_flux) AS Avg_Flux
FROM riser
GROUP BY Ug
ORDER BY Ug;
GO

-- 21. Compare Different Solid Flux Conditions
SELECT
Gs,
AVG(Solid_holdup) AS Avg_Holdup,
AVG(Particle_velocity) AS Avg_Velocity,
AVG(Solid_flux) AS Avg_Flux
FROM riser
GROUP BY Gs
ORDER BY Gs;
GO

-- 22. Highest Solid Holdup Locations
SELECT TOP 10 *
FROM riser
ORDER BY Solid_holdup DESC;
GO

-- 23. Lowest Solid Holdup Locations
SELECT TOP 10 *
FROM riser
ORDER BY Solid_holdup ASC;
GO

-- 24. Highest Particle Velocity Locations
SELECT TOP 10 *
FROM riser
ORDER BY Particle_velocity DESC;
GO

-- 25. Percentage of Data Above Average Solid Flux
SELECT
COUNT(*) * 100.0 /
(SELECT COUNT(*) FROM riser) AS Percentage_Above_Avg
FROM riser
WHERE Solid_flux >
(
SELECT AVG(Solid_flux)
FROM riser
);
GO

-- 26. Radial Distribution Analysis
SELECT
[r/R],
AVG(Solid_holdup) AS Avg_Holdup,
AVG(Particle_velocity) AS Avg_Velocity,
AVG(Solid_flux) AS Avg_Flux
FROM riser
GROUP BY [r/R]
ORDER BY [r/R];
GO

-- 27. Dense Region Detection
SELECT *
FROM riser
WHERE Solid_holdup >
(
SELECT AVG(Solid_holdup)
FROM riser
);
GO

-- 28. Fast Particle Region Detection
SELECT *
FROM riser
WHERE Particle_velocity >
(
SELECT AVG(Particle_velocity)
FROM riser
);
GO

-- 29. Combined High-Performance Regions
SELECT *
FROM riser
WHERE Solid_flux >
(
SELECT AVG(Solid_flux)
FROM riser
)
AND Particle_velocity >
(
SELECT AVG(Particle_velocity)
FROM riser
);
GO

-- 30. Rank Solid Flux Values
SELECT
ROW_NUMBER() OVER (ORDER BY Solid_flux DESC) AS Rank_No,
Ug,
Gs,
z,
Solid_flux
FROM riser;
GO

-- 31. Rank Particle Velocity Values
SELECT
ROW_NUMBER() OVER (ORDER BY Particle_velocity DESC) AS Rank_No,
Ug,
Gs,
z,
Particle_velocity
FROM riser;
GO

-- 32. Coefficient of Variation (Data Spread)
SELECT
(STDEV(Solid_flux)/AVG(Solid_flux))*100 AS CV_Flux_Percent,
(STDEV(Particle_velocity)/AVG(Particle_velocity))*100 AS CV_Velocity_Percent
FROM riser;
GO

-- 33. Median Solid Flux
SELECT DISTINCT
PERCENTILE_CONT(0.5)
WITHIN GROUP (ORDER BY Solid_flux)
OVER () AS Median_Flux
FROM riser;
GO

-- 34. Median Particle Velocity
SELECT DISTINCT
PERCENTILE_CONT(0.5)
WITHIN GROUP (ORDER BY Particle_velocity)
OVER () AS Median_Velocity
FROM riser;
GO

-- 35. Create a View for Repeated Analysis
CREATE VIEW Riser_Summary AS
SELECT
Ug,
Gs,
z,
[r/R],
Solid_holdup,
Particle_velocity,
Solid_flux
FROM riser;
GO

SELECT @@SERVERNAME AS ServerName;

SELECT @@SERVERNAME;
SELECT DB_NAME();

select * from riser;