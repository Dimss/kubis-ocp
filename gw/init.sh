# Create image stream for Gateway docker images 
oc create -f is.yaml
# Create build config 
oc create -f bc.yaml
# Trigger build 
oc start-build kubis-gw --follow
# Create service 
oc create -f service.yaml
# Create deployment config
oc create -f dc.yaml
