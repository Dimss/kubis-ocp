# Create image stream for REST docker images 
oc create -f is.yaml
# Create build config for REST v0.1
oc create -f bc-v0.1.yaml
# Create build config for REST v0.2
oc create -f bc-v0.2.yaml
# Trigger build for v0.1
oc start-build kubis-rest-0.1 --follow 
# Trigger build for v0.2
oc start-build kubis-rest-0.2 --follow 
# Create service 
oc create -f service.yaml
# Create deployment config for v0.1
oc create -f dc-v0.1.yaml
