#!/bin/sh

# Validate database
if [ ! -f "/data/webvirtmgr.sqlite3" ]; then
    /usr/bin/python /opt/webvirtmgr/manage.py syncdb --noinput
    echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@localhost', '1234')" | /usr/bin/python /opt/webvirtmgr/manage.py shell
fi

# Execute supervisord
supervisord -n