FROM postgres:9.3
MAINTAINER Yves Lavoie <ylavoie@yveslavoie.com>

RUN apt-get update \
    && apt-get install -y postgresql-$PG_MAJOR-pgtap \
    && rm -rf /var/lib/apt/lists/*
