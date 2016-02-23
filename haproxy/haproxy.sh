#!/bin/bash
umask 000

exec /sbin/setuser nobody /usr/local/etc/haproxy/haproxy -f /config/haproxy.cfg
