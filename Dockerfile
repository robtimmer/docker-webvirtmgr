# Use Ubuntu 16.04 as base image
FROM ubuntu:16.04

# Set maintainer info
MAINTAINER Rob Timmer <rob@robtimmer.com>

# Set environment variables
ENV DEBIAN_FRONTEND noninteractive \
    USER admin \
    EMAIL admin@localhost \
    PASSWORD 123456abcd

# Install dependencies
RUN apt-get -y update && \
    apt-get -y install git python-pip python-libvirt python-libxml2 supervisor novnc

# Install Webvirtmgr
RUN git clone https://github.com/retspen/webvirtmgr /opt/webvirtmgr
WORKDIR /opt/webvirtmgr
# RUN git checkout 7f140f99f4 #v4.8.8
RUN pip install -r requirements.txt
ADD local_settings.py /opt/webvirtmgr/webvirtmgr/local/local_settings.py
RUN sed -i 's/0.0.0.0/172.17.42.1/g' vrtManager/create.py
RUN /usr/bin/python /opt/webvirtmgr/manage.py collectstatic --noinput
ADD supervisor.webvirtmgr.conf /etc/supervisor/conf.d/webvirtmgr.conf
ADD gunicorn.conf.py /opt/webvirtmgr/conf/gunicorn.conf.py
ADD bootstrap.sh /opt/webvirtmgr/bootstrap.sh

# Set permissions
RUN useradd webvirtmgr -g libvirtd -u 1010 -d /data/ -s /sbin/nologin
RUN chown -R webvirtmgr:libvirtd /opt/webvirtmgr

# Clean apt
RUN apt-get -ys clean

# Add data volume
VOLUME ["/data"]

# Expose required ports
EXPOSE 8080/tcp 6080/tcp

# Set bootstrap script as entrypoint
ENTRYPOINT ["/opt/webvirtmgr/bootstrap.sh"]