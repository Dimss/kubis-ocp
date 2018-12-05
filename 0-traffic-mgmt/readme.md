# Traffic management

![schema](https://raw.githubusercontent.com/Dimss/kubis-ocp/master/0-traffic-mgmt/traffic-mgmt.png)

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

Route traffic only to `kubis-rest-v0.1`, deploy `DestinationRule` and `VirtualService` for `kubis-gw` and `kubis-rest-v0.1`
```
oc create -f 2-gw-dest-rule.yaml
oc create -f 3-rest-simple.yaml
```

Route traffic to `kubis-rest-v0.3` based on header 
```
oc delete -f 3-rest-simple.yaml
oc create -f 4-rest-headers.yaml
```

Split traffic between `kubis-rest-v0.1` and `kubis-rest-v0.3` based on weight 
```
oc delete -f 4-rest-headers.yaml
oc create -f 5-rest-weight.yaml
```

## Cleaning up 
```
./clean.sh
```

