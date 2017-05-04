# Use Ubuntu 14.04 as base image
FROM ubuntu:14.04

# Set maintainer info
MAINTAINER Rob Timmer <rob@robtimmer.com>

# Install dependencies
RUN apt-get -y update && \
    apt-get -y install git python-pip python-libvirt python-libxml2 supervisor novnc

# Install Webvirtmgr
RUN git clone https://github.com/retspen/webvirtmgr /opt/webvirtmgr
WORKDIR /opt/webvirtmgr
# RUN git checkout 7f140f99f4 #v4.8.8
RUN pip install -r requirements.txt
ADD local_settings.py /webvirtmgr/webvirtmgr/local/local_settings.py
RUN sed -i 's/0.0.0.0/172.17.42.1/g' vrtManager/create.py
RUN /usr/bin/python /webvirtmgr/manage.py collectstatic --noinput

# Add required files
ADD supervisor.webvirtmgr.conf /etc/supervisor/conf.d/webvirtmgr.conf
ADD gunicorn.conf.py /webvirtmgr/conf/gunicorn.conf.py
ADD bootstrap.sh /webvirtmgr/bootstrap.sh

# Set permissions
RUN useradd webvirtmgr -g libvirtd -u 1010 -d /data/ -s /sbin/nologin
RUN chown webvirtmgr:libvirtd -R /webvirtmgr

# Clean apt
RUN apt-get -ys clean

# Add data volume
VOLUME ["/data"]

# Expose required ports
EXPOSE 8080/tcp 6080/tcp

# Execute supervisord
CMD ["supervisord", "-n"]