mongodb
======

A simple stand alone cookbook to install mongodb.


Requirements
------------

This role requires Chef 13 or higher

Role Variables
--------------

| Name           | Default | Description                  |
|:---------------|:--------|:-----------------------------|
| default_init | /lib/systemd/system/mongod.service | Default init(or systemd) file for the mongodb server |
| init_path| /etc/init.d| Path to the init file location on this system|
| package_name|mongodb-org|Package name for mongodb|
| config_path|/etc/mongod| Path the config file for mongodb|
| pid_path| /var/run/mongodb | PID path for mogodb|
| bin_path| /usr/bin/mongod | Path to the mogodb bin file|
| log_path|/var/log/mongodb | Path to the mongodb log directory|
| db_path|/var/lib/mongo | Path to the Mongodb directory|
| user|mongod | The user to run mongodb server|
| group| mongod | The group of mongodb user|
| bind_address| 127.0.0.1 | Address to bind mongodb server to|
| port| 27017 | Port for mongodb server to use|
| instances| {} | A hash of mongodb instances to create on this node|

instances example:

```ruby
node.override['mongodb']['instances'] = {
  testdb1: {
    state: 'create',
  },
  testdb2: {
    state: 'create',
    port: 24017
  }
}
```
Any of the cookbook attributes can be overriden on an instance basis,
by specifying them in the instances hash. this allows many instances to
be deployed on one server.


Dependencies
------------
None


Testing
-------
```shell
foodcritic .
cookstyle .
rspec
kitchen test
```
Out of scope (todo)
----------------
Firewall rules are not handled just assumed to be disabled
SELinux assumed to be permisive
Clustering/sharding not implimented
User management not implimented
more indepth inspec and chefspec
Rakefile for tests

License
-------

MIT

Author Information
------------------

Steve Brown

