# Authorization
This is Istio Authorization description 

## Play the Demo

Create service accounts 

`oc create -f 0-sa.yaml`

Update SCC to allow created SAs to run with `anyuid` policy (required by Istio proxy sidecar container)

`./1-css.sh`

Enable RBAC 

`oc create -f 2-enable-rabc.yaml`

Deploy `kubis-gw`, `kubis-rest` and `tkit`

`oc create -f 3-dep-svc.yaml`

Execute request from `kubis-gw` to `kubis-rest`, the request should fail with HTTP 403 error. 

Example output:
```
*   Trying 172.30.11.159...
* TCP_NODELAY set
* Connected to kubis-gw (172.30.11.159) port 80 (#0)
> GET /metadata HTTP/1.1
> Host: kubis-gw
> User-Agent: curl/7.54.0
> Accept: */*
>
< HTTP/1.1 403 Forbidden
< content-length: 19
< content-type: text/plain
< date: Tue, 04 Dec 2018 13:23:50 GMT
< server: envoy
< x-envoy-upstream-service-time: 1
<
* Connection #0 to host kubis-gw left intact
RBAC: access denied
```

Create RBAC policy for whole namespace scope to allow read access between all services in the `kubis` namespace 
`oc create -f 4-read-service-role.yaml`

Execute request from `kubis-gw` to `kubis-rest`, everything should works as expected. (please note, the RBAC policy may take some time to become active)

`curl -s  -v  http://kubis-gw/metadata  | jq . -C`

Example output:

```
{
  "status": "ok",
  "data": {
    "hostname": "kubis-rest-7d8b759689-jhxgc"
  }
}
```

Execute `POST` request from `kubis-gw` to `kubis-rest` 

`curl -s -H "Content-Type: application/json" -H POST --data '{"message":"first message in the queue"}' http://kubis-gw/message`

The request fail with 403 error, since by default RBAC is blocking all requests except `GET` in the `kubis` namespace

Create a policy to allow execution of  `POST` requests only to service account: `tkit`

`oc create -f 5-write-rest-service-role.yaml`

Execute request from `tkit` to `kubis-rest`, everything should works as expected
```
oc exec $(oc get pods  | grep tkit | awk '{print $1}') -c tkit sh -- -c "echo '{\"message\":\"first message in the queue\"}' > /tmp/msg"
oc exec $(oc get pods  | grep tkit | awk '{print $1}') -c tkit sh -- -c 'cat /tmp/msg | curl -s -H "Content-Type: application/json" -H POST --data @- http://kubis-rest/v1/system/message'
```

Example output: 
```
{"status":"ok"}
```
Execute `POST` request from `kubis-gw` to `kubis-rest`, request should fail again, as expected.

Only `tkit` service account is allowed to execute POST request to `kubis-rest`. 

Any other SA will be blocked by RBAC. 

`curl -s -H "Content-Type: application/json" -H POST --data '{"message":"first message in the queue"}' http://kubis-gw/message`

Example output:
```
RBAC: access denied
```
Allow `kubis-gw` execute `POST` requests to `kubis-rest`, everything should works as expected

`oc create -f 6-write-gw-service-role.yaml`

Example output: 
```
{"status":"ok"}
```
## Cleaning up 
`./clean.sh`

