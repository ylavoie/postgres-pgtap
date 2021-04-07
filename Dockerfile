ARG POSTGRESQL_VERSION=11
FROM postgres:$POSTGRESQL_VERSION
LABEL maintainer="ylavoie@yveslavoie.com"

ARG POSTGRESQL_VERSION
ARG POSTGRESQL_MODULE=$POSTGRESQL_VERSION

RUN localedef -i fr_CA \
     -c -f UTF-8 -A /usr/share/locale/locale.alias fr_CA.UTF-8
RUN localedef -i en_CA \
     -c -f UTF-8 -A /usr/share/locale/locale.alias en_CA.UTF-8
ENV LANG en_CA.utf8

ENV DEBIAN_FRONTEND=noninteractive
RUN apt -qy update \
  && apt -qy install postgresql-$POSTGRESQL_MODULE-pgtap \
  && apt-get -y autoremove \
  && rm -rf /var/lib/apt/lists/* \
  && echo "\
    # Enable the PostgreSQL stats \n\
    shared_preload_libraries = 'pg_stat_statements' \n\
    pg_stat_statements.max = 1000 \n\
    pg_stat_statements.track = all \n\
    log_destination = 'stderr' \n\
    logging_collector = on \n\
    log_file_mode = 0600 \n\
    log_directory = 'pg_log' \n\
    log_filename = 'postgresql-%a.log' \n\
    log_min_duration_statement = 0 \n\
    log_duration = on \n\
    log_line_prefix = '<%t> ' \n\
    log_statement = 'all' \n\
    max_connections = 50 \n\
    " >> /usr/share/postgresql/postgresql.conf.sample \
  && echo 'psql -d "$POSTGRES_DB" --command "CREATE EXTENSION IF NOT EXISTS pg_stat_statements;"' \
    > /docker-entrypoint-initdb.d/coscale-init.sh

# Work around an aufs bug related to directory permissions:
RUN mkdir -p /tmp \
  && chmod 1777 /tmp \
  && chown postgres:postgres /tmp
#RUN mkdir /tmp/postgres && chown postgres:postgres /tmp/postgres

USER postgres
