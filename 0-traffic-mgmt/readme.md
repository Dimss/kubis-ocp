# Traffic management
Traffic shifting description 

Deploy `kubis-gw` and `kubis-rest-v0.1` services 

```
oc create -f 0-dep-svc.yaml
```

Deploy `kubis-rest-v0.3` service

```
oc create -f 1-rest-v0.3.yaml
```

Execute requests from `kubis-gw` to `kubis-rest`, requests should be splits between two version of `kubis-rest` v0.1 and v0.3
```
curl -s -H "X-APP-USER: kubis" http://kubis-gw/version
```

Router traffic to `kubis-rest-v0.1` only, deploy `DestinationRule` and `VirtualService` for `kubis-gw` and `kubis-rest-v0.1`

```
oc create -f 2-gw-dest-rule.yaml
oc create -f 3-rest-simple.yaml
```




