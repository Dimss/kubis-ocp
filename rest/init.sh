oc create -f is.yaml
oc create -f bc.yaml
oc create -f service.yaml
oc start-build kubis-rest --follow
