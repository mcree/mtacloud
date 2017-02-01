This HEAT Orchestration Template (HOT) creates a custom Docker swarm cluster at MTA CLOUD (at least on the datacenter operated by MTA SZTAKI)

Usage
-----

* Apply for resources at https://cloud.mta.hu/ - be sure to specify that you are planning to use HEAT Orchestration
* Once your request is approved, log in to the OpenStack Dashboard and select Orchestration -> Stacks -> Launch Stack
* Select URL as template source then enter https://raw.githubusercontent.com/mcree/mtacloud/master/hot/docker-swarm/docker-swarm.yaml to the corresponding field (Template URL)
* Fill in the stack parameters
* Launch the stack
* Once the stack is launched you will be presented with a bootstrap command (Output section of the Stack Overview pane)
* Run the bootstrap command (also see usage examples)
