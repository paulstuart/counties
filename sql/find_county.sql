
.timer on
-- .eqp on

select count(*) from county_geo as record_count;

.parameter set $lat 37.7799
.parameter set $lon -122.2822
select geoid, name, state from county_geo
  where geopoly_contains_point(_shape, $lon, $lat )
;

.exit

drop view if exists filtered ;

create view filtered as
with poly(shaped) as (
	select _shape from county_geo
	where geoid = 6001
)
select a.* from
    testing a, poly b
  where geopoly_contains_point(b.shaped, a.longitude, a.latitude)
;

create table final as select * from filtered
;
.exit
shaped from poly;

select a.* from testing a, county_geo cc
   --from (select geoid from county_geo where geopoly_contains_point(_shape, testing.longitude, testing.latitude));
  where geopoly_contains_point(_shape, a.longitude, a.latitude);
.exit
.timer on
update redfin_copy 
    set geoid = found
   --from (select geoid from county_geo where geopoly_contains_point(_shape, testing.longitude, testing.latitude));
   from (select cc.geoid as found, _shape from county_geo cc) 
  where geopoly_contains_point(_shape, longitude, latitude);
.exit

UPDATE inventory
   SET quantity = quantity - daily.amt
  FROM (SELECT sum(quantity) AS amt, itemId FROM sales GROUP BY 2) AS daily
 WHERE inventory.itemId = daily.itemId;
/*
*/
.parameter set $lat 37.7799
.parameter set $lon -122.2822

-- 6001|Alameda|CA|[[-122.374,37.4542],[-121.469,37.4542],[-121.469,37.9058],[-122.374,37.9058],[-122.374,37.4542]]

/*
.parameter set $lat 37.60
.parameter set $lon -122.0
*/

/*
select geoid, name, state, geopoly_json(geopoly_bbox(_shape))
from county_geo
  where name = 'Alameda'
;
.exit
*/

select geoid, name, state from county_geo
  where geopoly_contains_point(_shape, $lon, $lat )
;


/*
select geoid, name, state from county_geo
  where geopoly_contains_point(_shape, $lat, $lon)
;
*/
