#!/bin/bash

cd PythonScripts


cd PythonScripts


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

