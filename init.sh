#!/bin/bash
# Create  project, update SCC to allow anyuid (root) for Invoy proxy 
PROJECT_NAME=kubis
oc new-project ${PROJECT_NAME}
oc adm policy add-scc-to-user anyuid -z default -n ${PROJECT_NAME}
oc adm policy add-scc-to-user privileged -z default -n ${PROJECT_NAME}
# Add Image streams
oc create -f init/1-openjdk18-is.yaml
# Must sleep before continue, openjdk18 image stream should fetch the openjdk18 image metadata 
sleep 10
oc create -f init/2-gw-is.yaml 
oc create -f init/3-rest-is.yaml 
# Add Build configs
oc create -f init/4-gw-bc.yaml
oc create -f init/5-rest-bc-v0.1.yaml
oc create -f init/6-rest-bc-v0.3.yaml
# Build images 
oc start-build kubis-gw --follow
oc start-build kubis-rest-0.1 --follow 
oc start-build kubis-rest-0.3 --follow 
# Add telepresence  
oc create -f init/7-dep-tel.yaml
# Delete finishded build jobs 
oc get pods | grep build  | awk '{print $1}' | xargs oc delete pod