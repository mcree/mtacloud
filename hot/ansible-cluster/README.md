
Start your HEAT cluster from https://raw.githubusercontent.com/mcree/mtacloud/master/hot/ansible-cluster/ansiblecluster%40mtacloud.yaml

Create a working directory on your local machine (eg.: /tmp/workdir)

Save cluster private ssh access key from HEAT cluster creation output (eg. to /tmp/workdir/cluster_key.private)

Verify that you can access your cluster jump host from your local machine (eg.: at 1.2.3.4):
~~~
ssh -i /tmp/workdir/cluster_key.private -l ubuntu 1.2.3.4
~~~

Install ansible and python openstack libraries on your local machine (the following examples require at least ansible version 2.1):
~~~
sudo add-apt-repository ppa:ansible/ansible-2.1
sudo apt-get update
sudo apt-get -y install ansible python-shade python-os-client-config
~~~

Fetch mtacloud ansible cluster helpers to your local machine (to /tmp/workdir):
~~~
cd /tmp/workdir
wget -q -O cluster-ansiblerc https://raw.githubusercontent.com/mcree/mtacloud/master/hot/ansible-cluster/ansible.cfg
wget -q -O openstack.py https://raw.githubusercontent.com/mcree/mtacloud/master/hot/ansible-cluster/openstack.py
chmod +x openstack.py
~~~

Fetch OpenRC v3 script from https://sztaki.cloud.mta.hu/project/access_and_security/api_access/openrc/ (eg.: to /tmp/workdir/YOURPROJECT-openrc.sh)

Initialize environment (needed for commands below)
~~~
cd /tmp/workdir
source YOURPROJECT-openrc.sh
source cluster-ansiblerc $(pwd)/cluster_key.private 1.2.3.4
~~~

Install basic python environment on your cluster (needed by ansilbe):
~~~
ansible all -m raw -a 'sudo apt -y install python'
~~~

Try a simple ping:
~~~
ansible all -m ping
~~~

Target cluster master or cluster nodes:
~~~
ansible cluster_master -m ping
ansible cluster_node_* -m ping
~~~
