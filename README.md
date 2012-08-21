djangocore-box
==============

Virtual machine to run Django's test suite.

To build the VM from scratch:

- Fork http://github.com/django/django/
- mkdir djangocore
- cd djangocore
- git clone git@github.com:<your username>/django.git
- git clone git@github.com:jphalip/djangocore-box.git
- cd djangocore-box
- vagrant up
- vagrant ssh


TODO:
- Provide list of aliases for running the tests
- Create pre-packaged VM, make it available for download, and write instructions.