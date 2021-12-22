#!/usr/bin/env bash

DATAFILE=${DATAFILE:=us-county-boundaries.csv}
DATABASE=${DATABASE:-counties.db}

fail() { echo >&2 $*; exit 1; }

check() {
    command -v $1 > /dev/null 2>&1 || fail "$1 is not available"
    }

prep()  { 
    [[ -f $DATAFILE ]] && return
    check xv
    xv ${DATAFILE}.xz > $DATAFILE; 
}

load() {
    check sqlite3
    # ensure data is ready
    cd data
    prep
    cd -
    sqlite3 $DATABASE < sql/county_raw.sql
}

poly() {
    check sqlite3
    sqlite3 $DATABASE < sql/county_poly.sql
}

# ensure we're at project root
cd $(dirname $0)/..

load
poly




