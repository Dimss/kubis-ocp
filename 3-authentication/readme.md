# Authentication 
This is Isito authentication descritpion 

### Play the demo 

#### Deploy 3 services 
With sidecar: 
- `kubis-rest` 
- `kubis-gw`

Without sidecar:
- `kubis-rest-insec`

```
oc create -f 0-dep-svc.yaml
```

#### Deploy destination rules
```
oc create -f 1-gw-dest-rule.yaml
oc create -f 2-rest-sec-dest-rule.yaml
```


Execute request between services with enabled authentication, everything should works as expected 

`curl -s http://kubis-gw/metadata | jq -C .` 

Execute request to service without Istio sidecar, the request should fail with 403 HTTP error. 

`curl -s -H "X-APP-USER: insec" http://kubis-gw/metadata | jq -C .` 


