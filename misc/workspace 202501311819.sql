
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


/*
create procedure wb.create_economy_resource_highlight as

-- pre drop tables
if object_id('temp.wb_economy_resource_00', 'U') is not null
drop table temp.wb_economy_resource_00; 
if object_id('temp.wb_economy_resource_01', 'U') is not null
drop table temp.wb_economy_resource_01; 
if object_id('temp.wb_economy_resource_02', 'U') is not null
drop table temp.wb_economy_resource_02; 
if object_id('temp.wb_economy_resource_03', 'U') is not null
drop table temp.wb_economy_resource_03; 
if object_id('temp.wb_economy_resource_04', 'U') is not null
drop table temp.wb_economy_resource_04; 
if object_id('temp.wb_economy_resource_05', 'U') is not null
drop table temp.wb_economy_resource_05; 
if object_id('wb.economy_resource_highlight', 'U') is not null
drop table wb.economy_resource_highlight; 


-- data agged to economy level to get most recent, highest, lowest, etc.
select
    a.economy
    , a.resource
    , number_of_observations = count(*)
    , most_recent_year = max(a.time)
    , min_value = min(a.value)
    , max_value = max(a.value)
into temp.wb_economy_resource_00
from wb.economy_time_resource a 
group by
    a.economy 
    , a.resource

-- year-value with most recent value
select
    a.economy
    , a.resource
    , most_recent_year = a.time
    , most_recent_value = a.value
into temp.wb_economy_resource_01
from wb.economy_time_resource a 
inner join temp.wb_economy_resource_00 b on 1 = 1
    and a.economy = b.economy 
    and a.resource = b.resource
    and a.time = b.most_recent_year


-- year-value with min value
select
    a.economy
    , a.resource
    , year_with_min_value = a.time
    , min_value = a.value
into temp.wb_economy_resource_02
from wb.economy_time_resource a 
inner join temp.wb_economy_resource_00 b on 1 = 1 
    and a.economy = b.economy 
    and a.resource = b.resource
    and a.value = b.min_value


-- eliminate / account for those with multiple minima
select 
    a.economy
    , a.resource
    , year_with_min_value = max(a.year_with_min_value) -- most recent year with min value
    , min_value = max(a.min_value) -- pro forma
    , number_of_min_observations = count(*)
into temp.wb_economy_resource_03
from temp.wb_economy_resource_02 a
group by 
    a.economy
    , a.resource


-- year-value with max value
select
    a.economy
    , a.resource
    , year_with_max_value = a.time
    , max_value = a.value
into temp.wb_economy_resource_04
from wb.economy_time_resource a 
inner join temp.wb_economy_resource_00 b on 1 = 1
    and a.economy = b.economy 
    and a.resource = b.resource 
    and a.value = b.max_value


-- eliminate / account for those with multiple maxima
select 
    a.economy
    , a.resource
    , year_with_max_value = max(a.year_with_max_value) -- most recent year with max value
    , max_value = max(a.max_value) -- pro forma
    , number_of_max_observations = count(*)
into temp.wb_economy_resource_05
from temp.wb_economy_resource_04 a
group by 
    a.economy
    , a.resource


-- join different metrics and select into table
select  
    a.economy
    , a.resource
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
into wb.economy_resource_highlight 
from (select distinct economy, resource from temp.wb_economy_resource_00) a 
left join temp.wb_economy_resource_01 b on a.economy = b.economy and a.resource = b.resource
left join temp.wb_economy_resource_03 c on a.economy = c.economy and a.resource = b.resource
left join temp.wb_economy_resource_05 d on a.economy = d.economy and a.resource = b.resource


-- post drop tables
if object_id('temp.wb_economy_resource_00', 'U') is not null
drop table temp.wb_economy_resource_00; 
if object_id('temp.wb_economy_resource_01', 'U') is not null
drop table temp.wb_economy_resource_01; 
if object_id('temp.wb_economy_resource_02', 'U') is not null
drop table temp.wb_economy_resource_02; 
if object_id('temp.wb_economy_resource_03', 'U') is not null
drop table temp.wb_economy_resource_03; 
if object_id('temp.wb_economy_resource_04', 'U') is not null
drop table temp.wb_economy_resource_04; 
-- if object_id('temp.wb_economy_resource_05', 'U') is not null
-- drop table temp.wb_economy_resource_05;
*/


alter view wb.economy_resource_highlight_bi as 
select a.* 
, b.geography_code 
, b.income_code
, min_value_percent_off_most_recent = case when a.most_recent_value is null then null else a.min_value / a.most_recent_value - 1 end
, max_value_percent_off_most_recent = case when a.most_recent_value is null then null else a.max_value / a.most_recent_value - 1 end
, min_difference_from_most_recent = a.min_value - a.most_recent_value
, max_diference_from_most_recent = a.max_value - a.most_recent_value
, years_since_min_value = a.most_recent_year - a.year_with_min_value
, years_since_max_value = a.most_recent_year - a.year_with_max_value
, does_economy_have_multiple_minima_verbose = case when a.does_economy_have_multiple_minima = 1 then 'Yes' else 'No' end
, does_economy_have_multiple_maxima_verbose = case when a.does_economy_have_multiple_maxima = 1 then 'Yes' else 'No' end
from wb.economy_resource_highlight a 
left join [WB].[clean_country_name_translation] b on a.economy = b.name

-- select * from [WB].[clean_country_name_translation]
-- select * from wb.economy_resource_highlight_bi

