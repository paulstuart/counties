
-- import county data in for further processing

drop table if exists county_raw;
.mode tabs
.separator ";"
.import 'data/us-county-boundaries.csv' county_raw
alter table county_raw rename column [Geo Shape] to GeoShape;
