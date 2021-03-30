FROM fluagen/ubuntu:20.04

ADD okapi /okapi
RUN chmod 777 /okapi/start.sh && \
    chmod 777 /okapi/init-env.sh && \
    mkdir /mods

WORKDIR /okapi

EXPOSE 9130

CMD ["/okapi/start.sh"]
