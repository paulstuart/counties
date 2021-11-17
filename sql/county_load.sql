
drop table if exists county_lookup;
create table county_lookup (
   id integer primary key,
   geoid integer,
   name text,
   fullname text,
   state text,
   geopoly json
);

insert into county_lookup (geoid,name,fullname, state, geopoly)
   select geoid, name, fullname, state, poly as geopoly
    from county_data
    where geotype = 'Polygon'
   ;

.exit
insert into county_lookup (geoid,name,fullname, state, geopoly)
    SELECT t1.geoid, t1.name, t1.fullname, t1.state, json_extract(poly,'$[0]') as geopoly
    FROM county_data AS t1
        where geotype = 'MultiPolygon'
          and json_array_length(poly) =1
;

.exit

insert into county_lookup (geoid,name,fullname, state, geopoly)
select geoid, name, fullname, state, poly as geopoly from multi
;
.exit
-- below has already run 

drop table if exists county_lookup;
create table county_lookup (
   id integer primary key,
   geoid integer,
   name text,
   fullname text,
   state text,
   geopoly json
);

insert into county_lookup (geoid,name,fullname, state, geopoly)
   select geoid, name, fullname, state, poly as geopoly
    from good_county
    where geotype = 'Polygon'
   ;
