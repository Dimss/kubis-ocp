if [ "$#" -ne 1 ]; then
	echo -e "Missing action paramter, example usage: \nfor create: ./dep.sh create\nfor delete: ./dep.sh delete "
	exit 1
fi
for resource in *.yaml; do 
  echo -e "\nPROCESSING $resource" 
  oc $1 -f $resource; 
done;
