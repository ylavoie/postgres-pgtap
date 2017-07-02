FROM postgres:9.3-alpine
MAINTAINER Yves Lavoie <ylavoie@yveslavoie.com>

RUN apk add --no-cache git make perl

RUN mkdir -p /usr/local/src && \
    cd /usr/local/src && \
    git clone https://github.com/theory/pgtap.git && \
    cd pgtap && \
    # Patch not yet installed. && \
    # See https://github.com/theory/pgtap/pull/137/commits/d9cf60bd53b8e36c54eb86d23a716d5941ebf9b1 && \
    sed -ie 's/EXCEPTION WHEN OTHERS THEN/EXCEPTION WHEN OTHERS OR ASSERT_FAILURE THEN/' compat/install-9.1.patch && \
    make install

RUN rm -r /usr/local/src  && \
    apk del --purge expat pcre git make libssh2 libcurl perl
