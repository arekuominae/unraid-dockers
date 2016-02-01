#!/bin/bash
umask 000

exec /logstash/bin/logstash agent -f /config/logstash/config -l /config/logstash/log/logstash.log
