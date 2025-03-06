#!/bin/bash
clear
make
ls -l flagquiz.com | tr -s " " | cut -d" " -f5
