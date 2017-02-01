This HEAT Orchestration Template (HOT) creates a custom Docker swarm cluster at MTA CLOUD (at least on the datacenter operated by MTA SZTAKI)

Usage
-----

* Apply for resources at https://cloud.mta.hu/ - be sure to specify that you are planning to use HEAT Orchestration
* Once your request is approved, log in to the OpenStack Dashboard and select Orchestration -> Stacks -> Launch Stack
* Select URL as template source then enter https://raw.githubusercontent.com/mcree/mtacloud/master/hot/docker-swarm/docker-swarm.yaml to the corresponding field (Template URL), then press next
* Fill in the stack parameters
 * Stack name: your choice
 * Creation timeut: leave on default
 * Rollback on failure: your choice
 * Password for user: your openStack password (change/create yours at the settings menu)
 * Bootstrap port: leave on default
 * Docker hosts: number of docker swarm hosts to start (excluding the master)
 * Flavor: your choice
 * Image: leava on default
 * Private network name: choose your network
 * Piblic IP: enter a _free_ public floating IP address (mandatory, for your available floating IPs, visit Compute -> Access & Security -> Floating IPs)
* Launch the stack and wait for it to be created
* Once the stack is launched you will be presented with a bootstrap command (Output section of the Stack Overview pane)
* Run the provided bootstrap command (also see usage examples)

Bootstrapping
-------------

Several utility images are provided for enhancing your swarm experience:
* https://hub.docker.com/r/mcreeiw/httpsd-static/ is used for providing keys and certificates needed for getting in touch with your VMs and Docker nodes
* https://hub.docker.com/r/mcreeiw/swarmentry/ is provided for convenient bootstrapping and cluster access
