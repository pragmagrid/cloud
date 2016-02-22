.. hightlight:: rest

cloud
=======

.. contents::  

Introduction
--------------

This repo includes information, documetns and setup for 
enabling different virtualizations on PRAGMA testbed. 

The subdirecotries contain the following 

#. **VirtualBox**  - create rocks cluster using VirtualBox on a laptop.

#. **ec2**  - run rocks cluster on ec2 in VPC. Proof of concept was working in
              PRAGMA 23 demo. Currently rewriting. 

#. **vine** -how to setup Vine Server

#.  **CloudStack** - place holder for CloudStack work. 


Links to other repos
----------------------

Additional repositories that are related to virtualization on RRAGMA testbed. 

#. `pragma_boot`_ - this repo contains programs and drivers needed to
instantiate Virtual Machine or VIrtual Cluster in PRAGMA.

#. `Cloud scheduler`_ - PRAGMA cloud scheduler repo.

#. `parser`_ - provides for netwokr configuration on the RHEL-based virtual image

#. `ENT`_ - PRAGMA experimental Network testbed repo

.. _pragma_boot: https://github.com/pragmagrid/pragma_boot 
.. _Cloud scheduler: https://github.com/pragmagrid/cloud-scheduler
.. _parser: https://github.com/pragmagrid/vc-out-parser
.. _ENT: https://github.com/pragmagrid/pragma_ent
