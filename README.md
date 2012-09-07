djangocore-box: A virtual machine for running the Django core test suite
========================================================================

The djangocore-box is a virtual machine (VM) containing all the libraries
required for running the Django core test suite with every supported version of
Python and every supported database backend, as well as for the GIS features
(aka GeoDjango).

The versions of Python that are installed are: 2.4.6, 2.5.6, 2.6.5, 2.7.3
(default), and 3.2.3. The installed database backends are: SQLite, Spatialite,
MySQL, PostgreSQL and PostGIS. Oracle is coming soon.

Preparation
-----------

First of all, you need to install the latest versions of
[Vagrant](http://downloads.vagrantup.com/) and
[VirtualBox](https://www.virtualbox.org/wiki/Downloads) on your host machine.

Booting the VM
--------------

_Legend:_ `(host)` is for commands to run on the host machine, and `(vm)` is
for commands to run inside the VM.

If you have already downloaded the box file separately, then run the following
command (otherwise skip this step):

    (host) $ vagrant box add djangocore-box-1.0 path/to/your/local/copy/of/djangocore-box-1.0

To boot the VM, run the following commands to start the build process:

    (host) $ mkdir djangocore
    (host) $ cd djangocore
    (host) $ git clone git@github.com:django/django.git  # or replace django/django.git by <your username>/django.git if you have your own fork
    (host) $ git clone git@github.com:jphalip/djangocore-box.git
    (host) $ mkdir sandbox
    (host) $ cd djangocore-box
    (host) $ vagrant up

The first time you run `vagrant up` it will download the VM, which is about
_1GB large_ (be warned if you have a low bandwitdh Internet connection). Every
subsequent times, it will just boot the VM, which only takes about 30 seconds.

As the VM boots up, it will prompt you to enter your host machine's
administrator password (the same that you use for logging into your host
machine). This is required so that Vagrant can setup the NFS shared folders.

Once the VM is up and running, type the following command to SSH into the VM
(still from inside the `djangocore-box/` folder):

    (host) $ vagrant ssh

Once inside the VM, you can run the tests by typing any of the pre-defined
aliases: `runtests{2.4,2.5,2.6,2.7,3.2}-{sqlite,mysql,postgresql,spatialite,postgis}`.
For example:

    (vm) $ runtests2.6-mysql
    (vm) $ runtests2.7-spatialite gis
    (vm) $ runtests2.5-postgresql auth forms


Sandbox directory
-----------------

In some cases, you will want to expose test projects, or test code to your host machine. The `sandbox` directory on the host is mapped to the `/sandbox` directory on the vagrant managed VM.

Any projects or code you create in `/sandbox` will be available in the `djangocore/sandbox` directory.

Building the VM from scratch
----------------------------

You probably don't need to build the VM from scratch, but if you really want
it, the steps are still pretty simple. First, rename the file `Vagrantfile` to
a temporary name (e.g. `Vagrantfile-backup`) and then rename the file
`Vagrantfile-build` to `Vagrantfile`. Then run `vagrant up`. The automatic
build process will take about an hour. Use that time to do other work, browse
the web or go out for a nice stroll in the park!

Notes about the VM configuration
--------------------------------

Inside the VM, the `/django` folder is shared with the host and points to the
git clone that was created in the steps above. The repository clone for the
djangocore-box itself is also in a shared folder at `/djangocore-box`. This way
you can edit Django's code using your favorite editor/IDE from your host
machine and run the tests from inside the VM.

The various versions of python are installed in the `/opt` folder. The
virtualenvs are named `py{2.4,2.5,2.6,2.7,3.2}` and are installed under
`/home/vagrant/.virtualenvs/`.

`virtualenvwrapper` is also installed so you may run, for example:

    (vm) $ workon py3.2

You should be able to push commits to your fork of django on github directly
from inside the VM, as the SSH and git configuration files inside the VM are
automatically symlinked to the corresponding files on your host machine. You
may push those commits from the host machine too.

The test settings are available in `/djangocore-box/test_settings/test_*.py`.
These files are available in every virtualenv via symlinks.

The VM is currently based on a lucid32 (Ubuntu 10.04.4 LTS) distribution. There
are plans to switch to a more recent distribution, namely precise32 (Ubuntu
12.04 LTS).

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
- Use a more recent base box (e.g. Ubuntu 12.04 LTS).

Credits
-------

djangocore-box was contributed by [Julien Phalip](https://twitter.com/julienphalip).
