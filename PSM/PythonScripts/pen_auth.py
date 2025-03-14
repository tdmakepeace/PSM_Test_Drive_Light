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

import requests
import json

#get rid of insecure warnings -
from urllib3.exceptions import InsecureRequestWarning
requests.packages.urllib3.disable_warnings(category=InsecureRequestWarning)

def psm_login (psm_ip, username, password):

    auth_data = {
        "username": username,
        "password": password,
        "tenant": "default"
    }

    data_to_send = json.dumps(auth_data)

    #Create session for PSM
    
    headers = {'Content-Type': 'application/json'}

    session = requests.Session()
    session.verify = False

    #working
    URL = psm_ip + '/v1/login'

    try:
        auth = session.post(URL, data_to_send, headers=headers, timeout=3)
        auth.raise_for_status()

    except requests.exceptions.HTTPError as e:
        print(f"HTTP Error: {e}")
        return None

    except requests.exceptions.ConnectionError as e:
        print(f"Connection Error: {e}")
        return None

    except requests.exceptions.Timeout:
        #print('Network Timeout')
        return True

    except requests.exceptions.TooManyRedirects:
        print('Too Many Redirects')
        return None

    except requests.exceptions.RequestException as e:
        print(f"Request Exception: {e}")
        return None

    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        return None

    return session


