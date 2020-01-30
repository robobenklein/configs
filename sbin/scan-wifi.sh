#!/bin/bash
iface=$(ifconfig | grep -o -E "([w][a-zA-Z0-9]*)" | tail -1)
sudo iwlist $iface scan #> /dev/null 2>&1
