#!/bin/bash
mkdir -p tmp
export VERSION=11.0-alpine
export CGAL_VERSION=4.13
export POSTGIS_VERSION=2.4.5
export SFCGAL_VERSION=1.3.2
docker rm -f geo-postgres
docker build --force-rm  -t tutmosisii/pg_postgis_geopandas:$VERSION"_"$POSTGIS_VERSION .
#######################################################################################################################
#   For testing purposes
#######################################################################################################################
docker run --name geo-postgres -e POSTGRES_PASSWORD=mysecretpassword -d tutmosisii/postgres_postgis:$VERSION"_"$POSTGIS_VERSION
docker run -it --rm --link geo-postgres:postgres tutmosisii/postgres_postgis:$VERSION"_"$POSTGIS_VERSION psql -h postgres -U postgres -c "SELECT PostGIS_full_version();"
#######################################################################################################################
#   Pruebas con Shapefailes
#######################################################################################################################
# 1) Genranado sql
docker run -it --rm --link geo-postgres:postgres -v $(pwd)/tmp/shp:/share_shp/ tutmosisii/postgres_postgis:$VERSION"_"$POSTGIS_VERSION shp2pgsql -I -s 4326 -k -W "utf-8" /share_shp/aerodromos/aerodromos.shp aerodromos  > tmp/out.sql

docker run -it --rm --link geo-postgres:postgres -v $(pwd)/tmp/shp:/share_shp/ tutmosisii/postgres_postgis:$VERSION"_"$POSTGIS_VERSION shp2pgsql -I -s 4326 -k -W "utf-8" /share_shp/oficinas/magistratura_oficinas_032016.shp oficinas  > tmp/out2.sql

# 2) Ejecutando SQL
docker run -it --rm --link geo-postgres:postgres -v $(pwd)/tmp/:/tmp tutmosisii/postgres_postgis:$VERSION"_"$POSTGIS_VERSION psql -h postgres -U postgres -f /tmp/out.sql
