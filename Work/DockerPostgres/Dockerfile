ARG VERSION=11.0-alpine
FROM postgres:${VERSION}
ARG CGAL_VERSION=4.13
ARG POSTGIS_VERSION=2.4.5
ARG SFCGAL_VERSION=1.3.2
################################################################################
#                             PostGIS
###############################################################################
COPY tmp/postgis-${POSTGIS_VERSION}.tar.gz /tmp/
###############################################################################
#                             CGAL
###############################################################################
COPY tmp/CGAL-${CGAL_VERSION}.tar.gz /tmp/
###############################################################################
#                             SFCGAL
###############################################################################
COPY tmp/v${SFCGAL_VERSION}.tar.gz /tmp/
###############################################################################
#                    Libraries need for POSTGIS extensions
###############################################################################
RUN apk add build-base && apk add perl &&\
  apk add libxml2 &&\
  apk add docbook-xsl &&\
  apk add asciidoc &&\
  apk add libxml2-dev &&\
  echo "http://mirror.leaseweb.com/alpine/edge/testing" >> /etc/apk/repositories &&\
  apk add libgcc libstdc++ musl geos &&\
  apk add geos-dev &&\
  apk add imagemagick &&\
  apk add proj4 &&\
  apk add proj4-dev
###############################################################################
# gdal testing por problemas con gdal ERROR: unsatisfiable constraints: so:libcrypto.so.1.1
###############################################################################
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/main openssl &&\
  apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing gdal-dev &&\
  apk add pcre &&\
  apk add json-c libpq postgresql &&\
  apk add pcre-dev &&\
  apk add qt &&\
  apk add qt-dev &&\
  apk add mpfr3 &&\
  apk add mpfr-dev &&\
  apk add openscenegraph &&\
  apk add openscenegraph-dev &&\
  apk add cmake &&\
  apk add boost &&\
  apk add boost-dev &&\
  apk add gmp &&\
  apk add gmp-dev
################################################################################
#
################################################################################
RUN  tar -zxf /tmp/CGAL-${CGAL_VERSION}.tar.gz &&\
   cd cgal-releases-CGAL-${CGAL_VERSION} &&\
   mkdir -p release &&\
   cmake -DCMAKE_BUILD_TYPE=Release && make &&\
   make install &&\
   make clean
################################################################################
#
################################################################################
RUN  tar -zxf /tmp/v${SFCGAL_VERSION}.tar.gz &&\
   cd SFCGAL-${SFCGAL_VERSION} &&\
   cmake . && make &&\
   make install &&\
   make clean
################################################################################
#
################################################################################
RUN  tar -zxf /tmp/postgis-${POSTGIS_VERSION}.tar.gz &&\
  cd postgis-${POSTGIS_VERSION} &&\
  ./configure &&\
  make &&\
  make install &&\
  make clean
###############################################################################
#   Libaries python needed to process wrong sql
###############################################################################
RUN  apk add py-pip && apk add python-dev  && pip install geopandas
###############################################################################
#   Libaries shared in lib64 are not self discovered by extensions
###############################################################################
RUN cp /usr/local/lib64/*SF*.so* /usr/local/lib/
###############################################################################
#    Postgresql Image extension
###############################################################################
# Enableling PostGIS on postgresql startup
COPY postgis_install.sql /docker-entrypoint-initdb.d/postgis_install.sql
COPY GeoBolivia.py /GeoBolivia.py
COPY run.sh /run.sh
