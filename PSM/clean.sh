#!/bin/bash

cd PythonScripts


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
python3 deleterolebinding.py rolebinding_list.txt
python3 deleterole.py role_list.txt
python3 deleteuser.py user_list.txt
python3 deletenetworks.py networks_list.txt
python3 deletevrf.py vrf_list.txt
python3 deletepolicy.py policy_FIRST_list.txt
python3 deletepolicy.py policy_NEW_list.txt
# python3 deleteworkloadgroup.py workloadgroup_list.txt

sleep 2
rm *.txt
rm *.json

