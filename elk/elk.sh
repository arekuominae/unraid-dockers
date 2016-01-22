#!/bin/bash
/elasticsearch/bin/elasticsearch
exec /kibana/bin/kibana
exec /logstash/bin/logstash agent -f /config/logstash/logstash.conf
