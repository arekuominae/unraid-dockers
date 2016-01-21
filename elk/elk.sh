#!/bin/bash
/elasticsearch/bin/elasticsearch
/etc/init.d/nginx start
exec /logstash/bin/logstash agent -f /config/logstash/logstash.conf
