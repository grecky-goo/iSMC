#!/bin/sh
set -e

if [ -z "$1" ]; then
  echo "Missing target filename"
  exit 1
fi

T=$(awk -F: '{ print "    {Key:\"" $2 "\", Desc:\"" $1 "\"}," }' < ../src/temp.txt)
F=$(awk -F: '{ print "    {Key:\"" $2 "\", Desc:\"" $1 "\"}," }' < ../src/fans.txt)
P=$(awk -F: '{ print "    {Key:\"" $2 "\", Desc:\"" $1 "\"}," }' < ../src/power.txt)
V=$(awk -F: '{ print "    {Key:\"" $2 "\", Desc:\"" $1 "\"}," }' < ../src/voltage.txt)
C=$(awk -F: '{ print "    {Key:\"" $2 "\", Desc:\"" $1 "\"}," }' < ../src/current.txt)

echo "
// Copyright (C) 2019  Dinko Korunic
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, version 3.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

// Code generated by go generate. DO NOT EDIT.
// source template in smc/gen-sensors.sh

//go:build darwin

package smc

var AppleTemp = []SensorStat{
$T
}
var AppleFans = []SensorStat{
$F
}
var ApplePower = []SensorStat{
$P
}
var AppleVoltage = []SensorStat{
$V
}
var AppleCurrent = []SensorStat{
$C
}
" | gofmt > "$1"

gofumpt -w "$1" || true
