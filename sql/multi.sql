/*
CREATE TABLE IF NOT EXISTS "county_raw"(
  "Geo Point" TEXT,
  "Geo Shape" TEXT,
  "STATEFP" TEXT,
  "COUNTYFP" TEXT,
  "COUNTYNS" TEXT,
  "GEOID" TEXT,
  "NAME" TEXT,
  "NAMELSAD" TEXT,
  "STUSAB" TEXT,
  "LSAD" TEXT,
  "CLASSFP" TEXT,
  "MTFCC" TEXT,
  "CSAFP" TEXT,
  "CBSAFP" TEXT,
  "METDIVFP" TEXT,
  "FUNCSTAT" TEXT,
  "ALAND" TEXT,
  "AWATER" TEXT,
  "INTPTLAT" TEXT,
  "INTPTLON" TEXT,
  "STATE_NAME" TEXT,
  "COUNTYFP NOZERO" TEXT
);
*/

.headers on

drop view if exists county_prep;
CREATE VIEW county_prep as 
select 
    rowid as rowid,
    NAME as name, 
    NAMELSAD as fullname,
    STUSAB as state,
    GEOID as geoid,
    [Geo Shape] as geoshape
    /*
    json_extract([Geo Shape], '$.type') as geotype,
    json_extract([Geo Shape], '$.coordinates') as poly -- coordinates is wrapped in an extra '[]'
    */
    from county_raw;



drop view if exists county_src;
CREATE VIEW county_src as 
select 
    rowid,
    name, 
    fullname,
    state,
    geoid,
    json_extract(geoshape, '$.type') as geotype,
    json_extract(geoshape, '$.coordinates') as poly -- coordinates is wrapped in an extra '[]'
    /*
    json_extract([Geo Shape], '$.type') as geotype,
    json_extract([Geo Shape], '$.coordinates') as poly -- coordinates is wrapped in an extra '[]'
    */
    from county_prep;

/*
select rowid, name, fullname, state, geoid, geotype, json_array_length(poly) as plen 
from county_src 
        where geotype = 'MultiPolygon'
limit 2;
*/
drop table if exists decon;
drop table if exists county_poly;
create table county_poly as 
    SELECT geoid, name, fullname, state, jj.value as poly
  --  FROM county_src, json_each(json_extract(poly,'$[0]')) as jj
    FROM county_src, json_each(poly) as jj
    order by geoid
     --   where geotype = 'MultiPolygon'
    /*
          and json_array_length(poly) =1
          */
    --limit 10;
;
.
.mode json
.once county_poly.json
select * from county_poly;

--select geoid,name, substr(value,0,40) as sub from decon order by geoid; 
.exit

    SELECT geoid, name, fullname, state, geoshape --json_each(poly) as geopoly
    FROM county_src --AS t1
        where geotype = 'MultiPolygon'
    /*
          and json_array_length(poly) =1
          */
    limit 10;
;


.exit
    SELECT t1.geoid, t1.name, t1.fullname, t1.state, json_extract(poly,'$[0]') as geopoly
    FROM county_data AS t1
        where geotype = 'MultiPolygon'
          and json_array_length(poly) =1
;