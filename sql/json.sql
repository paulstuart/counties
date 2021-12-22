
-- save data as json for processing elsewhere

.mode json
.print "saving file to county_poly.json"
.once county_poly.json
select * from county_poly;

