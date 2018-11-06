# Seafile compose

The project is intended for a quick developer environment for Seahub, while
all necessary components live in their own containers.

There are separate containers for:
* Mysql DB
* CCNET-server
* Seafile-server
* Seahub

All containers except the DB are using the official Seafile release downloads,
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

### Create a superuser

In a new terminal, from the project root, run:

`docker-compose exec seahub python /opt/seafile/seafile-server-latest/seahub/manage.py createsuperuser`

### Access your Seafile instance

This will get you the upstream vanilla version of Seafile listening on
http://localhost:8000, with no customizations. You can login using the
superuser you just created.

### Changing the version

Edit the Dockerfile in `seafile_dev_docker/Dockerfile` and change
`SEAFILE_VERSION=X.Y.Z` to an [available version](https://www.seafile.com/en/home/).

## Run local copy of Seahub with ipdb

Clone the Seahub repository into the local folder `seahub`
([clone](https://github.com/haiwen/seahub.git) or symlink), it will be
mounted on the seahub container to override the version that ships
with the official release.

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

This will get you the a custom version of Seahub listening on
http://localhost:8000, using the upstream vanilla versions of
Seafile-server and CCNET-server. This container also includes
[ipdb](https://pypi.org/project/ipdb/) for debugging.

Then if you want to use `ipdb.set_trace()` to debug your version
you have to restart the Seahub container as follows:

```
docker-compose stop seahub
docker-compose run --service-ports seahub
```

That's it. The Seahub service will now run in the foreground and you
should get an interactive debugging shell when reaching a breakpoint.
Changing your Seahub code should trigger Django to reload so you don't
have to restart the container after every change.


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
