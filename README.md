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

  2. Modify the configuration and properties, as needed, in `vagrant/cbd.yml` 

  3. Spin up the VM
     ```
     $ cd hwx-local-cloudbreak/vagrant

     $ vagrant up

     $ vagrant ssh hwx-cloudbreak
     ```

  4. Log in
     ```
     https://hwx-cloudbreak/sl/
     ```

## Operations

  1. Start
     ```
     $ cd vagrant
     $ vagrant up
     $ vagrant ssh hwx-cloudbreak

     $ hwx-cloudbreak $ cbd start
     ```

  2. Stop
     ```
     $ cd vagrant
     $ vagrant ssh hwx-cloudbreak

     hwx-cloudbreak $ sudo cbd kill
     hwx-cloudbreak $ exit

     $ vagrant halt
     ```
