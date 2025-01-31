

-- pre drop tables
if object_id('temp.wb_gdp_change_year_pairs_00', 'U') is not null
drop table temp.wb_gdp_change_year_pairs_00; 

select 
    a.economy 
    , total_gdp = sum(a.value)
into temp.wb_gdp_change_year_pairs_00
from wb.economy_time_resource a
where 1 = 1
    and a.resource = 'NY.GDP.MKTP.CD'
group by 
    a.economy

select * from temp.wb_gdp_change_year_pairs_00

-- post drop tables
if object_id('temp.wb_gdp_change_year_pairs_00', 'U') is not null
drop table temp.wb_gdp_change_year_pairs_00; 


