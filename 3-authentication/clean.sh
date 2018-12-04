for resource in *.yaml; do 
  echo -e "\nPROCESSING $resource" 
  # oc $1 -f $resource; 
  oc delete -f $resource; 
done;
