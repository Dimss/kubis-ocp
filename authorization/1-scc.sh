PROJECT_NAME=kubis

oc adm policy add-scc-to-user anyuid -z kubis-gw -n ${PROJECT_NAME}
oc adm policy add-scc-to-user privileged -z kubis-gw -n ${PROJECT_NAME}

oc adm policy add-scc-to-user anyuid -z tkit -n ${PROJECT_NAME}
oc adm policy add-scc-to-user privileged -z tkit -n ${PROJECT_NAME}
