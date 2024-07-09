# Google-Data-Analytics-Capstone-Project-Cyclistic-Case-Study

## Introduction

This document is the Google Data Analytics Professional Certificate capstone project, a case study of a fictional bike-share company called Cyclistic, that I completed as the last portfolio-building course of the certificate. The project includes data analysis of the given scenario based on the six phases learned in the certificate: [ask](https://github.com/dmitrijs-belovs/Google-Data-Analytics-Capstone-Project-Cyclistic-Case-Study/edit/main/README.md#ask), [prepare](https://github.com/dmitrijs-belovs/Google-Data-Analytics-Capstone-Project-Cyclistic-Case-Study/edit/main/README.md#prepare), process, analyse, share, and act. I used PostgreSQL in pgAdmin 4 for data preparation, processing, and exploration, and Tableau for data analysis and visualization. Although, to some extent, all phases of analysis can be done using only one of these tools, I decided to use both to demonstrate the dynamic skills acquired in the certificate and necessary for the data analyst job.

## Scenario

I am a junior data analyst working in the marketing analyst team at Cyclistic, a bike-share company in Chicago. Cyclistic launched in 2016 and since then, the program has grown to a fleet of 5,824 bicycles that are geotracked and locked into a network of 692 stations across Chicago. The bikes can be unlocked from one station and returned to any other station in the system anytime.

Until now, Cyclistic’s marketing strategy relied on building general awareness and appealing to broad consumer segments. One approach that helped make these things possible was the flexibility of its pricing plans: single-ride passes, full-day passes, and annual memberships. Customers who purchase single-ride or full-day passes are referred to as casual riders. Customers who purchase annual memberships are Cyclistic members.

Cyclistic’s finance analysts have concluded that annual members are much more profitable than casual riders. Although the pricing flexibility helps Cyclistic attract more customers, Moreno believes that maximizing the number of annual members will be key to future growth. Rather than creating a marketing campaign that targets all-new customers, Moreno believes there is a very good chance to convert casual riders into members. She notes that casual riders are already aware of the Cyclistic program and have chosen Cyclistic for their mobility needs.

Moreno has set a clear goal: Design marketing strategies aimed at converting casual riders into annual members. In order to do that, however, the marketing analyst team needs to better understand how annual members and casual riders differ, why casual riders would buy a membership, and how digital media could affect their marketing tactics.

Moreno has assigned me the first question to answer: How do annual members and casual riders use Cyclistic bikes differently? I need to answer this question with compelling data insights and professional data visualizations.

## Ask

In the ask phase, I am considering the problem I am trying to solve and how my insights can drive business decisions. The problem or business task is already defined by Moreno: Design marketing strategies aimed at converting casual riders into annual members. The guiding questions are also defined, and one of them was assigned to me: How do annual members and casual riders use Cyclistic bikes differently? However, I need to keep in mind the business task and the other guiding questions when answering the question assigned to me to extract and present the most useful, actionable data insights. 

## Prepare

In the prepare phase, I am describing all data sources used. The [data](https://divvy-tripdata.s3.amazonaws.com/index.html) is provided by Motivate International Inc. under this [license](https://www.divvybikes.com/data-license-agreement) and will be used as fictional company Cyclistic’s historical trip data. Motivate International Inc. is a real bike-share company in Chicago and the data it provides is its own data on actual trips. Thus, the data is ROCCC, in other words, reliable, original, comprehensive, current, and cited. Each trip is already anonymized by the company and therefore maintains privacy.

The data contains information on:

- trip start day and time, trip end day and time
- trip start station, trip end station
- rideable type (electric bike, classic bike and docked bike)
- rider type (member and casual)

This information should be sufficient to analyze the differences in bike use between annual members and casual riders by day and time of trip start, trip duration, trip start and end station, trip direction, trip length, and rideable type, and discover potential solutions and offers for converting casual riders into annual members.

Motivate International Inc. provides two types of data for download: monthly trip data and quarter trip data. Two options are suggested by course instructor: to work with an entire year of data, or just one quarter of a year. I chose to work with monthly trip data for the entire year from June 2023 through May 2024, which was the most recent period at the moment of completing the project, and downloaded 12 CSV files corresponding to each month in that period.  

All CSV files had the same organization, namely 13 columns with the same names: 

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

To prepare the data for processing, I imported it into the pgAdmin environment by creating a new table trip_data and copying the trip data from 12 CSV files to the created table.

#### [SQL query executed in the prepare phase.](https://github.com/dmitrijs-belovs/Google-Data-Analytics-Capstone-Project-Cyclistic-Case-Study/blob/main/prepare.sql)

## Process

#### [SQL query executed in the process phase.](https://github.com/dmitrijs-belovs/Google-Data-Analytics-Capstone-Project-Cyclistic-Case-Study/blob/main/prepare.sql)

In the process phase, I began with checking the data for potential inconsistencies:

- Returning the number of observations:
    - 5 743 278.
- Checking for missing values in all columns:
    - start_station_name and start_station_id: 905 237 missing values;
    - end_station_name and end_station_id: 956 579 missing values;
    - end_lat and eng_lng: 7684 missing values;
    - other columns: no missing values.
- Checking for duplicate values:
    - no duplicate values.
- Checking the consistency of ride_id column value lengths:
    - all ride ids have the same length.
- Checking the consistency of rideable_type column values:
    - there are 3 unique rideable_type values: "classic_bike", "docked_bike", and "electric_bike", thus there are no spelling errors.
- Checking the range of started_at and ended_at column values:
    - earliest started trip: "2023-06-01 00:00:44" and latest startet trip: "2024-05-31 23:59:57";
    - earliest ended trip: "2023-06-01 00:02:56" and latest ended trip: "2024-06-02 00:56:55";
      - the trip data falls into the period from June 2023 through May 2024, except there are several trips that started at the last minutes of May 2024 and, logically, ended in June 2024, thus, there are no spelling errors.
- Checking the consistency of station names:
    - There are 1638 unique station names;
    - Since there are a lot of unique station names, I checked the consistency of the station names with the help of station ids, namely I returned station ids with multiple station names:
        - There are 81 station ids with 2 station names (except one case with 4 station names), of which 8 station ids have multiple names due to inconsistent typing, for example, Buckingham - Fountain" and Buckingham Fountain, or Grace & Cicero"", Grace St & Cicero Ave, and can be fixed, and the rest 73 station ids have two different station names, which is difficult to fix due to a lack of information.
    - I also checked the number of observations in trip data for those 81 station ids with multiple station names to see if I could remove them from the table without impacting the data and analysis:
        - There are 378 235 such observations.
    - The second way that I used to check the consistency of the station names was comparing trip_data stations with stations from the data downloaded from Chichago data portal:
    - 
 

- Checking the range of stations latitude and longitude values
    - minimum latitude: 0 and maximum latitude: 42.18
    - minimum longitute: -88.16 and maximum longitute: 0
        - there are zero values that are outside of the approximate minimum and maximum latitude and longitude range for Chichago
            - after checking station latitudes and longitudes without zero values, minimum and maximum latitude and longitude values became normal for Chichago, thus, there are observations with latitude and longitude zero values that needs to be removed.
- Checking the consistency of member_casual column values
    - as expected, there are 2 unique member_casual values: "member" and "casual", thus there are no spelling errors.
