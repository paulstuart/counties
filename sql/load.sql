
-- import county data in for further processing
-- we're only (currently) interested in the geo lookup data
-- if you care about the extra data comment out the drop table at the end

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
    GeoShape as geoshape
  from county_raw
),
 cty_src as (
  select
    name,
    fullname,
    state,
    geoid,
    json_extract(geoshape, '$.type') as geotype,
    json_extract(geoshape, '$.coordinates') as poly
    from cty_prep
),
cty_poly as (

    --SELECT geoid, name, fullname, state, geotype, jj.value as poly
    SELECT geoid, name, fullname, state, geotype, jj.value as poly
    FROM cty_src, json_each(poly) as jj
    WHERE geotype = 'Polygon'
    order by geoid
),
cty_multi as (

    --SELECT geoid, name, fullname, state, geotype, jj.value as poly
    SELECT geoid, name, fullname, state, geotype, json_extract(jj.value,'$[0]') as poly
    FROM cty_src, json_each(poly) as jj
    WHERE geotype = 'MultiPolygon'
    order by geoid
),
cty_both as (
  select * from cty_poly
  union
  select * from cty_multi
),
cty_bbox as (
  select
    geoid,
    name,
    fullname,
    state,
    geotype,
    geopoly_json(geopoly_bbox(poly)) as bbox,
    poly
  from cty_both
),
cty_sort as (
  select * from cty_bbox order by geoid, bbox
)
select * from cty_sort
;

create table county_poly as select * from xform;
drop view xform;

-- comment/delete this if this data matters to you
drop table county_raw;

vacuum;
analyze;
