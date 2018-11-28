. /usr/local/etc/colors
#curl  -vs http://kubis-rest/v1/system/version  | jq -C .
curl -v -s -H "x-app-user: user1" http://kubis-rest/v1/system/version  | jq -C .
