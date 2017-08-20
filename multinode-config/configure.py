#!/usr/bin/env python

"""
Creates a series of network configuration files and openstack-ansible installation yaml files based
on command line arguments. These files are then transferred on to the target machines
to prepare them for an openstack installation. This should automate a somewhat difficult and error
prone task.
"""
import os
import argparse
from platform import system as system_name # Returns the system/OS name
from os import system as system_call       # Execute a shell command
from string import Template
import json
import paramiko
from termcolor import cprint

def generate_network_config(template_filename, output_filename, replacement_dict):
    """
    Takes a template network configuration file and replaces the values.
    """
    if not os.path.exists(template_filename):
        cprint('Config file ' + template_filename + ' does not exist', 'red')
    else:
        with open(template_filename, "r") as template_file:
            data = template_file.read()
            template = Template(data)
            write_data = template.substitute(replacement_dict)
            if not os.path.exists('./generated'):
                os.makedirs('./generated')
            with open(output_filename, "w+") as output_file:
                output_file.write(write_data)

def ping(host):
    """
    Returns True if host (str) responds to a ping request.
    Remember that some hosts may not respond to a ping request even if the host name is valid.
    """
    parameters = "-n 1" if system_name().lower() == "windows" else "-c 1"
    return system_call("ping " + parameters + " " + host) == 0

def test_ssh_connection(name, login_username, login_password):
    """
    Tests to see if SSH is working. Returns True is SSH is available and can be logged in to.
    """
    try:
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(name, username=login_username, password=login_password)
        return True
    except:
        return False

def transfer_file(name, login_username, login_password, local_file, remote_file):
    """
    Transfers a local file on to a remote host via SFTP
    """
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(name, username=login_username, password=login_password)
    sftp = ssh.open_sftp()
    print('Copying ' + local_file + ' to ' + name + ' at ' + remote_file)
    sftp.put(local_file, remote_file)
    sftp.close()

def load_json_config(filename):
    """
    Load configuration settings from a JSON file
    """
    with open(filename) as data_file:
        data = json.load(data_file)
        return data

def validate_json(json_data, server_list):
    """
    Check that the JSON data is well formed.
    """
    for key in server_list:
        if key not in json_data:
            raise ValueError(key + ' value is not in the JSON file')

def check_server(ipaddress, username, password, description):
    """
    Check a server via ping and SSH to see if it is alive. Return false if any check fails.
    """
    server_ok = True
    if ping(ipaddress):
        cprint(description + ' server contactable via ping.', 'green')
    else:
        cprint(description + ' server not contactable via ping.', 'red')
        server_ok = False
    if test_ssh_connection(ipaddress, username, password):
        cprint(description + ' server contactable via SSH.', 'green')
    else:
        cprint(description + ' server not contactable via SSH.', 'red')
        server_ok = False
    return server_ok

def main():
    """
    Validate servers exist and change their network configuration
    """
    parser = argparse.ArgumentParser(description='Set up VMs for openstack-ansible deployment.')
    parser.add_argument('config_file', type=str, default='',
                        help='A JSON file that contains the address for all the machines.')
    args = parser.parse_args()
    json_data = load_json_config(args.config_file)
    # A list of all the servers we expect to be in the config file and ready for deployment
    # Potentially this can go in a config file somewhere.
    server_list = {'os_deploy_ip' : {'name':'os-deploy', 'filename':'deploy-network.conf'},
                   'os_compute_ip' : {'name':'os-compute', 'filename':'compute-network.conf'},
                   'os_network_ip' : {'name':'os-network', 'filename':'network-network.conf'},
                   'os_storage_ip' : {'name':'os-storage', 'filename':'storage-network.conf'},
                   'os_infrastructure_ip' : {'name':'os-infrastructure',
                                             'filename':'infrastructure-network.conf'},
                   'os_controller_ip' : {'name':'os-controller',
                                         'filename':'controller-network.conf'}}
    validate_json(json_data, server_list)
    default_username = 'vagrant'
    default_password = 'vagrant'

    all_servers_ok = True
    for key in server_list:
        if not check_server(json_data[key], default_username,
                            default_password, server_list[key]['name']):
            all_servers_ok = False

    if not all_servers_ok:
        cprint('At least one server is not available. Aborting.', 'red')
        return
    else:
        cprint('All servers are contactable for deployment.', 'green')

    # TODO: Make the primary_eth configurable via the command line as it changes base on hypervisor
    json_data['primary_eth'] = 'eth0'
    for key in server_list:
        generate_network_config(server_list[key]['filename'], './generated/' +
                                server_list[key]['filename'], json_data)
    for key in server_list:
        transfer_file(json_data[key], default_username, default_password, './generated/' + server_list[key]['filename'], '/home/vagrant/interfaces')

if __name__ == '__main__':
    main()
