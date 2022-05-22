#!/usr/bin/env bash

# may require `sudo apt-get install -y xz-utils`

set -e -u
set -x

DATAFILE=${DATAFILE:=us-county-boundaries.csv}
DATABASE=${DATABASE:-counties.db}

fail() { echo >&2 $*; exit 1; }

check() {
    command -v $1 > /dev/null 2>&1 || fail "$1 is not available"
    }

prep()  { 
    [[ -f $DATAFILE ]] && return
    check xz
    xz -d -k -c ${DATAFILE}.xz > $DATAFILE;
}

load() {
    check sqlite3
    # ensure data is ready
    cd data
    prep
    cd -
    sqlite3 -echo -bail $DATABASE < sql/county_raw.sql
}

poly() {
    check sqlite3
    sqlite3 -echo -bail $DATABASE < sql/prep.sql
    # sqlite3 -echo -bail $DATABASE < sql/county_poly.sql
    # sqlite3 -echo -bail $DATABASE < sql/county_load.sql
    # sqlite3 -echo -bail $DATABASE < sql/county_view.sql
}

# ensure we're at project root
cd $(dirname $0)/..

#load
poly




