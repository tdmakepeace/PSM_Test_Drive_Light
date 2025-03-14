# Copyright (c) 2024, AMD
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
# Author: Ryan Tischer ryan.tischer@amd.com

import csv
import json
import sys

#example use - "python netgencsv.py exampleCSV.csv"

# Read CSV data from a file and convert it to a list of dictionaries
def read_csv_data(file_path):
    data = []
    with open(file_path, mode='r') as csv_file:
        csv_reader = csv.DictReader(csv_file)
        for row in csv_reader:
            data.append(row)   
    return data

# Function to write data to a JSON file
def write_to_json_file(data, filename):
    with open(filename, 'w') as json_file:
        json.dump(data, json_file, indent=4)

# Main function
def main():
    if len(sys.argv) != 2:
        print("Usage: python script.py <input_csv_file>")
        sys.exit(1)

    input_csv_file = sys.argv[1]
    csv_data_parsed = read_csv_data(input_csv_file)

    csv_data_complete = []

    #add to json for easy post to PSM
    for item in csv_data_parsed:
        json_template = {
        
        "meta": {
        "name": item.get("name")
    		  },
      "spec": {
      			"type": "unknown",
            "ingress-security-policy": [ item.get("ingress-security-policy")],
            "egress-security-policy": [item.get("egress-security-policy")],
            "allow-session-reuse": "disable",
		        "connection-tracking-mode": item.get("connection-tracking-mode"),
		        "ip-fragments-forwarding": item.get("ip-fragments-forwarding")
		      }
      }
        

        #check if security policy is "None" and change to none type 
        #we have to due this because the PSM hates users 
        #seriously we hate you

        if json_template ["spec"]["ingress-security-policy"] == ["None"]:
            json_template ["spec"]["ingress-security-policy"] = None

        if json_template ["spec"]["egress-security-policy"] == ["None"]:
            json_template ["spec"]["egress-security-policy"] = None

        csv_data_complete.append(json_template)
        
    write_to_json_file(csv_data_complete, 'vrf_csv.json')
    print("Data has been written to vrf_csv.json")
    
    
    f = open('vrf_list.txt','w')
    for item in csv_data_parsed:
    	name = item.get("name")
    	f.write(name)
    	f.write('\n')
    	
    f.close()
    print("Data has been written to vrf_list.txt")
    

if __name__ == "__main__":
    main()
