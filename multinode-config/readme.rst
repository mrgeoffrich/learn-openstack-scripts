
Run `python configure.py` with a series of command line arguments to prepare the environment for
an openstack-ansible deployment.

Steps:

* Validate command line arguments
* Validate environment - SSH in to each machine, check hostname, check current IP address.
* Generate network configuration files from templates using supplied command line arguments.
* Transfer network configuration files on to each machine.
* Revaliate the machines are still contactable and ready.
* Generate openstack-ansible yaml files required for installation.
* Transfer openstack-ansible yaml files on to the deployment server.
* Write to stdout the next steps for the user to begin installation.

Also ensure each step is logged appropriately to stdout to tell the user what the program is doing.

Also log to log.txt, generate files into the generated-files subfolder.