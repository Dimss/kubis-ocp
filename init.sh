# Create  project, update SCC to allow anyuid (root) for Invoy proxy 
PROJECT_NAME=kubis
oc new-project ${PROJECT_NAME}
oc adm policy add-scc-to-user anyuid -z default -n ${PROJECT_NAME}
oc adm policy add-scc-to-user privileged -z default -n ${PROJECT_NAME}

# Add OpenJDK image stream for S2I java build 
oc create -f common/openjdk18-is.yaml

# Add telepresence  
oc create -f common/tel-dc.yaml

echo "Wait 10 sec for openjdk18 IS to become in sync"
sleep 10

# Init Gateway service 
echo "Init Gateway service"
cd gw && ./init.sh

# Init REST service
echo "Init REST service"
cd ../rest && ./init.sh 
