#!/bin/bash
/elasticsearch/bin/elasticsearch
exec /kibana/kibana-4.3.1-linux-x64/bin/kibana
exec /logstash/bin/logstash agent -f /config/logstash/logstash.conf
