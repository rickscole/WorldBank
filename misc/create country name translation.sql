select 
    cnt.code
    , cnt.name
    , geography_code = cnt.geographycode
    , income_code = cnt.incomecode
into wb.country_name_translation
from  wb.TBL_CountryNameTranslations cnt
