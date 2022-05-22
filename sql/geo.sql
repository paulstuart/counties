
.echo on

drop table if exists county_geo;
CREATE VIRTUAL TABLE county_geo USING geopoly(geoid, name, fullname, state);
insert or ignore into county_geo(geoid, name, fullname, state, _shape)
   select geoid, name, fullname, state, geopoly
   from county_poly
   ;

drop view if exists county_show;
create view county_show as 
	select geoid, name,fullname,state, geopoly_json(_shape)
	from county_geo
	;
