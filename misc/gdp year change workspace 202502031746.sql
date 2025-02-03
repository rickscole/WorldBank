-- pre drop tables
if object_id('temp.wb_gdp_change_year_pairs_00_00', 'U') is not null
drop table temp.wb_gdp_change_year_pairs_00_00;
if object_id('temp.wb_gdp_change_year_pairs_00', 'U') is not null
drop table temp.wb_gdp_change_year_pairs_00;
if object_id('temp.wb_gdp_change_year_pairs_01', 'U') is not null
drop table temp.wb_gdp_change_year_pairs_01; 
if object_id('temp.wb_gdp_change_year_pairs_02', 'U') is not null
drop table temp.wb_gdp_change_year_pairs_02; 
if object_id('temp.wb_gdp_change_year_pairs_03', 'U') is not null
drop table temp.wb_gdp_change_year_pairs_03; 
if object_id('temp.wb_gdp_change_year_pairs_04', 'U') is not null
drop table temp.wb_gdp_change_year_pairs_04;



/*
truncate table temp.wb_gdp_change_year_pairs_00_00;
truncate table temp.wb_gdp_change_year_pairs_00;
truncate table temp.wb_gdp_change_year_pairs_01;
truncate table temp.wb_gdp_change_year_pairs_02;
truncate table temp.wb_gdp_change_year_pairs_03;
*/


-- base table with gdp data
-- insert into temp.wb_gdp_change_year_pairs_00_00
select
    a.economy
    , gdp = a.value
    , year = a.[time]
into temp.wb_gdp_change_year_pairs_00_00
from wb.economy_time_resource a
where 1 = 1
    and a.resource = 'NY.GDP.MKTP.CD' 


-- total GDP in a country's history
-- insert into temp.wb_gdp_change_year_pairs_00
select 
    a.economy 
    , total_gdp = sum(a.gdp)
    , most_recent_year = max(a.year)
into temp.wb_gdp_change_year_pairs_00
from temp.wb_gdp_change_year_pairs_00_00 a
group by 
    a.economy


-- back to country-year level, how much of country's total historic gdp is accounted for by that year
-- insert into temp.wb_gdp_change_year_pairs_01
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


-- min and max gdp of a given year
-- insert into temp.wb_gdp_change_year_pairs_02
select 
    a.year
    , min_gdp = min(a.gdp)
    , max_gdp = max(a.gdp)
into temp.wb_gdp_change_year_pairs_02
from temp.wb_gdp_change_year_pairs_01 a
where 1 = 1 
    and a.geography_code is not null
    and trim(a.geography_code) != ''
group by
    a.year


-- insert into temp.wb_gdp_change_year_pairs_03
select
    a.economy 
    , start_year = a.year 
    , end_year = b.year 
    , difference_in_years = b.year - a.year 
    , start_gdp = a.gdp 
    , end_gdp = b.gdp 
    -- , gdp_difference = b.gdp - a.gdp 
    -- , start_gdp_percent_by_year = a.gdp_by_year
    -- , end_gdp_percent_by_year = b.gdp_by_year
    -- , change_in_percent_gdp = b.gdp_by_year - a.gdp_by_year
    -- , rate_of_change_in_percent_gdp = b.gdp_by_year / a.gdp_by_year - 1
    , gdp_rate_of_change = cast(b.gdp as float) / cast(a.gdp as float) - 1
    -- , economy_start_year_end_year = concat(a.economy, ', ', a.year, '-', b.year)
    /*
    , start_gdp_normalized = 
        case 
        when a.geography_code is null or trim(a.geography_code) = '' then null
        when c.max_gdp = c.min_gdp then null 
        else (cast(a.gdp as float) - cast(c.min_gdp as float)) / (cast(c.max_gdp as float) - cast(c.min_gdp as float))
    	end
    */
    /*
    , intitial_gdp_group = 
        case 
        when a.gdp <= 100000000 then 'Less than $100 million'
        when a.gdp <= 500000000 then '$100 million to $500 million' 
        when a.gdp <= 1000000000 then '$500 million to $1 billion'
        when a.gdp <= 5000000000 then '$1 billion to $5 billion'
        when a.gdp <= 10000000000 then '$5 billion to $10 billion'
        when a.gdp <= 50000000000 then '$10 billion to $50 billion'
        when a.gdp <= 100000000000 then '$50 billion to $100 billion'
        when a.gdp <= 500000000000 then '$100 billion to $500 billion'
        when a.gdp <= 1000000000000 then '$500 billion to $1 trillion'
        when a.gdp <= 5000000000000 then '$1 trillion to $5 trillion'
        when a.gdp > 5000000000000 then '$50 billion (+)'
        else 'Other'
        end
    */
    -- , a.geography_code
    -- , log_start_gdp = log(a.gdp)
    , is_most_recent_year = case when b.year = d.most_recent_year then 1 else 0 end
into temp.wb_gdp_change_year_pairs_03
from temp.wb_gdp_change_year_pairs_01 a 
inner join temp.wb_gdp_change_year_pairs_01 b on 1 = 1 
    and a.economy = b.economy 
    and a.year < b.year
inner join temp.wb_gdp_change_year_pairs_02 c on a.year = c.year
left join temp.wb_gdp_change_year_pairs_00 d on a.economy = d.economy
where 1 = 1
    and (b.year - a.year) in (2, 4, 8, 16, 32)


select 
    a.economy
    , a.difference_in_years 
    , min_gdp_rate_of_change = min(a.gdp_rate_of_change)
    , max_gdp_rate_of_change = max(a.gdp_rate_of_change)
into temp.wb_gdp_change_year_pairs_04
from temp.wb_gdp_change_year_pairs_03 a
group by 
    a.economy
    , a.difference_in_years 


select a.*
-- , d.geography_code
from temp.wb_gdp_change_year_pairs_03 a 
left join temp.wb_gdp_change_year_pairs_04 b on a.economy = b.economy and a.difference_in_years = b.difference_in_years and a.gdp_rate_of_change = b.min_gdp_rate_of_change
left join temp.wb_gdp_change_year_pairs_04 c on a.economy = c.economy and a.difference_in_years = c.difference_in_years and a.gdp_rate_of_change = c.min_gdp_rate_of_change
where 1 = 1
    and 
    (
        1 = 0
        or b.economy is not null
        or c.economy is not null
        or a.is_most_recent_year = 1
    )
    -- and a.economy = 'United States'
/*
select 
from (select distinct economy, difference_in_years from temp.wb_gdp_change_year_pairs_03) a 
left join 
*/


-- select * from temp.wb_gdp_change_year_pairs_03 
-- where difference_in_years in (2, 4, 8, 16, 32)
-- select distinct difference_in_years from temp.wb_gdp_change_year_pairs_03;

/*
truncate table temp.wb_gdp_change_year_pairs_00_00;
truncate table temp.wb_gdp_change_year_pairs_00;
truncate table temp.wb_gdp_change_year_pairs_01;
truncate table temp.wb_gdp_change_year_pairs_02;
truncate table temp.wb_gdp_change_year_pairs_03;
*/


-- post drop tables
if object_id('temp.wb_gdp_change_year_pairs_00_00', 'U') is not null
drop table temp.wb_gdp_change_year_pairs_00_00;
if object_id('temp.wb_gdp_change_year_pairs_00', 'U') is not null
drop table temp.wb_gdp_change_year_pairs_00; 
if object_id('temp.wb_gdp_change_year_pairs_01', 'U') is not null
drop table temp.wb_gdp_change_year_pairs_01; 
if object_id('temp.wb_gdp_change_year_pairs_02', 'U') is not null
drop table temp.wb_gdp_change_year_pairs_02; 
if object_id('temp.wb_gdp_change_year_pairs_03', 'U') is not null
drop table temp.wb_gdp_change_year_pairs_03; 
if object_id('temp.wb_gdp_change_year_pairs_04', 'U') is not null
drop table temp.wb_gdp_change_year_pairs_04;
