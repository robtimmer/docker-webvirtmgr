#!/bin/sh

# Validate database
if [ ! -f "/data/webvirtmgr.sqlite3" ]; then
    /usr/bin/python /opt/webvirtmgr/manage.py syncdb --noinput
    chown -R webvirtmgr:libvirtd /data
    echo "from django.contrib.auth.models import User; User.objects.create_superuser('$USER', '$EMAIL', '$PASSWORD')" | /usr/bin/python /opt/webvirtmgr/manage.py shell
fi

# Execute supervisord
supervisord -n