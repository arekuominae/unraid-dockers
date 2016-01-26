#!/bin/bash
umask 000

exec /sbin/setuser nobody /kibana/bin/kibana
