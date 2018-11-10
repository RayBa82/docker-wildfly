FROM rayba82/oracle-java:latest

MAINTAINER RayBa "rainerbaun@gmail.com"

ENV JBOSS_HOME /opt/wildfly

RUN groupadd -g 9002 jboss
RUN adduser -u 9002 --gid 9002 --system --no-create-home jboss
RUN mkdir -p /opt/wildfly

RUN apt update \
    && apt -y upgrade \
    && apt -y install \
    wget	

RUN wget -O wildfly.tar.gz http://download.jboss.org/wildfly/14.0.1.Final/wildfly-14.0.1.Final.tar.gz
RUN tar -xzf wildfly.tar.gz -C /opt/wildfly --strip-components 1
RUN rm wildfly.tar.gz

ADD wildlfy /opt/wildfly/
RUN chown -R jboss:jboss /opt/wildfly/

RUN apt-get remove -y git wget --autoremove --purge

RUN apt update \
    && apt -y install \
    locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8 && \
    apt-get remove -y locales

RUN chown -R jboss:jboss /opt/health/

USER jboss

CMD ["/opt/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]