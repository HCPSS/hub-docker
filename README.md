# Hub Docker

This project contains 2 Docker images which can be used as the infrastructure to
serve the Staff Hub.

## Database

The /Database folder contains the Dockerfile for creating the database image.
Navigate to that folder and build the image like this:

```
$ docker build -t hcpss/db .
```

And then run it:

```
$ docker run --name db -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=<YOUR_SECRET_ROOT_PASSWORD> -v <LOCAL_MYSQL_DATA_DIR>:/var/lib/mysql hcpss/db
```

## Web server

The /Web folder contains the docker file for the Apache/PHP container. Build it
like this:

```
$ docker build -t hcpss/web .
```

And then run it:

$ docker run -d --name web -v <LOCAL_MOODLE_SOURCE_CODE>:/usr/local/apache2/htdocs -v <LOCAL_MOODLE_DATA_DIR>:/srv/moodledata -p 80:80 --link db:staff hcpss/web
