FROM coredevorg/stretch-agorum:latest
LABEL maintainer="coredevorg"
ARG GH_TOKEN="<secret>"
ARG ROI_PASSWORD=agorum
ARG MYSQL_PASSWORD=agorum
ENV DEBIAN_FRONTEND=noninteractive
RUN mkdir -p /opt/agorum/scripts
COPY sources/* /opt/agorum/
COPY scripts/* /opt/agorum/scripts/
WORKDIR /opt/agorum
RUN chmod 700 *.sh && chmod 700 scripts/* && ./agorum-setup.sh && ./agorum-data-install.sh

VOLUME /opt/agorum/data
EXPOSE 80 443
ENTRYPOINT [ "/opt/agorum/entrypoint.sh" ]
