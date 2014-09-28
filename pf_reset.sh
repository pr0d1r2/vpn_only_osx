#!/bin/bash

pfctl -d
pfctl -Fa
pfctl -ef /etc/pf.conf
