# Google-Data-Analytics-Capstone-Project-Cyclistic-Case-Study

## Introduction

This repository contains the Google Data Analytics capstone project, a case study of a fictional bike-share company called Cyclistic, that I completed as a final course of the Google Data Analytics Professional Certificate. The project includes data analysis of the given scenario based on the six phases learned in the certificate: [ask](https://github.com/dmitrijs-belovs/Google-Data-Analytics-Capstone-Project-Cyclistic-Case-Study/edit/main/README.md#ask), [prepare](https://github.com/dmitrijs-belovs/Google-Data-Analytics-Capstone-Project-Cyclistic-Case-Study/edit/main/README.md#prepare), [process](https://github.com/dmitrijs-belovs/Google-Data-Analytics-Capstone-Project-Cyclistic-Case-Study/edit/main/README.md#process), [analyze](https://github.com/dmitrijs-belovs/Google-Data-Analytics-Capstone-Project-Cyclistic-Case-Study/edit/main/README.md#analyze), [share](), and [act](). I used PostgreSQL in pgAdmin 4 for data preparation and processing, and Tableau Public for data visualization and analysis. Although, to some extent, complete analysis can be done using only one of these tools, I chose to use both to demonstrate dynamic skills learned in the certificate and necessary for a data analyst.

## Scenario

I am a junior data analyst working in the marketing analyst team at Cyclistic, a bike-share company in Chicago. Cyclistic launched in 2016 and since then, the program has grown to a fleet of 5,824 bicycles that are geotracked and locked into a network of 692 stations across Chicago. The bikes can be unlocked from one station and returned to any other station in the system anytime.

Until now, Cyclistic’s marketing strategy relied on building general awareness and appealing to broad consumer segments. One approach that helped make these things possible was the flexibility of its pricing plans: single-ride passes, full-day passes, and annual memberships. Customers who purchase single-ride or full-day passes are referred to as casual riders. Customers who purchase annual memberships are Cyclistic members.

Cyclistic’s finance analysts have concluded that annual members are much more profitable than casual riders. Although the pricing flexibility helps Cyclistic attract more customers, Moreno believes that maximizing the number of annual members will be key to future growth. Rather than creating a marketing campaign that targets all-new customers, Moreno believes there is a very good chance to convert casual riders into members. She notes that casual riders are already aware of the Cyclistic program and have chosen Cyclistic for their mobility needs.

Moreno has set a clear goal: Design marketing strategies aimed at converting casual riders into annual members. In order to do that, however, the marketing analyst team needs to better understand how annual members and casual riders differ, why casual riders would buy a membership, and how digital media could affect their marketing tactics.

Moreno has assigned me the first question to answer: How do annual members and casual riders use Cyclistic bikes differently? I need to answer this question with compelling data insights and professional data visualizations.

## Ask

In the ask phase, I am considering the problem I am trying to solve. The problem or business task is already defined by Moreno: Design marketing strategies aimed at converting casual riders into annual members. The guiding questions are also defined, and one of them was assigned to me: How do annual members and casual riders use Cyclistic bikes differently? However, I need to keep in mind the business task and the other guiding questions when answering the question assigned to me to extract and present the most useful, actionable data insights.

## Prepare

#### [SQL query executed in the prepare phase.](https://github.com/dmitrijs-belovs/Google-Data-Analytics-Capstone-Project-Cyclistic-Case-Study/blob/main/prepare.sql)

In the prepare phase, I am describing all data sources used. The [data](https://divvy-tripdata.s3.amazonaws.com/index.html) is provided by Divvy under this [license](https://www.divvybikes.com/data-license-agreement) and will be used as fictional company Cyclistic’s historical trip data. Divvy is a real bike-share company in Chicago and the data it provides is its own data on actual trips. Thus, without getting into details, the data is ROCCC, in other words, reliable, original, comprehensive, current, and cited. Each trip is already anonymized by the company and therefore maintains privacy.

The data contains information on:

- trip start day and time, trip end day and time
- trip start station, trip end station
- rideable type (electric bike, classic bike and docked bike)
- rider type (member and casual)

This information should be sufficient to analyze the differences in bike use between annual members and casual riders by day and time of trip start, trip duration, trip start and end station, trip direction, trip length, and rideable type, and discover potential solutions and offers for converting casual riders into annual members.

Divvy provides two types of data for download: monthly trip data and quarter trip data. Two options are suggested by course instructor: to work with an entire year of data, or just one quarter of a year. I chose to work with monthly trip data for the entire year from June 2023 through May 2024, which was the most recent period at the moment of completing the project, and downloaded 12 CSV files corresponding to each month in that period.  

All CSV files have the same organization, namely 13 columns with the same names: 

- ride_id
- rideable_type
- started_at
- ended_at
- start_station_name
- start_station_id
- end_station_name
- end_station_id
- start_lat
- start_lng
- end_lat
- end_lng
- member_casual

To prepare the data for processing, I imported it into the pgAdmin environment by creating a new table trip_data and copying the data from 12 CSV files to the created table.

## Process

#### [SQL query executed in the process phase.](https://github.com/dmitrijs-belovs/Google-Data-Analytics-Capstone-Project-Cyclistic-Case-Study/blob/main/process.sql)

In the process phase, I am checked, cleaned and manipulated the data. 

### Checking the data

I began with checking the data for potential inconsistencies:

- **Returning the number of observations:**
    - 5 743 278

- **Checking for missing values in all columns:**
    - start_station_name and start_station_id: 905 237 missing values
    - end_station_name and end_station_id: 956 579 missing values
    - end_lat and eng_lng: 7684 missing values
    - other columns: no missing values

- **Checking for duplicate values:**
    - no duplicate values

- **Checking the consistency of ride_id column value lengths:**
    - All ride IDs have the same length.

- **Checking the consistency of rideable_type column values:**
    - There are 3 unique rideable_type values: "classic_bike", "docked_bike", and "electric_bike", thus there are no spelling errors.

- **Checking the range of started_at and ended_at column values:**
    - earliest started trip: "2023-06-01 00:00:44" and latest startet trip: "2024-05-31 23:59:57"
    - earliest ended trip: "2023-06-01 00:02:56" and latest ended trip: "2024-06-02 00:56:55"
    - The trip data falls into the period from June 2023 through May 2024; there are no trips that started before and ended during the selected period, but there are trips that started at the last minutes of May 2024 and, logically, ended in June 2024 (211 such trips), thus, there are no spelling errors, and trips that ended after the selected period don't need to be removed.

- **Checking the consistency of station names:**
    - There are 1638 unique station names;
    - Since there are a lot of unique station names, I checked their consistency with the help of station IDs, namely, I returned station IDs to which multiple station names are assigned:
        - There are 81 station IDs with 2 station names, of which 7 station IDs have multiple names due to inconsistent spelling, for example, Buckingham - Fountain" and "Buckingham Fountain", or "Grace & Cicero" and "Grace St & Cicero Ave", and can be fixed, but the rest have two different station names, which is difficult to fix due to a lack of information but not necessarily needs to be;
        - These 81 station IDs have 378 235 observations, and this amount is too large to be simply removed, as it can affect the analysis of several stations that may contribute to the overall analysis.
    - The second way that I used to check the consistency of the station names was by comparing stations with station information downloaded from the Divvy website and imported as a second table in pgadmin environment:
        - All stations in a newly imported table are unique, and station IDs don't have multiple station names;
        - There are 48 station names in the trip data table that don't have a match in the stations table, of which there are all previously found out station names with spelling inconsistencies, but the rest have minor differencies in spelling (for example, not having "St" or "Ave" in one table or another) and don't have similar 'duplicate' values, and some trip data stations are not in the stations table;
        - These 48 station names have 57 189 observations in the trip data table.
    - So the best solution for me was to fix the station names for the 7 station IDs with multiple station names mentioned earlier and don't remove other observations.

- **Checking the consistency of station latitude and longitude values:**

    - Firstly, I checked the range of stations latitude and longitude values:
        - minimum latitude: 0 and maximum latitude: 42.18;
        - minimum longitute: -88.16 and maximum longitute: 0;
        - There are zero values that are outside of the approximate minimum and maximum latitude and longitude range for Chichago;
        - After checking station latitudes and longitudes without zero values, minimum and maximum latitude and longitude values became normal for Chichago, thus, there are observations with latitude and longitude zero values that need to be removed.
    - Secondly, I checked for stations to which multiple very close latitude and longitude values are assigned:
        - Almost every station has many very close latitude and longitude values (possibly due to recording devices), which will cause difficulties for Tableau in creating map visualizations by not being able to aggregate the trips by station;
        - Therefore, I similarly checked the consistency of station latitude and longitude values in the stations table to verify if I could bring them to the trip data table:
            - There are no stations with multiple very close latitude and longitude values, and the range of latitude and longitude values is correct, thus, I will use them to replace trip data table latitude and longitude values.

- **Checking the consistency of member_casual column values:**
    - As expected, there are 2 unique member_casual values: "member" and "casual", thus there are no spelling errors.
 
### Cleaning the data

Next, based on an initial check of the data, I performed data cleaning:

- **Removing observations with missing values.**
- **Fixing inconsistent spelling of station names for 7 station IDs.**
- **Replacing latitude and longitude values with the values from the stations table.**
    - After that, I also removed observations for trip data stations that are not in the stations table because I can't replace their latitude and longitude values.
    - This also removed observations with missing and zero latitude and longitude values.

### Manipulating the data

The last step of the process phace was manipulating the data:

- **Adding ride_length column (in minutes).**

After adding ride length column, I performed additional data check:

- **Checking the range of ride_length column:**
    - shortest trip: "-54.57", longest trip: "11152.27"
    - Since there are possible errors and outliers, I checked trips that are shorter than a minute and longer than 1440 minutes (24 hours):
        - There are 76 337 trip shorter than a minute and longer than 24 hours, of which 76 178 shorter than a minute (with 71 negative values) and 159 longer than 24 hours.
    - Trips shorter than a minute might be errors or test rides, and trips that are longer than 24 hours migth be errors or extreme cases, thus, it is better to exclude them.
    - I also checked if start_station and end_station are the same for trips shorter than a minute:
        - From 76 178 observations with ride length shorter than one minute, 71 960 are started and ended at the same station, which to some extent can confirm that they might be errors or test rides.

In the end, I removed observations shorter than a minute and longer than 24 hours, and the final, cleaned trip data table resulted in 4 209 795 observations.

## Analyze

In the analyze phace, I vizualized and analyzed the data.

