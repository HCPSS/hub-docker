# Hub Docker

This project contains 2 Docker images which can be used as the infrastructure to
serve the Staff Hub. It's actually pretty generic so it could be used for many
different web applications.

## Database

The /Database folder contains the Dockerfile for creating the database image.
Navigate to that folder and build the image like this:

```
$ docker build -t hcpss/db .
```

And then run it:

```
$ docker run -d --name db \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=<YOUR_SECRET_ROOT_PASSWORD> \
  -v <LOCAL_MYSQL_DATA_DIR>:/var/lib/mysql \
  hcpss/db
```

Where YOUR_SECRET_ROOT_PASSWORD is the root password for MySQL and
LOCAL_MYSQL_DATA_DIR is the local directory for MySQL storage.

## Web server

The /Web folder contains the docker file for the Apache/PHP container. Build it
like this:

```
$ docker build -t hcpss/web .
```

And then run it:

```
$ docker run -d --name web \
  -v <LOCAL_SIMPLESAMLPHP_DIR>:/srv/simplesaml \
  -v <LOCAL_MOODLE_SOURCE_CODE>:/var/www \
  -v <LOCAL_MOODLE_DATA_DIR>:/srv/moodledata \
  -p 80:80 \
  --link db:staff \
  hcpss/web
```

Where LOCAL_SIMPLESAMLPHP_DIR is the local directory where SimpleSAML PHP is
located and LOCAL_MOODLE_SOURCE_CODE is the local directory where the Moodle (or 
other web app) source code is stored and LOCAL_MOODLE_DATA_DIR is the local
Moodle data directory.
