#!/bin/bash
umask 000

exec /sbin/setuser nobody /usr/sbin/haproxy -f /config/haproxy.cfg
