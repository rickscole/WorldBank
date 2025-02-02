-- pre drop tables
if object_id('temp.wb_gdp_change_year_pairs_00_00', 'U') is not null
drop table temp.wb_gdp_change_year_pairs_00_00;
if object_id('temp.wb_gdp_change_year_pairs_00', 'U') is not null
drop table temp.wb_gdp_change_year_pairs_00;
if object_id('temp.wb_gdp_change_year_pairs_01', 'U') is not null
drop table temp.wb_gdp_change_year_pairs_01; 


-- base table with gdp data
select
    a.economy
    , gdp = a.value
    , year = a.[time]
into temp.wb_gdp_change_year_pairs_00_00
from wb.economy_time_resource a
where 1 = 1
    and a.resource = 'NY.GDP.MKTP.CD' 


-- total GDP in a country's history
select 
    a.economy 
    , total_gdp = sum(a.gdp)
into temp.wb_gdp_change_year_pairs_00
from temp.wb_gdp_change_year_pairs_00_00 a
group by 
    a.economy


-- back to country-year level, how much of country's total historic gdp is accounted for by that year
select
    a.economy
    , a.year 
    , c.geography_code
    , c.income_code
    , a.gdp 
    , gdp_by_year = cast(a.GDP as float)/ cast(b.total_gdp as float)
into temp.wb_gdp_change_year_pairs_01
from temp.wb_gdp_change_year_pairs_00_00 a 
inner join temp.wb_gdp_change_year_pairs_00 b on a.economy = b.economy 
left join [WB].[clean_country_name_translation] c on a.economy = c.name


select
    a.economy 
    , start_year = a.year 
    , end_year = b.year 
    , difference_in_years = b.year - a.year 
    , start_gdp = a.gdp 
    , end_gdp = b.gdp 
    , gdp_difference = b.gdp - a.gdp 
    , start_gdp_percent_by_year = a.gdp_by_year
    , end_gdp_percent_by_year = b.gdp_by_year
    , change_in_percent_gdp = b.gdp_by_year - a.gdp_by_year
    , rate_of_change_in_percent_gdp = b.gdp_by_year / a.gdp_by_year - 1
    , gdp_rate_of_change = cast(b.gdp as float) / cast(a.gdp as float) - 1
from temp.wb_gdp_change_year_pairs_01 a 
inner join temp.wb_gdp_change_year_pairs_01 b on 1 = 1 
    and a.economy = b.economy 
    and a.year < b.year
where 1 = 1
    and b.year - a.year <= 20


/*
select
a.Country
, [Start Year] = a.year
, [End Year] = b.year
, [Difference in Years] = b.year - a.year
, [Start GDP] = a.[GDP]
, [End GDP] =  b.[GDP]
, [GDP Difference] = b.GDP - a.GDP
, [Start GDP % by Year] = a.[GDP % by Year]
, [End GDP % by Year] =  b.[GDP % by Year]
, [Change in % GDP] = b.[GDP % by Year] - a.[GDP % by Year]
, [Rate of Change in % GDP] = b.[GDP % by Year] / a.[GDP % by Year] - 1
, [GDP Rate of Change] = cast(b.GDP as float) / cast(a.GDP as float) - 1
from WB.VW_GDPPecentYear a
inner join WB.VW_GDPPecentYear b
on a.Country = b.Country
and a.year < b.year
where a.GeographyCode != ''
*/



-- post drop tables
if object_id('temp.wb_gdp_change_year_pairs_00_00', 'U') is not null
drop table temp.wb_gdp_change_year_pairs_00_00;
if object_id('temp.wb_gdp_change_year_pairs_00', 'U') is not null
drop table temp.wb_gdp_change_year_pairs_00; 
if object_id('temp.wb_gdp_change_year_pairs_01', 'U') is not null
drop table temp.wb_gdp_change_year_pairs_01; 
