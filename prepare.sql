-- Creating a table for the import of trip data
CREATE TABLE trip_data (
	ride_id VARCHAR(50), 
	rideable_type VARCHAR(50),
	started_at TIMESTAMP, 
	ended_at TIMESTAMP, 
	start_station_name VARCHAR(100), 
	start_station_id VARCHAR(50), 
	end_station_name VARCHAR(100), 
	end_station_id VARCHAR(50), 
	start_lat DOUBLE PRECISION, 
	start_lng DOUBLE PRECISION, 
	end_lat DOUBLE PRECISION, 
	end_lng DOUBLE PRECISION, 
	member_casual VARCHAR(50)
);

-- Copying the trip data from 12 CSV files to the created table
COPY trip_data
FROM 'C:\Users\dmitr\Downloads\DA C8 Case Study 1\data\202306-divvy-tripdata.csv'
DELIMITER ','
CSV HEADER;

COPY trip_data
FROM 'C:\Users\dmitr\Downloads\DA C8 Case Study 1\data\202307-divvy-tripdata.csv'
DELIMITER ','
CSV HEADER;

COPY trip_data
FROM 'C:\Users\dmitr\Downloads\DA C8 Case Study 1\data\202308-divvy-tripdata.csv'
DELIMITER ','
CSV HEADER;

COPY trip_data
FROM 'C:\Users\dmitr\Downloads\DA C8 Case Study 1\data\202309-divvy-tripdata.csv'
DELIMITER ','
CSV HEADER;

COPY trip_data
FROM 'C:\Users\dmitr\Downloads\DA C8 Case Study 1\data\202310-divvy-tripdata.csv'
DELIMITER ','
CSV HEADER;

COPY trip_data
FROM 'C:\Users\dmitr\Downloads\DA C8 Case Study 1\data\202311-divvy-tripdata.csv'
DELIMITER ','
CSV HEADER;

COPY trip_data
FROM 'C:\Users\dmitr\Downloads\DA C8 Case Study 1\data\202312-divvy-tripdata.csv'
DELIMITER ','
CSV HEADER;

COPY trip_data
FROM 'C:\Users\dmitr\Downloads\DA C8 Case Study 1\data\202401-divvy-tripdata.csv'
DELIMITER ','
CSV HEADER;

COPY trip_data
FROM 'C:\Users\dmitr\Downloads\DA C8 Case Study 1\data\202402-divvy-tripdata.csv'
DELIMITER ','
CSV HEADER;

COPY trip_data
FROM 'C:\Users\dmitr\Downloads\DA C8 Case Study 1\data\202403-divvy-tripdata.csv'
DELIMITER ','
CSV HEADER;

COPY trip_data
FROM 'C:\Users\dmitr\Downloads\DA C8 Case Study 1\data\202404-divvy-tripdata.csv'
DELIMITER ','
CSV HEADER;

COPY trip_data
FROM 'C:\Users\dmitr\Downloads\DA C8 Case Study 1\data\202405-divvy-tripdata.csv'
DELIMITER ','
CSV HEADER;

-- Checking the trip data table
SELECT *
FROM trip_data
LIMIT 10;
