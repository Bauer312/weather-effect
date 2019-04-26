#!/usr/bin/env bash

function doAll {
mkdir ../$1
./gwd -cmd "./pull.sh" -station "$1" -start "20180801" -end "20180831"
sleep 150
}

doAll "KMNMINNE216"
doAll "KWASEATT2061"
doAll "KPANORTH62"
doAll "KMOSTLOU58"
