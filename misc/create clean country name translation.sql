create view wb.clean_country_name_translation as 

select
code
, name = replace(name,'|',',')
, geography_code
, income_code
from wb.country_name_translation
