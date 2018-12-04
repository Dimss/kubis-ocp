# Traffic mirroring 

Deploy `kubis-gw` and `kubis-rest` services 
```
oc create -f 0-dep-svc.yaml
```

Deploy DestinationRule and VirtualService for both `kubis-gw` and `kubis-rest` services
```
oc create -f 1-gw-dest-rule.yaml
oc create -f 2-rest-dest-rule.yaml
```

Deploy debug `kubis-rest-debug` instance 
```
oc create -f 3-dep-debug.yaml
```

Deploy Mirroring DestinationRule and VirtualService
```
oc delete -f 1-gw-dest-rule.yaml
oc create -f 4-gw-mirror.yaml
```

Execute request to `kubis-gw` service 
```
curl -s -H "X-APP-USER: user1" http://kubis-gw/metadata  | jq -C .
```
Start remote debugger and start to debug `kubis-gw` service

## Cleaning up 
```
./clean.sh
```

