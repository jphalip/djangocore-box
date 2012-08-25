djangocore-box: A virtual machine for running the Django core test suite
========================================================================

The djangocore-box is a virtual machine (VM) containing all the libraries
required for running the Django core test suite with every supported version of
Python and every supported database backend, as well as for the GIS features
(aka GeoDjango).

The versions of Python that are installed are: 2.4.6, 2.5.6, 2.6.5, 2.7.1
(default), and 3.2.3. The installed database backends are: SQLite, Spatialite,
MySQL, PostgreSQL and PostGIS. Oracle are coming soon.

Getting started
---------------

First of all, you need to install the latest versions of
[Vagrant](http://downloads.vagrantup.com/) and
[VirtualBox](https://www.virtualbox.org/wiki/Downloads) on your host machine.

Using the pre-packaged VM box
-----------------------------

_This is coming soon_. A pre-packaged box will be available for download so
you can get started even quicker. For now, you need to build the VM from
scratch.

Building the VM from scratch
----------------------------

Building the VM from scratch is very simple and only takes a handful of
commands. Once started, the automatic build process will take about an hour.
Use that time to do other work, browse the web or go out for a nice stroll in
the park!

To start the build, run the following commands to start the build process:

(Legend: "`(host)`" is for commands to run on the host machine, and "`(vm)`"
is for commands to run inside the VM)

    (host) $ mkdir djangocore
    (host) $ cd djangocore
    (host) $ git clone git@github.com:django/django.git  # or replace django/django.git by <your username>/django.git if you have your own fork
    (host) $ git clone git@github.com:jphalip/djangocore-box.git
    (host) $ cd djangocore-box
    (host) $ vagrant up

Now, wait for about an hour. Once the build is complete, run the following
command to SSH into the VM (still from inside the `djangocore-box/` folder):

    (host) $ vagrant ssh

Once inside the VM, you can run the tests by typing any of the pre-defined
aliases: `runtests{2.4, 2.5, 2.6, 2.7, 3.2}-{sqlite, mysql, postgresql, spatialite}`.
For example:

    (vm) $ runtests2.6-mysql
    (vm) $ runtests2.7-spatialite gis
    (vm) $ runtests2.5-postgresql auth forms

Notes about the VM configuration
--------------------------------

Inside the VM, the `/django` folder is shared with the host and points to the
git clone that was created in the steps above. The repository clone for the
djangocore-box itself is also in a shared folder at `/djangocore-box`. This way
you can edit Django's code using your favorite editor/IDE from your host
machine and run the tests from inside the VM.

The various versions of python are installed in the `/opt` folder. The
virtualenvs are named `py{2.4, 2.5, 2.6, 2.7, 3.2}` and are installed under
`/home/vagrant/.virtualenvs`.

`virtualenvwrapper` is also installed so you may run, for example:

    (vm) $ workon py3.2

You should be able to push commits to your fork of django on github directly
from inside the VM, as the SSH and git configuration files inside the VM are
automatically symlinked to the corresponding files on your host machine. You
may push those commits from the host machine too.

The test settings are available in `/djangocore-box/test_settings/test_*.py`.
These files are available in every virtualenv via symlinks.

Vagrant command tips
--------------------

- To exit the VM and return to your host machine, simple type:

    `(vm) $ exit`

- To stop the VM, type:

    `(host) $ vagrant halt`

- Once stopped, a VM can be restarted with:

    `(host) $ vagrant up`

- To destroy the VM, simply type:

    `(host) $ vagrant destroy`

- To check if the VM is currently running, type:

    `(host) $ vagrant status`

- To re-run the provisioning after the VM has been started:

    `(host) $ vagrant provision`

- More information is available in the [Vagrant documentation](http://vagrantup.com/v1/docs/index.html).


Todo
----

- Create a pre-packaged VM and make it available for download.
- Install the Oracle backend.
- Use a more recent base box (e.g. Ubuntu 12.04 LTS).

Credits
-------

djangocore-box was contributed by [Julien Phalip](https://twitter.com/julienphalip).