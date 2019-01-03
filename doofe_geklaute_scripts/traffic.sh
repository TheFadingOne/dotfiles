#!/bin/sh

ifconfig | grep "RX bytes" | tail -n 1 | sed -e "s/.*RX.*(\(.*\)).*TX.*(\(.*\)).*/RX: \1 | TX: \2/g"  
