#!/bin/bash

nasm flagquiz.asm -o flagquiz.com 
ls -l flagquiz.com | tr -s " " | cut -d" " -f5
