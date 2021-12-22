DATABASE = "counties.db"

.phony: json

json:
	sqlite3 ${DATABASE} < sql/json.sql

