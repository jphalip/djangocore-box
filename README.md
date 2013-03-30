djangocore-box: A virtual machine for running the Django core test suite
========================================================================

The djangocore-box is a virtual machine (VM) containing all the libraries
required for running the Django core test suite with every supported version of
Python and every supported database backend, as well as for the GIS features
(aka GeoDjango).

The versions of Python that are installed are: 2.4.6, 2.5.6, 2.6.5, 2.7.3
(default), and 3.3. The installed database backends are: SQLite, Spatialite,
MySQL, PostgreSQL and PostGIS. Oracle is coming soon.

Preparation
-----------

### Software installation

First of all, you need to install the latest versions of
[Vagrant](http://downloads.vagrantup.com/) and
[VirtualBox](https://www.virtualbox.org/wiki/Downloads) on your host machine.


### Adding SSH keys to ssh-agent

SSH-Agent will allow you to share the ssh keys on your host machine with the
VM. This will then allow you to authenticate to remote servers, like github
for example, from inside the VM.

First, check if your keys are added to ssh-agent:

    ssh-add -l

If you don't have any keys, or the key you want available to the VM is not
listed, you can add your key by running the following:

    ssh-add <path_to_key>

Example:

    ssh-add ~/.ssh/id_rsa

Booting the VM
--------------

_Legend:_ `(host)` is for commands to run on the host machine, and `(vm)` is
for commands to run inside the VM.

Setup the initial directory layout:

    (host) $ mkdir djangocore
    (host) $ cd djangocore
    (host) $ git clone git@github.com:django/django.git  # or replace django/django.git by <your username>/django.git if you have your own fork
    (host) $ git clone git@github.com:jphalip/djangocore-box.git
    (host) $ mkdir sandbox

Then, either:

* If you have not already downloaded the box file separately, then run the
  following commands to boot the machine.

        (host) $ cd djangocore-box
        (host) $ vagrant up

  This will automatically download the VM, which is about _1GB_ in size (be
  warned if you have a low bandwitdh Internet connection) and then boot it up.
  The download will only occur the first time you run `vagrant up`. Every
  subsequent times, it will just boot the VM, which only takes about 30
  seconds.

* Or, if you have already downloaded the box file separately (say, for example
  someone gave it to you via a flash drive), then run the following command in
  order to import the box into vagrant and boot up the VM:

        (host) $ vagrant box add djangocore-box-1.1 path/to/your/local/copy/of/djangocore-box-1.1.box
        (host) $ cd djangocore-box
        (host) $ vagrant up

  `vagrant box add` will copy the box file to `~/.vagrant.d/boxes`, so you may
  delete the file you've dowloaded if you'd like to save some space on your
  hard drive.

As the VM boots up, it will prompt you to enter your host machine's
administrator password (the same that you use for logging into your host
machine). This is required so that Vagrant can setup the NFS shared folders.

Once the VM is up and running, type the following command to SSH into the VM
(still from inside the `djangocore-box/` folder):

    (host) $ vagrant ssh

Once inside the VM, you can run the tests by typing any of the pre-defined
aliases: `runtests{2.4,2.5,2.6,2.7,3.3}-{sqlite,mysql,postgresql,spatialite,postgis}`.
For example:

    (vm) $ runtests2.6-mysql
    (vm) $ runtests2.7-spatialite gis
    (vm) $ runtests2.5-postgresql auth forms

Building the VM from scratch
----------------------------

You probably don't need to build the VM from scratch, but if you really want
it, the steps are still pretty simple. First, rename the file `Vagrantfile` to
a temporary name (e.g. `Vagrantfile-backup`) and then rename the file
`Vagrantfile-build` to `Vagrantfile`. Then run `vagrant up`. The automatic
build process will take about an hour. Use that time to do other work, browse
the web or go out for a nice stroll in the park!

Sandbox directory
-----------------

In some cases, you will want to expose test projects, or test code to your host
machine. The `sandbox` directory on the host is mapped to the `/sandbox`
directory on the vagrant managed VM.

Any projects or code you create in `/sandbox` will be available in the
`djangocore/sandbox` directory.

Notes about the VM configuration
--------------------------------

Inside the VM, the `/django` folder is shared with the host and points to the
git clone that was created in the steps above. The repository clone for the
djangocore-box itself is also in a shared folder at `/djangocore-box`. This way
you can edit Django's code using your favorite editor/IDE from your host
machine and run the tests from inside the VM.

The various versions of python are installed in the `/opt` folder. The
virtualenvs are named `py{2.4,2.5,2.6,2.7,3.3}` and are installed under
`/home/vagrant/.virtualenvs/`.

`virtualenvwrapper` is also installed so you may run, for example:

    (vm) $ workon py3.3

You should be able to push commits to your fork of django on github directly
from inside the VM, as the SSH and git configuration files inside the VM are
automatically symlinked to the corresponding files on your host machine. You
may push those commits from the host machine too.

The test settings are available in `/djangocore-box/test_settings/test_*.py`.
These files are available in every virtualenv via symlinks.

Firefox is pre-installed so that Django's selenium tests can be run in headless
mode in a virtual display (with the id `:99`). For example, you may run a
specific test like so:

    (vm) $ runtests2.6-sqlite admin_inlines.SeleniumFirefoxTests --selenium

The VM is based on a Ubuntu 12.04 LTS 64 bits distribution.

Building the documentation
--------------------------

To build the documentation, simply activate one of the virtualenvs and run the
Sphinx build command:

    workon py2.7
    cd /django/docs
    make html

Vagrant command tips
--------------------

- To exit the VM and return to your host machine, simple type:

    `(vm) $ exit`

- To shutdown the VM, type:

    `(host) $ vagrant halt`

- To suspend the VM (i.e. freeze the VM's state), type:

    `(host) $ vagrant suspend`

- Once shutdown or suspended, a VM can be restarted with:

    `(host) $ vagrant up`

- To destroy the VM, simply type:

    `(host) $ vagrant destroy`

- To check if the VM is currently running, type:

    `(host) $ vagrant status`

- To re-run the provisioning after the VM has been started (if you have built
  the VM from scratch):

    `(host) $ vagrant provision`

- More information is available in the [Vagrant documentation](http://vagrantup.com/v1/docs/index.html).


Todo
----

- Install the Oracle backend.

Credits
-------

djangocore-box was contributed by [Julien Phalip](https://twitter.com/julienphalip).
