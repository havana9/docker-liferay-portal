FROM mdelapenya/liferay-portal:7-ce-ga5-tomcat-hsql

# Set maintainer of the docker image
MAINTAINER Antonio Musarra <antonio.musarra@gmail.com>
LABEL maintainer="Antonio Musarra <antonio.musarra@gmail.com>"

ENV LIFERAY_WEB_SERVER_PROTOCOL=http
ENV LIFERAY_URL_SECURITY_MODE=ip
ENV LIFERAY_PUBLISH_GOGO_SHELL=true
ENV LIFERAY_CLEAN_DATA_DIR=false
ENV CONTAINER_DIR=/wedeploy-container

USER root

RUN apt-get update \
  && apt-get install tree \
  && apt-get install telnet

COPY ./configs/portal-ext.properties $LIFERAY_HOME/portal-ext.properties
COPY ./configs/setenv.sh $CATALINA_HOME/bin
COPY ./entrypoint.sh $CATALINA_HOME/bin

RUN chmod +x $CATALINA_HOME/bin/entrypoint.sh

RUN \
  chown liferay:liferay $CATALINA_HOME/bin/entrypoint.sh \
  && chown liferay:liferay $LIFERAY_HOME/portal-ext.properties \
  && mkdir -p /opt/liferay \
  && chown liferay:liferay /opt/liferay

USER liferay
VOLUME "/opt/liferay"
ENTRYPOINT ["entrypoint.sh"]
