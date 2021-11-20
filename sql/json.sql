
-- save data as json for processing elsewhere

.mode json
.once county_poly.json
select * from county_poly;

