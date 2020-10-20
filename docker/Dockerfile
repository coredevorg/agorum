FROM coredevorg/stretch-agorum:latest
LABEL maintainer="coredevorg"
ARG DEBIAN_FRONTEND=noninteractive
RUN mkdir /opt/agorum
COPY sources/* /opt/agorum/
WORKDIR /opt/agorum
ENV AUTOCONFIG="/opt/agorum/install_config.properties"
RUN BIN=$(ls setup-agorum-core-server-linux-pro-*.bin) && \
    /bin/bash $BIN unattended >/dev/null && \
    rm /opt/agorum/agorumcore/jboss/server/default/lib/drizzle_jdbc.jar && \
    rm /opt/agorum/agorumcore/jboss/server/default/deploy/mysql-ds.xml && \
    mv /opt/agorum/mysql-connector-java-5.1.49.jar /opt/agorum/agorumcore/jboss/server/default/lib && \
    mv /opt/agorum/mysql-ds.xml /opt/agorum/agorumcore/jboss/server/default/deploy && \
    mkdir agorumcore/storage && \
    INSTALL="/opt/agorum/agorumcore/jboss/server/default/deploy/roi.ear/autoupdate/auto-install-plugins" && \
    mkdir -p "$INSTALL" && mv agorumcoreocr-1.0.0.zip "$INSTALL" && \
    unzip agorumcoreocr-linux.zip && mv agorumcoreocr-linux agorumcore/ocr && \
    /opt/agorum/agorumcore/scripts/agorumcore start && sleep 5 && \
    /opt/agorum/agorumcore/scripts/agorumcore stop && \
    chmod 700 /opt/agorum/*.sh && /opt/agorum/agorum-data-install.sh
VOLUME /opt/agorum/data
ENTRYPOINT [ "/opt/agorum/entrypoint.sh" ]
