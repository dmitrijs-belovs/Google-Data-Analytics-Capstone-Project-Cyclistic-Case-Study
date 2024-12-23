-- CHECKING THE DATA

-- Returning the number of observations
SELECT COUNT(*) AS number_of_observations
FROM trip_data;

-- Checking for missing values in all columns
SELECT 
	COUNT(*) - COUNT(ride_id) AS ride_id,
	COUNT(*) - COUNT(rideable_type) AS rideable_type,
	COUNT(*) - COUNT(started_at) AS started_at,
	COUNT(*) - COUNT(ended_at) AS ended_at,
	COUNT(*) - COUNT(start_station_name) AS start_station_name,
	COUNT(*) - COUNT(start_station_id) AS start_station_id,
	COUNT(*) - COUNT(end_station_name) AS end_station_name,
	COUNT(*) - COUNT(end_station_id) AS end_station_id,
	COUNT(*) - COUNT(start_lat) AS start_lat,
	COUNT(*) - COUNT(start_lng) AS start_lng,
	COUNT(*) - COUNT(end_lat) AS end_lat,
	COUNT(*) - COUNT(end_lng) AS end_lng,
	COUNT(*) - COUNT(member_casual) AS member_casual
FROM trip_data;

-- Checking for duplicates values
SELECT COUNT(*) - COUNT(DISTINCT ride_id) AS duplicates_of_rides
FROM trip_data;

-- Checking the consistency of ride_id column value lengths
SELECT DISTINCT
	ride_id AS unique_lengths_of_ride_ids
FROM
	(SELECT LENGTH(ride_id) AS ride_id
	FROM trip_data);

-- Checking the consistency of rideable_type column values
SELECT DISTINCT rideable_type AS unique_rideable_types
FROM trip_data;

-- Checking the range of started_at and ended_at column values
SELECT 
	ARRAY[MIN(started_at), MAX(started_at)] AS earliest_and_latest_started_trip,
	ARRAY[MIN(ended_at), MAX(ended_at)] AS earliest_and_latest_ended_trip
FROM trip_data;

	-- Checking trips that started that started at the last minutes of May 2024 and ended in June 2024
	SELECT *
	FROM trip_data
	WHERE started_at < '2023-06-01 00:00:00' OR ended_at > '2024-06-01 00:00:00';

-- Checking the consistency of station names and IDs

	-- Checking the number of unique station names and IDs
	SELECT
		COUNT(DISTINCT station_id) AS unique_station_ids,
		COUNT(DISTINCT station_name) AS unique_station_names
	FROM
		(SELECT 
			start_station_id AS station_id,
			start_station_name AS station_name
		FROM
			trip_data
		UNION ALL
		SELECT 
			end_station_id AS station_id,
			end_station_name AS station_name
		FROM
			trip_data);
	
	-- Checking station IDs to which multiple station names are assigned
	SELECT
		station_id,
		array_agg(DISTINCT station_name ORDER BY station_name) AS station_names,
		COUNT(DISTINCT station_name) AS station_name_count
	FROM
		(SELECT 
			start_station_id AS station_id,
			start_station_name AS station_name
		FROM
			trip_data
		UNION ALL
		SELECT 
			end_station_id AS station_id,
			end_station_name AS station_name
		FROM
			trip_data)
	GROUP BY
		station_id
	HAVING 
		COUNT(DISTINCT station_name) > 1;
	
	-- Checking the number of observations for station IDs with multiple station names
	SELECT
		COUNT(*) AS number_of_observations_for_station_ids_with_multiple_names
	FROM
		trip_data
	WHERE start_station_id NOT IN
		(SELECT 
			start_station_id
		FROM
			trip_data
		GROUP BY
			start_station_id
		HAVING COUNT(DISTINCT start_station_name) > 1) OR

		end_station_id NOT IN

		(SELECT 
			end_station_id
		FROM
			trip_data
		GROUP BY
			end_station_id
		HAVING COUNT(DISTINCT end_station_name) > 1);

	-- Comparing stations with station information downloaded from the Divvy website

		-- Creating a table for the import of station data
		CREATE TABLE stations (
			station_id VARCHAR(50),
			station_name VARCHAR(100),
			station_lat DOUBLE PRECISION,
			station_lng DOUBLE PRECISION
		);

		-- Copying the station data from a CSV file
		COPY stations
		FROM 'C:\Users\dmitr\Downloads\DA C8 Case Study 1\data\station_information.csv'
		DELIMITER ','
		CSV HEADER;

		-- Checking the stations table		
		SELECT *
		FROM stations;

		-- Checking the number of unique station names and IDs in the stations table
		SELECT
			COUNT(DISTINCT station_id) AS unique_station_ids,
			COUNT(DISTINCT station_name) AS unique_station_names
		FROM stations;

		-- Checking station IDs with multiple station names in the stations table
		SELECT
			station_id,
			array_agg(DISTINCT station_name ORDER BY station_name) AS station_names,
			COUNT(DISTINCT station_name) AS station_name_count
		FROM
			stations
		GROUP BY
			station_id
		HAVING 
			station_id IS NOT NULL AND COUNT(DISTINCT station_name) > 1;

		-- Checking stations that are in the trip_data table but not in the stations table
	 	SELECT DISTINCT station_name
		FROM 
			(SELECT 
			start_station_id AS station_id,
			start_station_name AS station_name
			FROM
				trip_data	
			UNION ALL
			SELECT 
				end_station_id AS station_id,
				end_station_name AS station_name
			FROM
				trip_data)
		WHERE station_name NOT IN (SELECT station_name FROM stations);

		-- Checking the number of observations for stations that are only in trip data table
		SELECT COUNT(*) AS number_of_observations
			FROM trip_data
			WHERE 
				start_station_name NOT IN (SELECT station_name FROM stations) OR
				end_station_name NOT IN (SELECT station_name FROM stations);

-- Checking the consistency of station latitude and longitude values

	-- Checking the range of station latitude and longitude values
	SELECT
		ARRAY[MIN(lat), MAX(lat)] AS min_and_max_lat,
		ARRAY[MIN(lng), MAX(lng)] AS min_and_max_lng
	FROM
		(SELECT 
			start_lat AS lat,
			start_lng AS lng
		FROM
			trip_data
		UNION ALL
		SELECT 
			end_lat AS lat,
			end_lng AS lng
		FROM
			trip_data);
	
	-- Checking the range of station latitude and longitude values without zero values
	SELECT
		ARRAY[MIN(lat), MAX(lat)] AS min_and_max_lat,
		ARRAY[MIN(lng), MAX(lng)] AS min_and_max_lng
	FROM
		(SELECT 
			start_lat AS lat,
			start_lng AS lng
		FROM
			trip_data
		UNION ALL
		SELECT 
			end_lat AS lat,
			end_lng AS lng
		FROM
			trip_data)
	WHERE lat != 0 OR lng != 0;

	-- Checking stations to which multiple very close latitude and longitude values are assigned
	SELECT
		station_name,
		COUNT(DISTINCT station_lat) AS station_lat_count,
		COUNT(DISTINCT station_lng) AS station_lng_count
	FROM
		(SELECT 
			start_station_name AS station_name,
			start_lat AS station_lat,
			start_lng AS station_lng
		FROM
			trip_data
		UNION ALL
		SELECT 
			end_station_name AS station_name,
			end_lat AS station_lat,
			end_lng AS station_lng
		FROM
			trip_data)
		GROUP BY
			station_name
		HAVING 
			 COUNT(DISTINCT station_lat) > 1 OR COUNT(DISTINCT station_lng) > 1
		ORDER BY 
			station_lat_count DESC, 
			station_lng_count DESC;

		-- Checking stations with multiple very close latitude and longitude values in the stations table
		SELECT
			station_name,
			COUNT(DISTINCT station_lat) AS station_lat_count,
			COUNT(DISTINCT station_lng) AS station_lng_count
		FROM
			stations
		GROUP BY
			station_name
		HAVING 
			COUNT(DISTINCT station_lat) > 1 OR COUNT(DISTINCT station_lng) > 1;

		-- Checking the range of station latitude and longitude values in the stations table
		SELECT
			ARRAY[MIN(station_lat), MAX(station_lat)] AS min_and_max_lat,
			ARRAY[MIN(station_lng), MAX(station_lng)] AS min_and_max_lng
		FROM
			stations;


-- CLEANING THE DATA

-- Removing observations with missing values and zero latitude and longitude values
DELETE FROM trip_data
WHERE 
	start_station_name IS NULL OR
	start_station_id IS NULL OR
	end_station_name IS NULL OR
	end_station_id IS NULL;

-- Fixing inconsistent spelling of station IDs and station names for 7 station IDs 
UPDATE trip_data
SET start_station_id = CASE
		WHEN start_station_id = '15541.1.1' THEN '15541'
		ELSE start_station_id
	END,
	end_station_id = CASE
		WHEN end_station_id = '15541.1.1' THEN '15541'
		ELSE end_station_id
	END;

UPDATE trip_data
SET start_station_name = CASE start_station_id
		WHEN '13290' THEN 'Noble St & Milwaukee Ave'
		WHEN '15541' THEN 'Buckingham Fountain'
		WHEN '21322' THEN 'Grace St & Cicero Ave'
		WHEN '21366' THEN 'Spaulding Ave & 16th St'
		WHEN '21371' THEN 'Kildare Ave & Chicago Ave'
		WHEN '23215' THEN 'Lexington St & California Ave'
		WHEN 'KA1503000074' THEN 'Griffin Museum of Science and Industry'
		ELSE start_station_name
	END,
	end_station_name = CASE end_station_id
		WHEN '13290' THEN 'Noble St & Milwaukee Ave'
		WHEN '15541' THEN 'Buckingham Fountain'
		WHEN '21322' THEN 'Grace St & Cicero Ave'
		WHEN '21366' THEN 'Spaulding Ave & 16th St'
		WHEN '21371' THEN 'Kildare Ave & Chicago Ave'
		WHEN '23215' THEN 'Lexington St & California Ave'
		WHEN 'KA1503000074' THEN 'Griffin Museum of Science and Industry'
		ELSE end_station_name
	END;

-- Fixing inconsistent station latitude and longitude values
	
	-- Updating start station latitude and longitude with values from stations table
	UPDATE trip_data
	SET 
	    start_lat = s.station_lat,
	    start_lng = s.station_lng
	FROM stations AS s
	WHERE trip_data.start_station_name = s.station_name;
	
	-- Updating end station latitude and longitude with values from stations table
	UPDATE trip_data
	SET 
	    end_lat = s.station_lat,
	    end_lng = s.station_lng
	FROM stations AS s
	WHERE trip_data.end_station_name = s.station_name;
		
	-- Removing stations that are in the trip_data table but not in the stations table 
	DELETE FROM trip_data
	WHERE start_station_name NOT IN (SELECT station_name FROM stations) OR
		end_station_name NOT IN (SELECT station_name FROM stations);

-- Checking the cleaned trip data table
SELECT *
FROM trip_data
LIMIT 10;

-- Returning the number of observations of cleaned trip data table
SELECT COUNT(*) AS number_of_observations
FROM trip_data;


-- MANIPULATING THE DATA

-- Adding ride_length column to the trip data table
ALTER TABLE trip_data
ADD COLUMN ride_length DOUBLE PRECISION;

-- Updating ride_length column
UPDATE trip_data
SET ride_length = EXTRACT(EPOCH FROM (ended_at - started_at))/60;

-- Checking the updated trip data table
SELECT *
FROM trip_data
LIMIT 10;

-- Checking the ride_lentgh column

	-- Checking the range of ride lengths
	SELECT 
		ARRAY[MIN(ride_length), MAX(ride_length)] AS shortest_and_longest_trip
	FROM trip_data;
	
	-- Checking trips that are shorter than a minute and longer than 24 hours
	SELECT 
		ride_length
	FROM trip_data
	WHERE ride_length < 1 OR ride_length > 1440
	ORDER BY ride_length DESC;
	
	-- Checking trips that are shorter than a minute and started and ended at the same station 
	SELECT ride_length
	FROM
		(SELECT
			start_station_name,
			end_station_name,
			ride_length
		FROM trip_data
		WHERE ride_length < 1)
	WHERE start_station_name = end_station_name;

-- Removing observations with ride length shorter than a minute and longer than 24 hours
DELETE FROM trip_data
	WHERE ride_length < 1 OR ride_length > 1440;

-- Returning the number of observations of final, cleaned trip data table
SELECT COUNT(*) AS number_of_observations
FROM trip_data;