use heartattack;
select * from medicaldataset limit 100;
describe medicaldataset;

################################################################################################################
##########################COUNT OF THE NUMBER OF REGISTERS##############################
#AMOUNT OF REGISTERS OF THE DATASET
select 'Registers',count(*) as amount from medicaldataset;
# THERE ARE MORE REGISTERS OF MEN OR WOMEN?
select 'Men', count(*) as amount from medicaldataset where gender=1 union all select 'Women',count(*) as amount from medicaldataset where gender=0;
# THERE ARE MORE NEGATIVE OR POSITIVE REGISTERS?
select 'Positive',count(*) as amount from medicaldataset where result='positive' union all select 'Negative',count(*) as amount from medicaldataset where result='negative';

#### ELIMINATING OUTLIER VALUES
#THE HEART RATE LIMIT FOR A HUMAN BODY IS 300 BEATS PER MINUTE
#With the following query we can see 4 values ​​that are impossible for the human body; there are values ​​of 1111 BPM.
select `Heart rate` from medicaldataset where `Heart rate` > 300;
delete from medicaldataset where `Heart rate` > 300;

#400mmHG IS THE PHYSIOLOGICAL LIMIT OF THE BODY
select `Systolic blood pressure` from medicaldataset where `Systolic blood pressure`>400;

#160mmHG IS THE PHSYSIOLOGICAL LIMIT OF THE BODY
select `Diastolic blood pressure` from medicaldataset where `Diastolic blood pressure` > 160;

#A BLOOD SUGAR LEVEL ABOVE 600 IS RARE AND INDICATES SERIOUS PROBLEMS.
select `Blood sugar` from medicaldataset where `Blood sugar`>=600;

#CK-MB OVER 400 IS RARE
select `CK-MB` from medicaldataset where `CK-MB` > 400;


#QUANTITY OF REGISTERS BY AGES: THERE ARE MORE REGISTERS OF PACIENTS OVER 50 YEARS OLD.
with age as(
	SELECT 
    CASE 
        WHEN age < 30 THEN 'Under 30 years old'
        WHEN age BETWEEN 30 AND 50 THEN 'Between 30-50 years old'
        ELSE 'Over 50 years old'
    END AS range_age,
    COUNT(*) AS amount
FROM medicaldataset
GROUP BY range_age
)
select * from age;

# AMONG OF REGISTERS BY EACH COLUMN: THERE ARE MORE REGISTERS OF NORMAL HEART RATE THAN OTHER
with amount_heart as (
	select case
		when `Heart rate` between 60 and 100 then 'Normal'
        when `Heart rate` < 60 then 'Low'
        when `Heart rate` > 100 then 'High'
	end as heart_rate, count(*) as amount from medicaldataset group by heart_rate
)
select * from amount_heart;

# RECORDS OF SYSTOLIC BLOOD PRESSURE: THERE ARE MORE REGISTERS OF HIGH SYSTOLIC BLOOD PRESSURE
with systolic as(
	select case
		when `Systolic blood pressure` between 90 and 120 then 'Normal'
        when `Systolic blood pressure` < 90 then 'Low'
        when `Systolic blood pressure` > 90 then 'High'
	end as systolic_pressure, count(*) as amount from medicaldataset group by systolic_pressure
)
select * from systolic;

# RECORDS OF DIASTOLIC BLOOD PRESSURE: THERE ARE MORE REGISTERS OF NORMAL DIASTOLIC BLOOD PRESSURE
with diastolic as(
	select case
		when `Diastolic blood pressure` between 60 and 80 then 'Normal'
        when `Diastolic blood pressure` < 60 then 'Low'
        when `Diastolic blood pressure` > 80 then 'High'
	end as diastolic_pressure,count(*) as amount from medicaldataset group by diastolic_pressure
)
select * from diastolic;

# RECORDS OF BLOOD SUGAR LEVEL: THERE ARE MORE REGISTERS OF EXTREMLY HIGH BLOOD SUGAR LEVELS
with sugar as(
	select case
		when `Blood sugar` between 70 and 100 then 'Normal'
        when `Blood sugar` < 70 then 'Low'
        when `Blood sugar` between 100 and 125 then 'High'
        else 'Extremely high'
	end as blood_sugar, count(*) as amount from medicaldataset group by blood_sugar
)
select * from sugar;

# RECORDS OF CK-MB: THERE ARE MORE REGISTERS OF NORMAL CK-MB LEVELS
with ckmb as(
	select case
		when `CK-MB` < 5 then 'Low or Normal'
        when `CK-MB` > 5 then 'High'
	end as ck_mb, count(*) as amount from medicaldataset group by ck_mb
)
select * from ckmb;

#RECORDS OF TROPONIN: THERE ARE TIE BETWEEN NORMAL AND SLIGHTLY HIGH TROPONIN LEVELS
with troponin as (
	select case
		when troponin < 0.014 then 'Normal or Low'
        when troponin > 0.014 then 'Slightly high'
        else 'High'
	end as troponin_messure,count(*) as amount from medicaldataset group by troponin_messure
)
select * from troponin;


################################################################################################################
###############################OBTAINING AVERAGE,MAX AND MIN VALUES OF THE DATASET##############################
##################AVERAGE################
#SHOW THE AVERAGE IN THE DIFFERENT VARIABLES
with average as(
	select 'Age',round(avg(age),3) Average from medicaldataset union all select 'Heart rate',round(avg(`Heart rate`),3) from medicaldataset union all
	select 'Systolic blood pressure', round(avg(`Systolic blood pressure`),3) from medicaldataset union all select 'Diastolic blood pressure', round(avg(`Diastolic blood pressure`),3) from medicaldataset union all
	select 'Blood sugar',round(avg(`Blood sugar`),3) from medicaldataset union all select 'CK-MB',round(avg(`CK-MB`),3) from medicaldataset union all select 'Troponin',round(avg(Troponin),3) from medicaldataset
    order by Average desc
)
select * from average;

with average_men as(
	select 'Age',round(avg(age),3) Average from medicaldataset where gender=1 union all select 'Heart rate',round(avg(`Heart rate`),3) from medicaldataset where gender=1 union all
	select 'Systolic blood pressure', round(avg(`Systolic blood pressure`),3) from medicaldataset where gender=1 union all select 'Diastolic blood pressure', round(avg(`Diastolic blood pressure`),3) from medicaldataset where gender=1 union all
	select 'Blood sugar',round(avg(`Blood sugar`),3) from medicaldataset where gender=1 union all select 'CK-MB',round(avg(`CK-MB`),3) from medicaldataset where gender=1 union all select 'Troponin',round(avg(Troponin),3) from medicaldataset where gender=1
)
select * from average_men;

with average_women as (
	select 'Age',round(avg(age),3) Average from medicaldataset where gender=0 union all select 'Heart rate',round(avg(`Heart rate`),3) from medicaldataset where gender=0 union all
	select 'Systolic blood pressure', round(avg(`Systolic blood pressure`),3) from medicaldataset where gender=0 union all select 'Diastolic blood pressure', round(avg(`Diastolic blood pressure`),3) from medicaldataset where gender=0 union all
	select 'Blood sugar',round(avg(`Blood sugar`),3) from medicaldataset where gender=0 union all select 'CK-MB',round(avg(`CK-MB`),3) from medicaldataset where gender=0 union all select 'Troponin',round(avg(Troponin),3) from medicaldataset where gender=0
)
select * from average_women;

##################MAX VALUES################
#SHOW THE MAX VALUES IN THE DIFFERENT VALUES
with max_values as (
	select 'Age',max(age) Average from medicaldataset union all select 'Heart rate',max(`Heart rate`) from medicaldataset union all
	select 'Systolic blood pressure', max(`Systolic blood pressure`) from medicaldataset union all select 'Diastolic blood pressure', max(`Diastolic blood pressure`) from medicaldataset union all
	select 'Blood sugar',max(`Blood sugar`) from medicaldataset union all select 'CK-MB',max(`CK-MB`) from medicaldataset union all select 'Troponin',max(Troponin) from medicaldataset
)
select * from max_values;

with max_men as (
	select 'Age',max(age) Average from medicaldataset where gender=1 union all select 'Heart rate',max(`Heart rate`) from medicaldataset where gender=1 union all
	select 'Systolic blood pressure', max(`Systolic blood pressure`) from medicaldataset where gender=1 union all select 'Diastolic blood pressure', max(`Diastolic blood pressure`) from medicaldataset where gender=1 union all
	select 'Blood sugar',max(`Blood sugar`) from medicaldataset where gender=1 union all select 'CK-MB',max(`CK-MB`) from medicaldataset where gender=1 union all select 'Troponin',max(Troponin) from medicaldataset where gender=1
)
select * from max_men;

with max_women as (
	select 'Age',max(age) Average from medicaldataset where gender=0 union all select 'Heart rate',max(`Heart rate`) from medicaldataset where gender=0 union all
	select 'Systolic blood pressure', max(`Systolic blood pressure`) from medicaldataset where gender=0 union all select 'Diastolic blood pressure', max(`Diastolic blood pressure`) from medicaldataset where gender=0 union all
	select 'Blood sugar',max(`Blood sugar`) from medicaldataset where gender=0 union all select 'CK-MB',max(`CK-MB`) from medicaldataset where gender=0 union all select 'Troponin',max(Troponin) from medicaldataset where gender=0
)
select * from max_women;



##################MIN VALUES################
#SHOW THE MIN VALUES IN THE DIFFERENT VARIABLES
with min_values as(
	select 'Age',min(age) Average from medicaldataset union all select 'Heart rate',min(`Heart rate`) from medicaldataset union all
	select 'Systolic blood pressure', min(`Systolic blood pressure`) from medicaldataset union all select 'Diastolic blood pressure', min(`Diastolic blood pressure`) from medicaldataset union all
	select 'Blood sugar',min(`Blood sugar`) from medicaldataset union all select 'CK-MB',min(`CK-MB`) from medicaldataset union all select 'Troponin',min(Troponin) from medicaldataset
)
select * from min_values;

with min_men as(
	select 'Age',min(age) Average from medicaldataset where gender=1 union all select 'Heart rate',min(`Heart rate`) from medicaldataset where gender=1 union all
	select 'Systolic blood pressure', min(`Systolic blood pressure`) from medicaldataset where gender=1 union all select 'Diastolic blood pressure', min(`Diastolic blood pressure`) from medicaldataset where gender=1 union all
	select 'Blood sugar',min(`Blood sugar`) from medicaldataset where gender=1 union all select 'CK-MB',min(`CK-MB`) from medicaldataset where gender=1 union all select 'Troponin',min(Troponin) from medicaldataset where gender=1
)
select * from min_men;

with min_women as(
	select 'Age',min(age) Average from medicaldataset where gender=0 union all select 'Heart rate',min(`Heart rate`) from medicaldataset where gender=0 union all
	select 'Systolic blood pressure', min(`Systolic blood pressure`) from medicaldataset where gender=0 union all select 'Diastolic blood pressure', min(`Diastolic blood pressure`) from medicaldataset where gender=0 union all
	select 'Blood sugar',min(`Blood sugar`) from medicaldataset where gender=0 union all select 'CK-MB',min(`CK-MB`) from medicaldataset where gender=0 union all select 'Troponin',min(Troponin) from medicaldataset where gender=0
)
select * from min_women;
################################################################################################################

################################################################################################################
###############################OBTAINING UNIQUE VALUES OF THE DIFFERENT COLUMNS##############################
select age,count(age) as conteo from medicaldataset group by age order by conteo desc;
select gender, count(gender) as conteo from medicaldataset group by gender order by conteo desc;
select `Heart rate`,count(`Heart rate`) as conteo from medicaldataset group by `Heart rate` order by conteo desc;
select `Systolic blood pressure`, count(`Systolic blood pressure`) as conteo from medicaldataset group by `Systolic blood pressure` order by conteo desc;
select `Diastolic blood pressure`, count(`Diastolic blood pressure`) as conteo from medicaldataset group by `Diastolic blood pressure` order by conteo desc;
select `Blood sugar`,count(`Blood sugar`) as conteo from medicaldataset group by `Blood sugar` order by conteo desc;
select result, count(result) as conteo from medicaldataset group by result order by conteo desc;
################################################################################################################

################################################################################################################
#####################################OBTAINING NULL VALUES #######################################
with null_values as (
	select 'Age',sum(age is null) as nulos from medicaldataset union all select 'Gender', sum(gender is null) from medicaldataset union all
	select 'Heart rate', sum(`Heart rate` is null) from medicaldataset union all select 'Systolic blood pressure', sum(`Systolic blood pressure` is null) from medicaldataset union all
	select 'Diastolic blood pressure', sum(`Diastolic blood pressure` is null) from medicaldataset union all select 'Blood sugar',sum(`Blood sugar` is null) from medicaldataset union all
	select 'CK-MB', sum(`CK-MB` is null) from medicaldataset union all select 'Troponin',sum(troponin is null) from medicaldataset union all select 'Result',sum(result is null) from medicaldataset
)
select * from null_values;

################################################################################################
########################AVERAGE OF VARIABLES IN POSITIVE AND NEGATIVE RESULTS###################
#RESULTS FOR EACH VARIABLE ACCORDING TO DIFFERENT AGES
with age_avg as (
	select case 
		when age < 30 then 'Under 30'
		when age between 30 and 50 then 'Between 30 and 50'
		else 'Over 50'
	end as range_age, sum(if(gender=1,1,0)) as 'Men',sum(if(gender=0,1,0)) as 'Women',sum(if(result='positive',1,0)) as positive_cases, sum(if(result='negative',1,0)) as negative_cases,
    round(avg(`Heart rate`),2) as heart_rate,round(avg(`Systolic blood pressure`),2) as systolic_pressure,round(avg(`Diastolic blood pressure`),2) as diastolic_pressure,
    round(avg(`Blood sugar`),2) as blood_sugar,round(avg(`CK-MB`),2) as ck_mb,round(avg(troponin),2) as troponin from medicaldataset group by range_age
)
select * from age_avg;

#RESULTS FOR EACH VARIABLE ACCORDING TO DIFFERENT SEX
with sex_values as (
	select case
		when gender=1 then 'Men'
        when gender=0 then 'Women'
	end as sex, round(avg(`Heart rate`),2) as heart_rate, round(avg(`Systolic blood pressure`),2) as systolic_pressure,round(avg(`Diastolic blood pressure`),2) as diastolic_pressure,
    round(avg(`Blood sugar`),2) as blood_sugar, round(avg(`CK-MB`),2) as ck_mb,round(avg(troponin),2) as troponin, sum(if(result='positive',1,0)) as positive_cases,
    sum(if(result='negative',1,0)) as negative_cases from medicaldataset group by sex
)
select * from sex_values;

#RESULTS FOR EACH VARIABLE ACCORDING TO DIFFERENT RANGES OF HEART RATE 
with heart_rate as (
	select case
		when `Heart rate` between 60 and 100 then 'Normal'
        when `Heart rate` < 60 then 'Low'
        when `Heart rate` > 100 then 'High'
	end as heart, round(avg(`Systolic blood pressure`),2) as systolic_pressure,round(avg(`Diastolic blood pressure`),2) as diastolic_pressure,round(avg(`Blood sugar`),2) as blood_sugar,
    round(avg(`CK-MB`),2) as ck_mb, round(avg(troponin),2) as troponin, sum(if(result='positive',1,0)) as positive_cases, sum(if(result='negative',1,0)) as negative_cases
    from medicaldataset group by heart		
)
select * from heart_rate;

#RESULTS FOR EACH VARIABLE ACCORDING TO DIFFERENT RANGES OF SYSTOLIC BLOOD PRESSURE
with systolic_pressure as (
	select case
		when `Systolic blood pressure` between 90 and 120 then 'Normal'
        when `Systolic blood pressure` < 90 then 'Low'
        when `Systolic blood pressure` > 90 then 'High'
	end as systolic,round(avg(`Diastolic blood pressure`),2) as diastolic_pressure, round(avg(`Blood sugar`),2) as blood_sugar, round(avg(`CK-MB`),2) as ck_mb,round(avg(troponin),2) as troponin,
    sum(if(result='positive',1,0)) as positive_cases,sum(if(result='negative',1,0)) as negative_cases from medicaldataset group by systolic
)
select * from systolic_pressure;

#RESULTS FOR EACH VARIABLE ACCORDING TO DIFFERENT RANGES OF DIASTOLIC BLOOD PRESSURE
with diastolic_pressure as(
	select case
		when `Diastolic blood pressure` between 60 and 80 then 'Normal'
        when `Diastolic blood pressure` < 60 then 'Low'
        when `Diastolic blood pressure` > 80 then 'High'
	end as diastolic,round(avg(`Blood sugar`),2) as blood_sugar,round(avg(`CK-MB`),2) as ck_mb,round(avg(troponin),2) as troponin,
    sum(if(result='positive',1,0)) as positive_cases,sum(if(result='negative',1,0)) as negative_cases from medicaldataset 
    group by diastolic
)
select * from diastolic_pressure;

#RESULTS FOR EACH VARIABLE ACCORDING TO DIFFERENT RANGES OF CK-MB
with ck_mb as(
	select case
		when `CK-MB` < 5 then 'Low or Normal'
        when `CK-MB` > 5 then 'High'
	end as ckmb,round(avg(troponin),2) as troponin ,sum(if(result='positive',1,0)) as positive_cases,sum(if(result='negative',1,0)) as negative_cases from medicaldataset group by ckmb
)
select * from ck_mb;



#POSITIVE AND NEGATIVE CASES ACCORDING TO DIFFERENT AGE RANGES
with age_result as (
	SELECT 
    CASE 
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'
    END AS range_age,
    SUM(CASE WHEN result = 'positive' THEN 1 ELSE 0 END) AS positive_count,
    SUM(CASE WHEN result = 'negative' THEN 1 ELSE 0 END) AS negative_count,
    COUNT(*) AS total_per_range FROM medicaldataset GROUP BY range_age ORDER BY MIN(age)
)
select * from age_result;

#POSITIVE AND NEGATIVE CASES ACCORDING TO DIFFERENT SEX
with sex_result as (
	select case
		when gender=1 then 'Men'
        when gender=0 then 'Women'
	end as sex, sum(if(result='positive',1,0)) as positive, sum(if(result='negative',1,0)) as negative,
    count(*) as total_per_range from medicaldataset
    group by sex
)
select * from sex_result;

#POSITIVE AND NEGATIVE CASES ACCORDING TO DIFFERENT HEART RATE RANGES
with heartrate_result as (
	select case
		when `Heart rate` between 60 and 100 then 'Normal'
        when `Heart rate` < 60 then 'Low'
        when `Heart rate` > 100 then 'High'
	end as heart_rate, sum(if(result='positive',1,0)) as positive,sum(if(result='negative',1,0)) as negative,
    count(*) as total_per_range from medicaldataset
    group by heart_rate
)
select * from heartrate_result;

#POSITIVE AND NEGATIVE CASES ACCORDING TO DIFFERENT SYSTOLIC BLOOD PRESSURE RANGES
with systolic_result as (
	select case
		when `Systolic blood pressure` between 90 and 120 then 'Normal'
        when `Systolic blood pressure` < 90 then 'Low'
        when `Systolic blood pressure` > 90 then 'High'
	end as systolic_pressure, sum(if(result='positive',1,0)) as positive,sum(if(result='negative',1,0)) as negative,
    count(*) as total_per_range from medicaldataset group by systolic_pressure
)
select * from systolic_result;

#POSITIVE AND NEGATIVE CASES ACCORDING TO DIFFERENT DISTOLIC BLOOD PRESSURE RANGES 
with diastolic_result as(
	select case
		when `Diastolic blood pressure` between 60 and 80 then 'Normal'
        when `Diastolic blood pressure` < 60 then 'Low'
        when `Diastolic blood pressure` > 80 then 'High'
	end as diastolic_pressure,sum(if(result='positive',1,0)) as positive,sum(if(result='negative',1,0)) as negative,
    count(*) as total_per_range from medicaldataset group by diastolic_pressure
)
select * from diastolic_result;

#POSITIVE AND NEGATIVE CASES ACCORDING TO DIFFERENT BLOOD SUGAR RANGES
with sugar_result as(
	select case
		when `Blood sugar` between 70 and 100 then 'Normal'
        when `Blood sugar` < 70 then 'Low'
        when `Blood sugar` between 100 and 125 then 'High'
        else 'Extremely high'
	end as blood_sugar, sum(if(result='positive',1,0)) as positive,sum(if(result='negative',1,0)) as negative,
    count(*) as total_per_range from medicaldataset group by blood_sugar
)
select * from sugar_result;

#POSITIVE AND NEGATIVE CASES ACCORDING TO DIFFERENT CK-MB RANGES 
with ckmb_result as(
	select case
		when `CK-MB` < 5 then 'Low or Normal'
        when `CK-MB` > 5 then 'High'
	end as ck_mb, sum(if(result='positive',1,0)) as positive,sum(if(result='negative',1,0)) as negative,
    count(*) as total_per_range from medicaldataset group by ck_mb
)
select * from ckmb_result;

#POSITIVE AND NEGATIVE CASES ACCORDING TO DIFFERENT TROPONIN RANGES
with troponin_result as (
	select case
		when troponin < 0.014 then 'Normal or Low'
        when troponin > 0.014 then 'Slightly high'
        else 'High'
	end as troponin_messure,sum(if(result='positive',1,0)) as positive,sum(if(result='negative',1,0)) as negative,
    count(*) as total_per_range from medicaldataset group by troponin_messure
)
select * from troponin_result;








