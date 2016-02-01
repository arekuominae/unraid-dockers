#!/bin/bash

IP="$(ifconfig | grep -A 1 'eth0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)"

if [ ! -d "/config/logstash/config" ]; then
  mkdir -p /config/logstash/config
fi

if [ ! -d "/config/logstash/log" ]; then
  mkdir -p /config/logstash/log  
fi

if [ ! -d "/config/elastic/data/" ]; then
  mkdir -p /config/elastic/data  
fi

if [ ! -d "/config/elastic/log/" ]; then
  mkdir -p /config/elastic/log  
fi

if [ ! -d "/config/kibana/log" ]; then
  mkdir -p /config/kibana/log  
fi

chown -R nobody:users /config/logstash
chown -R nobody:users /config/elastic
chown -R nobody:users /config/kibana

# Move the default conf file (if not exists)
mv -n /root/logstash.conf /config/logstash/config/

# Edit the config files to change localhost to the current IP
sed -i "s/hosts =>.*/hosts => ["\"${IP}:9200\""]/g" /config/logstash/config/logstash.conf
sed -i "s/elasticsearch_url.*/elasticsearch_url: \"http:\/\/${IP}:9200\"/g" /kibana/config/kibana.yml

chmod -R 0777 /config
