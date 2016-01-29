#!/bin/bash

IP="$(ifconfig | grep -A 1 'eth0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)"

if [ ! -d "/config/logstash/" ]; then
  mkdir -p /config/logstash
  chown -R nobody:users /config/logstash
fi

if [ ! -d "/config/elastic/data/" ]; then
  mkdir -p /config/elastic/data
  chown -R nobody:users /config/elastic/data
fi

if [ ! -d "/config/elastic/log/" ]; then
  mkdir -p /config/elastic/log
  chown -R nobody:users /config/elastic/log
fi

if [ ! -d "/config/kibana/" ]; then
  mkdir -p /config/kibana
  chown -R nobody:users /config/kibana
fi

# Move the default conf file (if not exists)
mv -n /root/logstash.conf /config/logstash/

# Edit the config files to change localhost to the current IP
sed -i "s/hosts =>.*/hosts => ["\"${IP}:9200\""]/g" /config/logstash/logstash.conf
sed -i "s/elasticsearch_url.*/elasticsearch_url: \"http:\/\/${IP}:9200\"/g" /kibana/config/kibana.yml

chmod -R 0777 /config
