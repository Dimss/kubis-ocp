# Circuit breaker

Deploy `kubis-gw` and `kubis-rest` services 
```
oc create -f 0-dep-svc.yaml
```
Select one of the `kubis-rest` pods 
```
oc get pods | grep kubis-rest 
``` 
Start requests execution, set the value for the `X-APP-USER` to be equal to on of the `kubis-rest` pods. Half of all request should fail with 502 error 
```
curl -s -H "X-APP-USER: kubis-rest-0-3-85c7889969-c9r8m" http://kubis-gw/metadata
```
Deploy circuit breaker 
```
oc create -f 1-cb.yaml
```
Start requests execution, set the value for the `X-APP-USER` to be equal to on of the `kubis-rest` pods. After first 5 request of all request should pass with 200 OK
```
curl -s -H "X-APP-USER: kubis-rest-0-3-85c7889969-c9r8m" http://kubis-gw/metadata
```
## Cleaning up 
```
./clean.sh
```

