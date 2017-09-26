FROM postgres:9.3
MAINTAINER Yves Lavoie <ylavoie@yveslavoie.com>

RUN DEBIAN_FRONTEND=noninteractive && \
  apt-get update && apt-get -y install postgresql-9.3-pgtap \
          pgxnclient postgresql-server-dev-9.3 unzip make

WORKDIR /opt

#RUN pgxn download E-Maj
COPY e-maj-2.1.0.zip /opt/e-maj-2.1.0.zip
RUN unzip e-maj-2.1.0.zip && \
    rm e-maj-2.1.0.zip && \
    cd e-maj-2.1.0 && \
    make install && \
    cd .. #&& \
#    rm -r e-maj-2.1.0

USER postgres
CMD psql -c "CREATE EXTENSION dblink" && \
    psql -c "CREATE EXTENSION emaj"

RUN apt purge -y pgxnclient postgresql-server-dev-9.3 make unzip && \
  apt-get -y autoremove && \
  rm -rf /var/lib/apt/lists/*
