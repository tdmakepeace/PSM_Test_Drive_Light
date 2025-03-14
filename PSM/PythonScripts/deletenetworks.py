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

import pen_auth, pen
import sys, json, time
import logindetails

#example use - python import_networks.py networkGen/networks_csv.json

def main():

    #NOTE - Object renaming should be disabled when using the API

    """
    The following is used for secure password storage.  Uncomment to use.

    keyring should work on modern OS.  Only tested on MAC.  Visit the following to make it work in your OS
    https://pypi.org/project/keyring/

    Must run init program first.
    """
    '''
    import keyring

    creds =  (keyring.get_credential("pensando", "admin"))

    with open('pypen_init_data.json') as json_file:
        jdata = json.load(json_file)
        PSM_IP = jdata["ip"]
        username = creds.username
        password = creds.password
    #end secure environment vars
    '''
    #static PSM vars.  Uncomment to use

    #input PSM Creds

    """ PSM_IP = 'https://10.9.9.70'
    username = 'admin'
    password = 'Pensando0$'

    """
    PSM_IP = logindetails.PSM_IP
    username = logindetails.username
    password = logindetails.password
		
    #Create auth session

    session = pen_auth.psm_login(PSM_IP, username, password)

    #if login does not work exit the program
    if session is None:
        print ("Login Failed")
        exit()

    if len(sys.argv) != 2:
        print("Usage: python script.py <input_formated_json>")
        sys.exit(1)

    input_file = sys.argv[1]
    with open(input_file) as file:
    	while data := file.readline():
    		# print(data)
    		pen.delete_psm_network(PSM_IP, session, data)

#    		
#    with open(input_file, mode='r') as file:
#        data = json.load(file)
#        
#        for i in range(len(data)):
#            print (json.dumps(data[i]))
#            pen.delete_psm_network(PSM_IP, session, data[i])
#            #time.sleep(1)
 

if __name__ == "__main__":
    main()
