#!/bin/bash
lxc list
lxc launch ubuntu:16.04 match-testing-source
sleep 2
lxc list
