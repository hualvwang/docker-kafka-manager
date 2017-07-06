FROM          openjdk:8-jre-alpine
MAINTAINER    laoshancun@foxmail.com

ENV SBT_VERSION="0.13.15" \
    SBT_HOME=/usr/local/sbt-launcher-packaging-${SBT_VERSION} \
    PATH="${PATH}:${SBT_HOME}/bin" \
    KAFKA_MANAGER_VERSION="1.3.3.7" \
    KAFKA_MANAGER_HOME=/opt/kafka-manager \
    ZK_HOSTS="localhost:2181" \
    KAFKA_MANAGER_CONFIGFILE="conf/application.conf"

ADD repositories /etc/apk/repositories
ADD start-kafka-manager.sh /opt/kafka-manager/
# Install sbt
RUN set -ex \
	&& apk add --no-cache --virtual /tmp/.build-deps \
		unzip \
		curl \
		gzip \
		tar \
	\
    && curl -sL "http://dl.bintray.com/sbt/native-packages/sbt/$SBT_VERSION/sbt-$SBT_VERSION.tgz" | gunzip | tar -x -C /usr/local \
    && echo -ne "- with sbt $SBT_VERSION\n" >> /root/.built \    && mkdir -p /tmp \
    && cd /tmp \
    && wget -O kafka-manager-${KAFKA_MANAGER_VERSION}.zip https://github.com/yahoo/kafka-manager/archive/${KAFKA_MANAGER_VERSION}.zip \
    && unzip  -d /tmp/kafka-manager kafka-manager-${KAFKA_MANAGER_VERSION}.zip \
    && cd /tmp/kafka-manager \
    && ./sbt clean dist \
    && unzip  -d /opt/kafka-manager ./target/universal/kafka-manager-${KAFKA_MANAGER_VERSION}.zip \
    && chmod +x /opt/kafka-manager/start-kafka-manager.sh \

    # clean up 
    && apk del /tmp/.build-deps \
    && rm -fr /tmp/* /root/.sbt /root/.built /root/.ivy2


WORKDIR /opt/kafka-manager/
EXPOSE 9000
ENTRYPOINT ["./start-kafka-manager.sh"]
