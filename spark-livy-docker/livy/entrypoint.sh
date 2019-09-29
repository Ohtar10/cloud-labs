#!/usr/bin/env bash

livy-server start
tail -f /usr/lib/livy/logs/livy-*-server.out