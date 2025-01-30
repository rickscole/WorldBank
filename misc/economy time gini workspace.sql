
/*
select * into 
temp.wb_gini_data
from [WB].[TBL_ValueEconomyTimeResource] where Resource = 'SI.POV.GINI'
*/

/*
select * from temp.wb_gini_data where economy = 'USA'


select distinct economy from temp.wb_gini_data

select * from wb.TBL_CountryNames_ARCGIS
select * from wb.TBL_CountryNameTranslations
from 
*/

/*
alter procedure wb.create_economy_time_gini as 

-- drop table if exists
if object_id('wb.economy_time_gini', 'U') is not null
drop table wb.economy_time_gini; 


-- create table
select 
    economy = cnt.name 
    , time = vert.time 
    , value = vert.value 
into wb.economy_time_gini
from [WB].[TBL_ValueEconomyTimeResource] vert
left join wb.clean_country_name_translation cnt on vert.economy = cnt.code 
where 1 = 1
    and vert.resource = 'SI.POV.GINI'
    and vert.value is not null
*/



-- drop table if exists
if object_id('temp.wb_economy_gini_00', 'U') is not null
drop table temp.wb_economy_gini_00; 
if object_id('temp.wb_economy_gini_01', 'U') is not null
drop table temp.wb_economy_gini_01; 
if object_id('temp.wb_economy_gini_02', 'U') is not null
drop table temp.wb_economy_gini_02; 
if object_id('temp.wb_economy_gini_03', 'U') is not null
drop table temp.wb_economy_gini_03; 
if object_id('temp.wb_economy_gini_04', 'U') is not null
drop table temp.wb_economy_gini_04; 
if object_id('temp.wb_economy_gini_05', 'U') is not null
drop table temp.wb_economy_gini_05; 


-- data agged to economy level to get most recent, highest, lowest, etc.
select
    a.economy
    , number_of_observations = count(*)
    , most_recent_year = max(a.time)
    , min_value = min(a.value)
    , max_value = max(a.value)
into temp.wb_economy_gini_00
from wb.economy_time_gini a 
group by
    a.economy 


-- year-value with most recent gini
select
    a.economy
    , most_recent_year = a.time
    , most_recent_value = a.value
into temp.wb_economy_gini_01
from wb.economy_time_gini a 
inner join temp.wb_economy_gini_00 b on a.economy = b.economy and a.time = b.most_recent_year


-- year-value with min gini
select
    a.economy
    , year_with_min_value = a.time
    , min_value = a.value
into temp.wb_economy_gini_02
from wb.economy_time_gini a 
inner join temp.wb_economy_gini_00 b on a.economy = b.economy and a.value = b.min_value


-- eliminate / account for those with multiple minima
select 
    a.economy
    , year_with_min_value = max(a.year_with_min_value) -- most recent year with min value
    , min_value = max(a.min_value) -- pro forma
    , number_of_min_observations = count(*)
into temp.wb_economy_gini_03
from temp.wb_economy_gini_02 a
group by 
    a.economy


-- year-value with max gini
select
    a.economy
    , year_with_max_value = a.time
    , max_value = a.value
into temp.wb_economy_gini_04
from wb.economy_time_gini a 
inner join temp.wb_economy_gini_00 b on a.economy = b.economy and a.value = b.max_value


-- eliminate / account for those with multiple maxima
select 
    a.economy
    , year_with_max_value = max(a.year_with_max_value) -- most recent year with max value
    , max_value = max(a.max_value) -- pro forma
    , number_of_max_observations = count(*)
into temp.wb_economy_gini_05
from temp.wb_economy_gini_04 a
group by 
    a.economy


select  
    a.economy
    , b.most_recent_year
    , b.most_recent_value
    , c.year_with_min_value
    , c.min_value
    , c.number_of_min_observations
    , does_economy_have_multiple_minima = case when c.number_of_min_observations > 1 then 1 else 0 end
    , d.year_with_max_value
    , d.max_value
    , d.number_of_max_observations
    , does_economy_have_multiple_maxima = case when d.number_of_max_observations > 1 then 1 else 0 end 
from (select distinct economy from temp.wb_economy_gini_00) a 
left join temp.wb_economy_gini_01 b on a.economy = b.economy
left join temp.wb_economy_gini_03 c on a.economy = c.economy
left join temp.wb_economy_gini_05 d on a.economy = d.economy


-- select economy, count(*) from temp.wb_economy_gini_02 group by economy having count(*) > 1
-- select * from temp.wb_economy_gini_02 where economy = 'Croatia'


/*
-- year with most recent gini
select
    a.economy
    , max_gini = max(a.value)
into temp.wb_economy_gini_02
from wb.economy_time_gini a 
group by
    a.economy 
*/

