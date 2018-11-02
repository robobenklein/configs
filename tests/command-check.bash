#!/bin/bash

N=100000
cmd=ls

echo
echo "type:"
time(for i in $(eval echo "{1..$N}"); do
  type $cmd &>/dev/null
done)

echo
echo "hash:"
time(for i in $(eval echo "{1..$N}"); do
  hash $cmd &>/dev/null
done)

echo
echo "command -v:"
time(for i in $(eval echo "{1..$N}"); do
  command -v $cmd &>/dev/null
done)

echo
echo "which:"
time(for i in $(eval echo "{1..$N}"); do
  which $cmd &>/dev/null
done)
