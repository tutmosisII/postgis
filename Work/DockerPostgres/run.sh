#!/bin/bash
SHAPE_FILE_NAME=$1
################################################################################
#   For testing purposes
################################################################################
# docker rm -f geobolivia
# docker run -it --name geobolivia -v $(pwd)/tmp:/tmp  -d tutmosisii/pg_postgis_geopandas:11.0-alpine_2.4.5
# docker run -it --name geobolivia -v $(pwd)/tmp:/tmp   tutmosisii/pg_postgis_geopandas:11.0-alpine_2.4.5
# docker logs --tail 1 geobookpy
################################################################################
shp2pgsql -I -s 4326 -k -W "utf-8" /tmp/$SHAPE_FILE_NAME.shp $SHAPE_FILE_NAME  > /tmp/out.sql
cat /tmp/out.sql|grep -i insert > /tmp/inserts.sql
sed 's/values/\nvalues\n/i' /tmp/inserts.sql|head -1 2>&1 > /tmp/finalInsert.sql
echo "VALUES" >> /tmp/finalInsert.sql
sed 's/values/\nvalues\n/i' /tmp/inserts.sql|grep -Eiv "insert|values" >> /tmp/finalInsert.sql
sed -i 's/);/),/' /tmp/finalInsert.sql
sed -i '$ s/),/);/' /tmp/finalInsert.sql
python2 GeoBolivia.py $SHAPE_FILE_NAME
grep -i insert -m 1 -B100 /tmp/out.sql |grep -vi insert > /tmp/head.sql
tail -3 /tmp/out.sql > /tmp/tail.sql
cat /tmp/head.sql /tmp/finalInsert2.sql /tmp/tail.sql > /tmp/$SHAPE_FILE_NAME.sql
###############################################################################
#   CLEANING PROCESS
###############################################################################
rm /tmp/finalInsert.sql
rm /tmp/finalInsert2.sql
rm /tmp/head.sql
rm /tmp/tail.sql
rm /tmp/out.sql
rm /tmp/inserts.sql

echo "Proceso finalizado Archivo /tmp/$SHAPE_FILE_NAME.sql generado"
