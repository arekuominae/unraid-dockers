#!/bin/bash
umask 000

exec /sbin/setuser nobody /logstash/bin/logstash agent -f /config/logstash/logstash.conf
