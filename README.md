# Seafile compose

The project is intended for a quick developer environment for Seahub, while
all necessary components live in their own containers.

There are separate containers for:
* Mysql DB
* CCNET-server
* Seafile-server
* Seahub

All containers except the db are using the official Seafile release downloads,
where the version is specified in the Dockerfile.

## Run compose

```
docker-compose \
  -f docker-compose.yaml \
  up \
  --force-recreate \
  --renew-anon-volumes \
  --build
```

This will get you the upstream vanilla version of Seafile listening on http://localhost:8000,
with no customizations.

### Create a superuser

`docker-compose exec seahub python /opt/seafile/seafile-server-latest/seahub/manage.py createsuperuser`

## Run local copy of Seahub with ipdb

Put a Seahub version into the local folder `seahub` (symlink or copy), it will be
mounted to override the version that ships with official release.

To run the local copy of Seahub with Docker Compose run

```
docker-compose \
  -f docker-compose.yaml \
  -f docker-compose.dev.yaml \
  up \
  --force-recreate \
  --renew-anon-volumes \
  --build
```

This will get you the a custom version of Seahub listening on http://localhost:8000,
using the upstream vanilla versions of Seafile-server and CCNET-server.

Then if you want to use `ipdb.set_trace()` to debug your version
you have to restart to Seahub container as follows:

```
docker-compose stop seahub
docker-compose run --service-ports seahub
```

That's it. Now you should get an interactive debugging shell when reaching a breakpoint.
Changing your Seahub code should trigger Django to reload so you don't have to
restart the container after every change.


## Useful for compose debugging

When `up` fails you can try to debug by
running bash on the image and attaching volumes and networks:

```
docker run \
  --rm \
  -it \
  --entrypoint /bin/bash \
  -v seafile-compose_sockets:/opt/seafile/sockets \
  --network seafile-compose_default\
  seafile:dev
```

Then try the compose service command that fails and see what's wrong.
