FROM debian

RUN apt-get -y update && apt-get install -y wget && apt-get -y clean all

WORKDIR /root
COPY docker-entrypoint.sh /root
ENTRYPOINT ["/root/docker-entrypoint.sh"]
CMD ["reno"]
