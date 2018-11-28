PROJECT_NAME=kuibs
oc new-project ${PROJECT_NAME}
oc adm policy add-scc-to-user anyuid -z default -n ${PROJECT_NAME}
oc adm policy add-scc-to-user privileged -z default -n ${PROJECT_NAME}
oc create -f common/openjdk18-is.yaml
oc create -f common/tel-dc.yaml

