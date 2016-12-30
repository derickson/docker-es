FROM phusion/baseimage:latest
MAINTAINER Dave Erickson <david.erickson@gmail.com>

RUN apt-get update
RUN apt-get -y -q install libpcap0.8 wget

ENV ELASTICSEARCH_VERSION=5.1.1

ENV VERSION=${ELASTICSEARCH_VERSION} ARCH=linux-x86_64 EXTENSION=tar.gz
ENV FILENAME=filebeat-${VERSION}-${ARCH}.${EXTENSION}

RUN wget https://artifacts.elastic.co/downloads/beats/filebeat/${FILENAME}
RUN tar zxvf ${FILENAME}

WORKDIR filebeat-${VERSION}-${ARCH}
ADD filebeat.yml filebeat.yml
COPY wait-for-it.sh wait-for-it.sh

RUN chmod 0700 wait-for-it.sh

CMD ["./filebeat", "-e", "-c","filebeat.yml", "-d", "publish"]