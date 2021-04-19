FROM fluagen/ubuntu:16.04

ADD okapi /okapi
RUN chmod 777 /okapi/start.sh && \
    chmod 777 /okapi/init-env.sh && \
    mkdir /mods && \
    mkdir -p /okapi/logs

WORKDIR /okapi

EXPOSE 9130 5005 5006 5007 5008 5009

CMD ["/okapi/start.sh"]
