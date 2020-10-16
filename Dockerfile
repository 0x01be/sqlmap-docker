FROM alpine as build

RUN apk add --no-cache --virtual sqlmap-build-dependecies \
    git

RUN mkdir -p /opt
ENV SQLMAP_REVISION master
RUN git clone --depth 1 --branch ${SQLMAP_REVISION} https://github.com/sqlmapproject/sqlmap.git /opt/sqlmap


FROM alpine

COPY --from=build /opt/sqlmap/ /opt/sqlmap/

RUN apk add --no-cache --virtual sqlmap-runtime-dependecies \
    python3

RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ln -s /opt/sqlmap/sqlmap.py /opt/sqlmap/sqlmap

RUN adduser -D -u 1000 sqlmap
RUN chown -R sqlmap:sqlmap /opt/sqlmap

USER sqlmap

ENV PATH ${PATH}:/opt/sqlmap/

WORKDIR /opt/sqlmap

CMD ["sqlmap", "-hh"]

