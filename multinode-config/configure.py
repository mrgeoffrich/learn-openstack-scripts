#!/usr/bin/env python
"""
Creates a series of network configuration files and openstack-ansible installation yaml files based
on command line arguments. These files are then transferred on to the target machines
to prepare them for an openstack installation. This should automate a somewhat difficult and error
prone task.
"""
import sys

def main():
    """
    Function docstring
    """
    print 'Hello there', sys.argv[1]

if __name__ == '__main__':
    main()
