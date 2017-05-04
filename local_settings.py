import os

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': '/data/webvirtmgr.sqlite3',
    }
}

TIME_ZONE = 'Europe/Amsterdam'