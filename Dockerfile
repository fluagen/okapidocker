FROM fluagen/ubuntu-java8


WORKDIR /app

COPY start.sh /app/start.sh
RUN chmod 777 /app/start.sh


EXPOSE 9130

CMD ["./start.sh"]

#CMD ["/bin/bash","-c","while true;do sleep 1;done"]
