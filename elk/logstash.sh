#!/bin/bash
umask 000

exec /logstash/bin/logstash agent -f /config/logstash/logstash.conf -l /config/logstash/logstash.log
