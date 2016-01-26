#!/bin/bash
umask 000

exec /sbin/setuser nobody /elasticsearch/bin/elasticsearch
