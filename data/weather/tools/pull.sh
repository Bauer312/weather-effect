#!/usr/bin/env bash

sleep 15

curl -H "Accept: application/json, text/plain, */*" \
-H "Origin: https://www.wunderground.com" \
-H "Accept-Encoding: br, gzip, deflate" \
-H "Host: api.weather.com" \
-H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4)" \
-H "Accept-Language: en-us" \
-H "Referer: https://www.wunderground.com/" \
-o ../$1/$2.gz \
"https://api.weather.com/v2/pws/history/all?stationId=$1&format=json&units=e&date=$2&apiKey=6532d6454b8aa370768e63d6ba5a832e"
