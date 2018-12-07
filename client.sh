sudo killall -HUP mDNSResponder
curl -s -H "X-APP-USER: kubis-rest-0-3-1-5q77p" http://kubis-gw/metadata | jq -C .
