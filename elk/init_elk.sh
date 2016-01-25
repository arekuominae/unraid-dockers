#!/bin/bash

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

chmod -R 0777 /config
