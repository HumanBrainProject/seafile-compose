#!/bin/bash

pip install -I --no-cache-dir --disable-pip-version-check \
            -r /opt/seafile/seafile-server-latest/seahub/requirements.txt

pip install --no-cache-dir --disable-pip-version-check ipdb

python /opt/seafile/seafile-server-latest/seahub/manage.py migrate
python /opt/seafile/seafile-server-latest/seahub/manage.py runserver 0.0.0.0:8000
