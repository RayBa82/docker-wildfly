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

RUN wget -O wildfly.tar.gz https://download.jboss.org/wildfly/15.0.0.Final/wildfly-15.0.0.Final.tar.gz
RUN tar -xzf wildfly.tar.gz -C /opt/wildfly --strip-components 1
RUN rm wildfly.tar.gz

ADD wildlfy /opt/wildfly/
RUN chown -R jboss:jboss /opt/wildfly/

RUN apt-get remove -y git wget --autoremove --purge

ENV LANG C.UTF-8

RUN apt update \
    && apt -y install \
    locales 
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8 

RUN chown -R jboss:jboss /opt/health/

USER jboss

CMD ["/opt/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]