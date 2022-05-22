
-- import county data in for further processing

.timer on

drop table if exists county_raw;
.mode tabs
.separator ";"
.import 'data/us-county-boundaries.csv' county_raw
-- fix names with spaces
alter table county_raw rename column [Geo Shape] to GeoShape;
alter table county_raw rename column [Geo Point] to GeoPoint;
alter table county_raw rename column [COUNTYFP NOZERO] to COUNTYFP_NOZERO;


drop table if exists county_poly;
drop view if exists xform;

create view xform as
with cty_prep as ( 
  select 
    NAME as name, 
    NAMELSAD as fullname,
    STUSAB as state,
    GEOID as geoid,
    [GeoShape] as geoshape
  from county_raw
),
 cty_src as (
  select 
    name, 
    fullname,
    state,
    geoid,
    json_extract(geoshape, '$.coordinates') as poly
    from cty_prep
),
cty_poly as (
    SELECT geoid, name, fullname, state, jj.value as poly
    FROM cty_src, json_each(poly) as jj
    order by geoid
),
cty_bbox as (
  select 
    geoid,
    name, 
    fullname,
    state,
    geopoly_json(geopoly_bbox(poly)) as bbox,
    poly
  from cty_poly
  order by geoid, bbox
)   
select * from cty_bbox
;

create table county_poly as select * from xform;
drop view xform;

