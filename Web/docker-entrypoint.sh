#!/bin/bash

chown -R daemon:daemon /srv/moodledata
chown -R daemon:daemon /srv/moodledata/*
exec "$@"
