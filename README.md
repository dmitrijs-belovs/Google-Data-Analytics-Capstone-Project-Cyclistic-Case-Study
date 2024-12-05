# Google-Data-Analytics-Capstone-Project-Cyclistic-Case-Study

## Introduction

This repository contains the Google Data Analytics capstone project, a case study of a fictional bike-share company called Cyclistic, that I completed as a final course of the Google Data Analytics Professional Certificate. The project includes data analysis of the given scenario based on the six phases learned in the certificate: [ask](https://github.com/dmitrijs-belovs/Google-Data-Analytics-Capstone-Project-Cyclistic-Case-Study?tab=readme-ov-file#ask), [prepare](https://github.com/dmitrijs-belovs/Google-Data-Analytics-Capstone-Project-Cyclistic-Case-Study?tab=readme-ov-file#prepare), [process](https://github.com/dmitrijs-belovs/Google-Data-Analytics-Capstone-Project-Cyclistic-Case-Study?tab=readme-ov-file#process), [analyze](https://github.com/dmitrijs-belovs/Google-Data-Analytics-Capstone-Project-Cyclistic-Case-Study?tab=readme-ov-file#analyze-and-share), [share](https://github.com/dmitrijs-belovs/Google-Data-Analytics-Capstone-Project-Cyclistic-Case-Study?tab=readme-ov-file#analyze-and-share), and [act](https://github.com/dmitrijs-belovs/Google-Data-Analytics-Capstone-Project-Cyclistic-Case-Study?tab=readme-ov-file#act). I use PostgreSQL in pgAdmin 4 for data preparation and processing, and Tableau Public for data analysis and visualization.

## Scenario

I am a junior data analyst working in the marketing analyst team at Cyclistic, a bike-share company in Chicago. Until now, Cyclistic’s marketing strategy relied on building general awareness and appealing to broad consumer segments by offering flexibile pricing plans: single-ride passes, full-day passes, and annual memberships. Recently, Cyclistic’s finance analysts have concluded that annual members are much more profitable than casual riders. The director of marketing believes that there is a very good chance to convert casual riders into members. Therefore, rather than creating a marketing campaign that targets all-new customers, he set a goal to design marketing strategies aimed at converting casual riders into annual members. In order to do that, the marketing analyst team needs to better understand how annual members and casual riders differ, why casual riders would buy a membership, and how digital media could affect their marketing tactics.

## Ask

In the ask phase, I am considering the problem I am trying to solve. The problem or business task is already defined by the director of marketing: Design marketing strategies aimed at converting casual riders into annual members. The guiding questions are also defined, and one of them was assigned to me: How do annual members and casual riders use Cyclistic bikes differently?

## Prepare

In the prepare phase, I am describing all data sources used. The [data](https://divvy-tripdata.s3.amazonaws.com/index.html) is provided by Divvy under this [license](https://www.divvybikes.com/data-license-agreement) and will be used as fictional company Cyclistic’s historical trip data. Divvy is a real bike-share company in Chicago and the data it provides is its own data on actual trips. Thus, without getting into details, the data is ROCCC, in other words, reliable, original, comprehensive, current, and cited. Each trip is already anonymized by the company and therefore maintains privacy.

The data contains information on:

- trip start day and time, trip end day and time
- trip start station, trip end station
- rideable type (electric bike, classic bike and docked bike)
- rider type (member and casual)

This information allows analyzing the aggregate differences in bike use between annual members and casual riders by month, day and time of trip start, trip duration, trip start and end station, and rideable type.

Divvy provides two types of data for download: monthly trip data and quarter trip data. Two options are suggested by course instructor: to work with an entire year of data, or just one quarter of a year. I chose to work with monthly trip data for the entire year from June 2023 through May 2024, which was the most recent period at the moment of completing the project, and downloaded 12 CSV files corresponding to each month in that period.

To prepare the data for processing, I imported it into the pgAdmin environment by creating a new table trip_data and copying the data from 12 CSV files to the created table (all CSV files have the same number of columns and column names).

#### [Full SQL query executed in the prepare phase.](https://github.com/dmitrijs-belovs/Google-Data-Analytics-Capstone-Project-Cyclistic-Case-Study/blob/main/prepare.sql)

## Process

In the process phase, I checked, cleaned and manipulated the data.

#### [Full SQL query executed in the process phase.](https://github.com/dmitrijs-belovs/Google-Data-Analytics-Capstone-Project-Cyclistic-Case-Study/blob/main/process.sql)

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
        - There are 81 station IDs with 2 station names, of which 7 station IDs have multiple names due to inconsistent spelling, for example, Buckingham - Fountain" and "Buckingham Fountain", or "Grace & Cicero" and "Grace St & Cicero Ave", and can be fixed, but the rest have two different station names, which is difficult to fix due to a lack of information and not necessarily needs to be;
        - These 81 station IDs have 378 235 observations, and this amount is too large to be simply removed, as it can affect the analysis of several stations that may contribute to the overall analysis.
    - The second way that I used to check the consistency of the station names was by comparing stations with station information downloaded from the Divvy website and imported as a second table in pgadmin environment:
        - All stations in a newly imported table are unique, and station IDs don't have multiple station names;
        - There are 48 station names in the trip data table that don't have a match in the stations table, of which there are all previously found out station names with spelling inconsistencies, but the rest have minor differences in spelling (for example, not having "St" or "Ave" in one table or another) and don't have similar 'duplicate' values, or simply are not in the stations table;
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

## Analyze and Share

I am combining analyze and share phases because in my case they contain the same information.

In these phases, I created various data visualizations that form a story in Tableau Public, which explores how members and casual riders use Cyclistic bikes differently with various questions:

#### [Full story in Tableau Public created in the analyze and share phases.](https://public.tableau.com/views/GoogleDataAnalyticsCapstoneProjectCyclisticCaseStudy_17219095124900/Strory?:language=en-GB&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

- **How many rides are there, and what is their average length?**

  ![image](https://github.com/user-attachments/assets/315a6f1c-d9ab-43d6-9350-0650653d68dd)

    - There are 4 209 795 total rides of which 63,83% belongs to members and 35,17% belongs to casual riders.
    - The member's average ride length is 12.63 minutes and casual rider's 23.86 minutes.
  
- **How do rides and average ride length change by month?**

  ![image](https://github.com/user-attachments/assets/c39ca3a6-fd28-4d13-baaf-8d06c8f03e23)

    - There are similar trends in ride count change by month for both user types, with the increase in rides starting after winter, peaking in summer, and declining after. However, small differences can also be seen, namely, members start to ride more frequently after winter a little faster, and have a slower decline after summer;
    - Average ride length change by month also has similar increasing tendencies, however, the amount of increase differs significantly for user types: the increase in ride length among casual riders is much larger than among members. Besides that, the causal rider's increase in ride length starts faster and declines slower.

- **How do rides and average ride length change by weekday?**

  ![image](https://github.com/user-attachments/assets/16ade897-8d2e-40cf-8a4d-f9f545b2d085)

    -  Ride count change by weekday also differs by user types: members ride more in the working days and less on weekends, but casual riders ride more on weekends and less on working days. In greater detail, member's rides increase from Monday to Thursday and decrease afterwards, but casual riders ride with approximately the same frequency from Monday to Thursday but start to ride more on Friday and weekends;
    -  Ride length by weekday differs by the fact that for members it remains approximately the same during working days and slightly increases on weekends, but for casual riders it decreases from Monday to Thursday and increases on Friday and weekends.

- **How do rides and average ride length change by hour?**

  ![image](https://github.com/user-attachments/assets/fb30bf5a-0549-4c89-ad38-88d654b1ea0c)

    - Ride count aggregation by hour also opens up differences between members and causal riders. First of all, we see decline during the night for both user types, but for members, the decline ends several hours earlier. Furthermore, members have the spike in rides at about 8 am, which do not have casual riders (or have in a much smaller amount proportionally). Later in the day, there are similar tendencies for both user types: a little spike at about 12 pm and the largest spike at about 5 pm.
    - Ride length by hour tells previously explored differences, namely that ride length for casual riders changes much more. But, besides that, we see that during the day, for members, ride length increases in the evening after 5 pm, but for casual riders, ride length increases during the afternoon.

- **Which start stations are the most popular?**

  ![image](https://github.com/user-attachments/assets/b67ed470-ef60-4e46-9e71-1fdc0cd1585f)

    - Map visualizations of the 20 most popular start stations also show some differences between user types. Members start their rides more near universities, commercial, and residential areas, whereas casual riders start their rides near parks, museums, and other recreational sites.

- **Which end stations are the most popular?**

  ![image](https://github.com/user-attachments/assets/2411c5ef-5163-4e67-9b2c-b16e96bd68e5)

    - The same goes also with end stations: members end their rides more near universities, commercial, and residential areas, and casual riders end their rides near parks, museums, and other recreational sites.

- **How do rides and average ride length differs by rideable type?**

  ![image](https://github.com/user-attachments/assets/ba2f1607-7dac-4252-aa7b-1390fc8f483f)

    - Decomposition of rides by rideable type for user types looks similar, except there is a small amount of docked bike rides among casual riders, and their length is much larger (which can be due to that comparatively small amount of rides).
 
So, all these insights cumulatively reinforce the fact that members and casual riders use Cyclistic bikes for different purposes: 

- Mebmers generally use Cyclistic bikes for shorter rides, they ride more than casual riders during the spring and fall, working days, and peak hours during which people are usually commute to study or work, and they start and end their rides near universities, commercial, and residential areas. Therefore, I can conclude that members generally use Cyclistic bikes more for commuting.
- Casual riders, on the other hand, ride longer, more during the summer, weekends, and later in the day, and they start and end their rides near parks, museums, and other recreational sites. Thus, I can conclude that casual riders generally use Cyclistic bikes for recreational reasons.

## Act

In the act phase, I am suggesting how my data analysis insights can be used in designing marketing strategies aimed at converting casual riders into annual members and what additional data could be used to extend the findings:

- First of all, the insight that 63,83% of total rides belong to members can be used to emphasize that a lot of people have already become Cyclistic members and highlight the convenience and cost savings of annual membership. That way, we can potentially convince those casual riders who are considering using Cyclistic for commuting.
    - For greater accuracy, it would be better to have data on how much there are unique members and casual riders.

- Based on the insights that member rides don't decrease drastically during weekends and their ride length increases during weekends and in the evening after 5 pm, we potentially can tell that members also use Cyclistic bikes for recreational sites and highlight the benefits of using annual membership for that purpose.
    - For greater accuracy, more direct data on the member's purposes of using Cyclistic bikes is needed (e.g. surveys). More direct data on casual riders purposes could help measure the flexebitlty of these users to transtition to annuan plan. Additionally, the data at higher level of detail (e.g. user_id column) and data on pricing could make possible mathematical calculations about potential cost saving benefits of annual membership for casual riders.

- The insights that casual riders ride more during summer, weekends, and start and end their rides near parks, museums, and other recreational sites suggest to implement marketing campaigns during these times and at these places. Partnerships near popular stations can also be established, offering benefits for members.

- The insigths that casual riders ride more during warmer months and for recreational purposes suggest that a new plan for warmer season and recreation can be created and offered to the casual riders.
    - However, this suggestion is an additional option because it doesn't meet the goal of the project to convert casual riders to annual members.
