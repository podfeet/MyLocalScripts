#!/bin/zsh
# Assign variable to IP address
ip='192.168.4.95'
if ping -c 1 -W 1 "$ip"; then
  say "I found it!"
  exit 0
else
  exit 113
fi