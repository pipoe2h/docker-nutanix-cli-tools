FROM openjdk:8
LABEL maintainer="Jose Gomez <pipoe2h@gmail.com>"

RUN apt-get update \
    && apt-get install -qy python-pip sshpass

COPY ./requirements.txt /

RUN pip install -r requirements.txt

COPY tools /usr/local/nutanix/bin
WORKDIR /usr/local/nutanix/bin

RUN unzip ncli.zip \
    && sed -i -e 's/java version/openjdk version/g' ncli \
    && rm ncli.zip

COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]