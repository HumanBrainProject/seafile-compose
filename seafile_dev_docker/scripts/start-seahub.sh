#!/bin/bash

#dirty hack to override the seafile-server location
sed -i -e 's|http://127.0.0.1|http://seafile-server|g' /opt/seafile/seafile-server-latest/seahub/seahub/settings.py

python /opt/seafile/seafile-server-latest/seahub/manage.py migrate
python /opt/seafile/seafile-server-latest/seahub/manage.py runserver 0.0.0.0:8000
