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
* https://hub.docker.com/r/mcreeiw/httpsd-static/ is used for providing keys and certificates needed for getting in touch with your VMs and Docker nodes - you can safely kill this image after successful bootstrapping
* https://hub.docker.com/r/mcreeiw/swarmentry/ is provided for convenient bootstrapping and cluster access

Showcase
--------

Bootstrapping (commands run after HEAT cluster creation):
~~~~
~# docker run -v /tmp/swarm:/entry mcreeiw/swarmentry bootstrap 1.2.3.4 4990 XXXTOKENXXX
+ bootstrapping from https://1.2.3.4:4990/XXXTOKENXXX
# 1.2.3.4:22 SSH-2.0-OpenSSH_7.2p2 Ubuntu-4ubuntu1
+ done
~~~~

Usage:
~~~~
~# docker run -v /tmp/swarm:/entry mcreeiw/swarmentry usage
usage: swarmentry command ARGS

commands:

    cmd         run a shell command
                example: 
                    cmd echo "hello"

    bootstrap   set up initial environment in /entry
                note:
                    you should mount a persistent directory in /entry
                    eg: docker run -v /tmp/myswarm:/entry mcreeiw/swarmentry bootstrap ...
                parameters (in order): 
                    IP          bootstrap IP address
                    PORT        bootstrap TCP port
                    TOKEN       bootstrap token
                example:
                    bootstrap   1.2.3.4 4990 0YwZAdpihVO2oTU77JJm9f4wAOtTB8fXVyMMm9aTvdahJYItzmQ8PzHLyNujBGnh

    docker      run docker with ARGS command on swarm master
                example:
                    docker service ls

    ssh         run ssh with ARGS on swarm master
                notes:
                    do not forget to use docker parameters -t and -i for interactive sessions
                example:
                    ssh hostname

    eval        print configured aliases for ssh and docker
                parameters (in order):
                    CONFDIR     configuration file directory (populated by bootstrap command)
                example:
                    eval ~/myswarm
                    
    usage       print usage
    
~~~~

List remote containers:
~~~~
~# docker run -v /tmp/swarm:/entry mcreeiw/swarmentry docker ps
CONTAINER ID        IMAGE                   COMMAND                  CREATED             STATUS              PORTS                   NAMES
da29b08a6a1f        mcreeiw/httpsd-static   "/work/entrypoint...."   4 minutes ago       Up 4 minutes        0.0.0.0:4990->443/tcp   jolly_pare
~~~~

SSH to master host (you have to change default password, which is 'ubuntu'):
~~~~
~# docker run -ti -v /tmp/swarm:/entry mcreeiw/swarmentry ssh
You are required to change your password immediately (root enforced)
WARNING: Your password has expired.
You must change your password now and login again!
Changing password for ubuntu.
(current) UNIX password: 
Enter new UNIX password: 
Retype new UNIX password: 
passwd: password updated successfully
Connection to 1.2.3.4 closed.
~# docker run -ti -v /tmp/swarm:/entry mcreeiw/swarmentry ssh
ubuntu@swarm-master:~$ 
~~~~

Run http://portainer.io/ (swarm web gui) on the swarm cluster (published on port 9000):
~~~~
~# docker run -v /tmp/swarm:/entry mcreeiw/swarmentry docker service create --name portainer --publish 9000:9000 --constraint 'node.role == manager' --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock portainer/portainer -H unix:///var/run/docker.sock
~# docker run -v /tmp/swarm:/entry mcreeiw/swarmentry docker service list
ID            NAME       MODE        REPLICAS  IMAGE
lo0b9bxwcwf2  portainer  replicated  1/1       portainer/portainer:latest
~~~~
