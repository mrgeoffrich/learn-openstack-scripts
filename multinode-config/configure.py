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
import paramiko
from termcolor import colored, cprint

def generate_network_config(template_filename, output_filename, replacement_dict):
    """
    Takes a template network configuration file and replaces the values.
    """
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

def main():
    """
    Function docstring
    """
    parser = argparse.ArgumentParser(description='Set up VMs for openstack-ansible deployment.')
    parser.add_argument('--compute-address', type=str, default='', required=True,
                        help='The address of the compute node to initially log in to.')
    parser.add_argument('--compute-ip', type=str, default='', required=True,
                        help='The static IP address of the compute node to assign to it.')
    args = parser.parse_args()
    if ping(args.compute_address):
        cprint('Compute server contactable via ping.', 'green')
    else:
        cprint('Compute server not contactable via ping.', 'red')
    if test_ssh_connection(args.compute_address, 'vagrant', 'vagrant'):
        cprint('Compute server contactable via SSH.', 'green')
    else:
        cprint('Compute server not contactable via SSH.', 'red')
    replacement_dict = dict(primary_eth='eth0', dns1='8.8.8.8', dns2='8.8.4.4')
    generate_network_config('infra-network.conf', './generated/infra-network.conf', replacement_dict)

if __name__ == '__main__':
    main()
