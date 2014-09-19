Deploy Sensu monitoring tool with SaltStack
=========

Salt states for Sensu server (with Uchiwa dashboard) and clients deployment.
Tested on Ubuntu 12.04.

Test environment with Vagrant
==============

If you want to test this deployment on your local machine inside VMs, the easiest way is to use Vagrant with VirtualBox provider. All you need is to go inside vagrant directory and run:

    cd vagrant && vagrant up

This will bring up 3 VMs, one master and 3 minion nodes. Sensu server with redis, rabbitmq and Uchiwa dashboard will be deployed on master and all nodes will act as Sensu clients. Environment description is located here: pillar/environment.sls

Test the connectivity between master and minions:

    vagrant ssh master
    sudo salt '*' test.ping
    
If everything is OK you can proceed with Sensu deployment step: https://github.com/komljen/sensu-salt#deployment

Prepare your environment
==============

For non Vagrant environment you need Salt master and minions installed and running on all nodes and minions keys should be accepted.

Salt states and pillars
--------------

Clone this git repository:

    rm -rf /srv/salt /srv/pillar
    cd /srv && git clone https://github.com/komljen/sensu-salt.git .

Configuration options
--------------

Environment description file with examples is located here: pillar/environment.sls. Edit this file to match with your environment:

    nodes:
      master:
        roles:
          - sensu-server
          - sensu-client
      node01:
        roles:
          - sensu-client
      node02:
        roles:
          - sensu-client

Sensu configuration files will be generated automatically. Edit pillar/data/sensu.sls if you want to make additional changes:

    sensu:
      server:
        interface: eth1
        rabbitmq:
          user: sensu
          password: secret
          vhost: "/sensu"
          ssl: false
        dashboard:
          uchiwa:
           user: admin
           password: admin
           port: 3000
      client:
        interface: eth1

Proceed with deployment step after changes are done.

Deployment
==============

First you need to run highstate to add roles to minions based on environment.sls file:

    salt '*' state.highstate

To start Sensu deployment run orchestrate state from Salt master:

    salt-run -l debug state.orchestrate orchestrate.sensu
    
It will take a few minutes to complete. Then you can check Sensu status on Uchiwa dashboard:

    http://localhost:3000

