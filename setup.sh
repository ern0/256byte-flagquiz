#!/bin/bash
clear

BASE=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

alias p='$BASE/build.sh'
alias s='$BASE/launch.sh'

cd $BASE
basename $BASE
