#!/bin/bash





cd PythonScripts

file="logindetails.py"

if [ ! -e "$file" ]; then
		echo "What is the PSM host IP"
		read psm
		echo "enter the username for PSM (admin account)"
		read userpsm
		echo "enter the password"	
		read passpsm
		
		echo "PSM_IP = 'https://"$psm"'
username = '"$userpsm"'
password = '"$passpsm"'
		" > $file
		
sleep 1
fi


python3 networks.py ../CSV_example/networks.csv
python3 role.py ../CSV_example/role.csv
python3 user.py ../CSV_example/user.csv
python3 vrf.py ../CSV_example/vrf.csv
python3 policy_FIRST.py ../CSV_example/policy_FIRST.csv
python3 policy_NEW.py ../CSV_example/policy_NEW.csv
# python3 workloadgroup.py ../CSV_example/workloadgroup.csv

sleep 5 

python3 importpolicy.py policy_FIRST_csv.json
python3 importpolicy.py policy_NEW_csv.json
python3 importvrf.py vrf_csv.json
python3 importnetworks.py networks_csv.json

sleep 2
python3 importuser.py user_csv.json
python3 importrole.py role_csv.json

sleep 2
python3 importrolebinding.py rolebinding_csv.json
#  python3 importworkloadgroup.py workloadgroup_csv.json

sleep 2
rm *.txt
rm *.json
