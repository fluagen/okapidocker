FROM fluagen/ubuntu:20.04

ADD okapi /okapi
RUN chmod 777 /okapi/start.sh

WORKDIR /okapi

EXPOSE 9130

CMD ["/okapi/start.sh"]
