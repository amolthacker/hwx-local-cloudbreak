# HWX Local Cloudbreak

Run [Hortonworks Cloudbreak](https://docs.hortonworks.com/HDPDocuments/Cloudbreak/Cloudbreak-2.4.1/index.html) locally


## Prerequisites:

 * [VirtualBox](https://www.virtualbox.org/)
 * [Vagrant](https://www.vagrantup.com/) with [hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager) plugin


 ## Steps

  1. Clone the repo
     ```
     $ git clone https://github.com/amolthacker/hwx-local-cloudbreak.git
     ```

  2. Update service IP and login credentials, as desired, in `scripts/env.sh` 

  3. Update Cloudbreak VM configuration, as desired, in `vagrant/cbd.yml`

  4. Update Cloud Provider credentials, as desired, in `credentials/`

  4. Install and setup Cloudbreak 
     ```
     $ ./scripts/install-n-setup-cloudbreak.sh
     ```

  5. Log in
     ```
     $ cd vagrant && vagrant ssh hwx-cloudbreak

     https://hwx-cloudbreak/sl/
     ```

## Operations

  1. Start
     ```
     $ cd vagrant
     $ vagrant up
     $ vagrant ssh hwx-cloudbreak

     hwx-cloudbreak $ cd /var/lib/cloudbreak-deployment
     hwx-cloudbreak $ sudo cbd start
     ```

  2. Stop
     ```
     $ cd vagrant
     $ vagrant ssh hwx-cloudbreak

     hwx-cloudbreak $ cd /var/lib/cloudbreak-deployment
     hwx-cloudbreak $ sudo cbd kill
     hwx-cloudbreak $ exit

     $ vagrant halt
     ```
