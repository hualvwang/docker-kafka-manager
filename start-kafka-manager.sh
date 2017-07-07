#!/bin/bash

if [[ $KAFKA_MANAGER_USERNAME != ''  && $KAFKA_MANAGER_PASSWORD != '' ]]; then
    sed -i.bak '/^basicAuthentication/d' /opt/kafka-manager/conf/application.conf
    echo 'basicAuthentication.enabled=true' >> /opt/kafka-manager/conf/application.conf
    echo "basicAuthentication.username=${KAFKA_MANAGER_USERNAME}" >> /opt/kafka-manager/conf/application.conf
    echo "basicAuthentication.password=${KAFKA_MANAGER_PASSWORD}" >> /opt/kafka-manager/conf/application.conf
    echo 'basicAuthentication.realm="Kafka-Manager"' >> /opt/kafka-manager/conf/application.conf
fi

exec ./bin/kafka-manager -Dconfig.file=${KAFKA_MANAGER_CONFIGFILE} -Dhttp.port=9000 "${KAFKA_MANAGER_ARGS}" "${@}"
