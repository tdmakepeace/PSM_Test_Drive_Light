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

# Note Some of are untested with DSS PSM

import json
import requests
import uuid

def get_web_call(url, session, *payload):

    if not payload:
        data = {}
    else:
        data = payload[0]

    try:
        api_ref = session.get(url, data=json.dumps(data))

    except requests.exceptions.HTTPError as e:
        print(f"HTTP Error: {e}")
        return None

    except requests.exceptions.ConnectionError as e:
        print(f"Connection Error: {e}")
        return None

    except requests.exceptions.Timeout:
        print('Network Timeout')
        return None

    except requests.exceptions.TooManyRedirects:
        print('Too Many Redirects')
        return None

    except requests.exceptions.RequestException as e:
        print(f"Request Exception: {e}")
        return None

    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        return None

    return api_ref

def post_web_call(url, session, data):

    headers = {'Content-Type': 'application/json'} 

    try:
        api_ref = session.post(url, data=json.dumps(data), headers=headers)
        print (api_ref)
        

    except requests.exceptions.HTTPError as e:
        print(f"HTTP Error: {e}")
        return None

    except requests.exceptions.ConnectionError as e:
        print(f"Connection Error: {e}")
        return None

    except requests.exceptions.Timeout:
        print('Network Timeout')
        return None

    except requests.exceptions.TooManyRedirects:
        print('Too Many Redirects')
        return None

    except requests.exceptions.RequestException as e:
        print(f"Request Exception: {e}")
        return None

    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        return None

    return api_ref
  
  
def delete_web_call(url, session):

    headers = {'Content-Type': 'application/json'} 

    try:
        api_ref = session.delete(url, headers=headers)
        print (api_ref)
        

    except requests.exceptions.HTTPError as e:
        print(f"HTTP Error: {e}")
        return None

    except requests.exceptions.ConnectionError as e:
        print(f"Connection Error: {e}")
        return None

    except requests.exceptions.Timeout:
        print('Network Timeout')
        return None

    except requests.exceptions.TooManyRedirects:
        print('Too Many Redirects')
        return None

    except requests.exceptions.RequestException as e:
        print(f"Request Exception: {e}")
        return None

    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        return None

    return api_ref  
  
  
  
def get_networks(psm_ip, session, pretty=False):
    url = psm_ip + '/configs/network/v1/tenant/default/networks'

    if pretty:
        return makePretty(get_web_call(url, session).json())
    else:
        return get_web_call(url, session).json()

def get_psm_workloads(psm_ip, session, pretty=False):

    url = psm_ip + '/configs/workload/v1/workloads'

    if pretty:
        return makePretty(get_web_call(url, session).json())
    else:    
        return get_web_call(url, session).json()

def get_psm_cluster(psm_ip, session, pretty=False):
    url = psm_ip +'/configs/cluster/v1/cluster'

    if pretty:
        return makePretty(get_web_call(url, session).json())
    else:
        return get_web_call(url, session).json()

def get_flow_export_policy(psm_ip, session):

    url = psm_ip + '/configs/monitoring/v1/flowExportPolicy'
    return get_web_call(url, session).json()

def get_dss(psm_ip, session, pretty=False):
    url = psm_ip + '/configs/cluster/v1/distributedserviceentities'

    if pretty:
        return makePretty(get_web_call(url, session).json())
    
    else:
        dss = get_web_call(url, session).json()
        return dss

def get_config_snapshot(psm_ip, session):
    url = psm_ip + '/configs/cluster/v1/config-snapshot'
    return get_web_call(url, session).json()

def get_node1(psm_ip, session):
    url = psm_ip + '/configs/cluster/v1/nodes/node1'
    return get_web_call(url, session).json()

def get_networksecuritypolicy(psm_ip, session,pretty=False):
    url = psm_ip + '/configs/security/v1/networksecuritypolicies'

    if pretty:
        return(makePretty(get_web_call(url, session).json()))
    else:
        return get_web_call(url, session).json()

def get_Specificpolicy(psm_ip, session, policyName,pretty=False):
    url = psm_ip + '/configs/security/v1/networksecuritypolicies/' + policyName
    return get_web_call(url, session).json()

def get_users(psm_ip, session, tenant,pretty=False):
    url = psm_ip + '/configs/auth/v1/tenant/{t}/users'.format(t=tenant)
    return get_web_call(url, session).json()

def get_psm_metrics(psm_ip, session, psm_tenant, st, et):

    data = {
    "queries": [
        {
            "Kind": "Node",
            "start-time": st,
            "end-time": et
        }
    ]
}

    url = psm_ip + 'telemetry/v1/metrics'

    return get_web_call(url, session, data).json()



def get_dsc_metrics(psm_ip, session, psm_tenant, interface, st, et):

    data = {
    "queries": [
        {
            "Kind": "DistributedServiceCard",
            "selector": {
                "requirements": [
                    {
                        "key": "reporterID",
                        "operator": "equals",
                        "values": [interface]
                    }
                ]
            },
            "start-time": st,
            "end-time": et
        }
                ]
            }

    url = psm_ip + 'telemetry/v1/metrics'

    return get_web_call(url, session, data).json()


def get_uplink_metrics(psm_ip, session, psm_tenant, st, et):

    data = {
    "queries": [
        {
            "Kind": "MacMetrics",
            "start-time": st,
            "end-time": et
        }
                ]
            }

    url = psm_ip + 'telemetry/v1/metrics'

    return get_web_call(url, session, data).json()

def get_pf_metrics(psm_ip, session, psm_tenant, st, et):

    data = {
    "queries": [
        {
            "Kind": "LifMetrics",
            "start-time": st,
            "end-time": et
        }
                ]
            }

    url = psm_ip + 'telemetry/v1/metrics'

    return get_web_call(url, session, data).json()

def get_cluster_metrics(psm_ip, session, psm_tenant, st, et):

    data = {
    "queries": [
        {
            "Kind": "Cluster",
            "start-time": st,
            "end-time": et
        }
                ]
            }

    url = psm_ip + 'telemetry/v1/metrics'

    return get_web_call(url, session, data).json()

def get_fw_logs(psm_ip, session, psm_tenant, interface, st, et):
    connector = '_'
    extension = '.csv.gzip'

    #generate the log first
    url1 = '{psm}objstore/v1/tenant/{tenant}/fwlogs/objects?field-selector=' \
        'start-time={start},end-time={end},dsc-id={int},vrf-name={tenant}'.format \
        (psm=psm_ip, int=interface, tenant=psm_tenant, start=st, end=et)
    t = get_web_call(url1, session)


    #pull the download link from the log generation response
    link = str(t.json()['items'][0]['meta']['name'])
    formatLink = link.replace("/", "_")

    #craft download url and download the data
    url = '{psm}objstore/v1/downloads/tenant/default/fwlogs/{link}'.format(psm=psm_ip, link=formatLink)

    w = get_web_call(url, session)

    return w.content

def get_alerts(psm_ip, session, tenant):

    data = {
    "kind": "AlertPolicy",
    "api-version": "v1",
    "meta": {
        "name": "alertPolicy1",
        "tenant": tenant,
        "namespace": "default"
            }
            }

    url = psm_ip + 'configs/monitoring/v1/alerts'

    return get_web_call(url, session, data).json()


def makePretty(data):
    return json.dumps(data, indent=2)

def create_ipcollections(psm_ip, session, jdata):

    url = psm_ip + '/configs/network/v1/tenant/default/ipcollections'

    return post_web_call(url, session, jdata)
    
def create_apps(psm_ip, session, jdata):

    url = psm_ip + '/configs/security/v1/tenant/default/apps'
    
    return post_web_call(url, session, jdata)

def get_psm_apps(psm_ip, session, pretty=False):

    url = psm_ip + '/configs/security/v1/tenant/default/apps'

    if pretty:
        return makePretty(get_web_call(url, session).json())
    else:    
        return get_web_call(url, session).json()
    
def get_psm_ipcollections(psm_ip, session, pretty=False):

    url = psm_ip + '/configs/network/v1/tenant/default/ipcollections'

    if pretty:
        return makePretty(get_web_call(url, session).json())
    else:    
        return get_web_call(url, session).json()
    
def create_psm_policy(psm_ip, session, jdata):

    url = psm_ip + '/configs/security/v1/networksecuritypolicies'

    return post_web_call(url, session, jdata)
    
def delete_psm_policy(psm_ip, session, data):

    url = psm_ip + '/configs/security/v1/networksecuritypolicies/'+ data
    stripurl = url.strip()
    # print("\"",stripurl,"\"")

    return delete_web_call(stripurl, session)
    

def is_uuid(uuid_2_test):

    try:
        uuid_data = uuid.UUID(uuid_2_test, version=4)
        return str(uuid_data) == uuid_2_test

    except ValueError:
        return False
    
def create_psm_network(psm_ip, session, jdata):

    url = psm_ip + '/configs/network/v1/tenant/default/networks'

    return post_web_call(url, session, jdata)
    
def delete_psm_network(psm_ip, session, data):

    url = psm_ip + '/configs/network/v1/tenant/default/networks/'+ data
    stripurl = url.strip()
    # print("\"",stripurl,"\"")

    return delete_web_call(stripurl, session)
    
def create_psm_vrf(psm_ip, session, jdata):

    url = psm_ip + '/configs/network/v1/tenant/default/virtualrouters'

    return post_web_call(url, session, jdata)
    
def delete_psm_vrf(psm_ip, session, data):

    url = psm_ip + '/configs/network/v1/tenant/default/virtualrouters/'+ data
    stripurl = url.strip()
    # print("\"",stripurl,"\"")

    return delete_web_call(stripurl, session)
    
    
def create_psm_role(psm_ip, session, jdata):

    url = psm_ip + '/configs/auth/v1/tenant/default/roles'

    return post_web_call(url, session, jdata)
    
def delete_psm_role(psm_ip, session, data):

    url = psm_ip + '/configs/auth/v1/tenant/default/roles/'+ data
    stripurl = url.strip()
    # print("\"",stripurl,"\"")

    return delete_web_call(stripurl, session)    
    
    
def create_psm_rolebinding(psm_ip, session, jdata):

    url = psm_ip + '/configs/auth/v1/tenant/default/role-bindings'

    return post_web_call(url, session, jdata)
    
def delete_psm_rolebinding(psm_ip, session, data):

    url = psm_ip + '/configs/auth/v1/tenant/default/role-bindings/'+ data
    stripurl = url.strip()
    # print("\"",stripurl,"\"")

    return delete_web_call(stripurl, session)    
    
    



    
def create_psm_user(psm_ip, session, jdata):

    url = psm_ip + '/configs/auth/v1/tenant/default/users'

    return post_web_call(url, session, jdata)
    
def delete_psm_user(psm_ip, session, data):

    url = psm_ip + '/configs/auth/v1/tenant/default/users/'+ data
    stripurl = url.strip()
    # print("\"",stripurl,"\"")

    return delete_web_call(stripurl, session)    