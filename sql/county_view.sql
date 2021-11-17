
drop view if exists county_data;
create view county_data as 
select 
    rowid as rowid,
    NAME as name, 
    NAMELSAD as fullname,
    STUSAB as state,
    GEOID as geoid,
    json_extract(GeoShape, '$.type') as geotype,
    json_extract(GeoShape, '$.coordinates[0]') as poly -- coordinates is wrapped in an extra '[]'
    from county_raw
;


