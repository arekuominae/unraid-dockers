#!/bin/bash

chown -R nobody:users /config

# Move the default cnf file (if not exists)
mv -n /root/haproxy.cnf /config/

chmod -R 0777 /config
