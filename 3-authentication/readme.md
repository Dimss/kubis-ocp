# Authentication 
This is Isito authentication descritpion 

## Play the demo 

### Deploy 3 services 
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

#### Execute HTTP requests
Execute requests between services behind sidecars, everything should works as expected 

`curl -s http://kubis-gw/metadata | jq -C .` 

Example output: 
```
{
  "status": "ok",
  "data": {
    "hostname": "kubis-rest-85c7889969-gdvp9"
  }
}
```

Execute request to service without a sidecar, the request should fail with 503 HTTP error. 

`curl -s -H "X-APP-USER: insec" http://kubis-gw/metadata | jq -C .` 

Example output: 
```
Dec 04, 2018 12:18:02 PM io.vertx.kubisgw.MainVerticle
SEVERE: Error during fetching kubis-rest metadata, Status code: 503
Dec 04, 2018 12:18:02 PM io.vertx.ext.web.impl.RoutingContextImplBase
SEVERE: Unexpected exception in route
(RECIPIENT_FAILURE,-1)
	at io.vertx.kubisgw.kubisrest.KubisRestServiceVertxProxyHandler.lambda$createHandler$0(KubisRestServiceVertxProxyHandler.java:154)
  ...
```

Add `DestinationRule` for `kubis-rest-insec` to allow insecure access (clear text) to the `kubis-rest-insec` instance 
`oc create -f 3-rest-insec-dest-rule.yaml`

Now, try execute request from secured `rest-gw` instance to insecure `kubis-rest-insec`, everything should works as expected. 

`curl -s -H "X-APP-USER: insec" http://kubis-gw/metadata | jq -C .` 

Example output: 
```
{
  "status": "ok",
  "data": {
    "hostname": "kubis-rest-insec-688f6d9cb7-h5flr"
  }
}
```
## Policies

### Mesh scope policy
Check existing authentication policy `oc get meshpolicies.authentication.istio.io`. 
This policy is create by default when RH ServiceMesh installed with `authentication=true` (https://docs.openshift.com/container-platform/3.11/servicemesh-install/servicemesh-install.html#custom-resource-parameters)

### Namespace scope policy 
Create a policy in namespace scope which is by default doesn't uses any authentication mechanisms

`oc create -f 4-ns-scope-policy.yaml`

Execute request from `kubis-gw` to `kubis-rest`, the request should fail with 503 error. 
The request is failing because `4-ns-scope-policy.yaml` instructing all services in the `kubis` namespace, 
talk to each other in clear text, while in fact, both `kubis-gw` and `kubis-rest` are expecting the receive mTLS traffic. 

Example output:
```
*   Trying 172.30.135.143...
* TCP_NODELAY set
* Connected to kubis-gw (172.30.135.143) port 80 (#0)
> GET /metadata HTTP/1.1
> Host: kubis-gw
> User-Agent: curl/7.54.0
> Accept: */*
> X-APP-USER: insec1
>
< HTTP/1.1 503 Service Unavailable
< content-length: 57
< content-type: text/plain
< date: Tue, 04 Dec 2018 12:35:47 GMT
< server: envoy
```

### Service scope  policy 

Create a service scope policy to allow secure communication between `kubis-gw` and `kubis-rest` by overwriting Namespace scope policy.

`oc create -f 5-svc-scope-policy.yaml`

Execute request from `kubis-gw` to `kubis-rest`, everything should works as expected. 

Example output:
```
{
  "status": "ok",
  "data": {
    "hostname": "kubis-rest-85c7889969-gdvp9"
  }
}
```

Execute request from `kubis-gw` to `kubis-rest-insec` to make sure it's still accessible by clear text. 

Example output: 
```
{
  "status": "ok",
  "data": {
    "hostname": "kubis-rest-insec-688f6d9cb7-h5flr"
  }
}
```

## Cleaning up 
`./clean.sh`