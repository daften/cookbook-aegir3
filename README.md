aegir3 Cookbook
===============

[Aegir][] is a hosting system for deploying and managing large networks of
[Drupal][] sites. This collection of recipes automate [Aegir][] setup,
specifically for aegir3.

Requirements
------------

## Cookbooks:

* mysql (to install mysql-server properly)

## Platforms
- Debian/Ubuntu

Attributes
----------

* `node['aegir3']['install_method']` - Install method for aegir
* `node['aegir3']['frontend']` - The URL for the aegir frontend
* `node['aegir3']['admin_email']` - The admin email for the aegir site
* `node['aegir3']['webserver']` - The web server aegir should use.

Resources/Providers
-------------------
### `aegir3_extension`
This LWRP provides an easy way to manage aegir3 extensions

#### Actions
- :add: Adds the extension to aegir
- :remove: removes the extension

#### Attribute Parameters
- name: name attribute. The name of the extension to add
- repository_provision: the git repository for the provision module (drush extension)
- repository_hosting: the git repository for the hosting module (drupal module)
- version: the version to used. Should be a git tag that is on the provision and hosting module

#### Examples

Add the tasks_extra extension:

```ruby
aegir3_extension 'tasks_extra' do
  repository_provision 'http://git.drupal.org/project/provision_tasks_extra.git'
  repository_hosting 'http://git.drupal.org/project/hosting_tasks_extra.git'
  version '6.x-2.1'
end
```

Remove the tasks_extra extension:

```ruby
aegir3_extension 'tasks_extra' do
  action :remove
end
```

Usage
-----
Simply include the default recipe to get aegir3 installed with the default
package-based method. Different install methods and servers will be supported
in future versions. You can set a custom admin email and frontend URL by using
attributes.

You will most likely need to run the apt::default recipe before this cookbook
can be used.

### Usage in roles:
```ruby
name "aegir3"
description "aegir3 role"
run_list "recipe[apt::default],recipe[aegir3::default]"
default_attributes "aegir3" => {
  "admin_email" => "another@email.please"
}
```

Local setup
-------------------

You can easily test this cookbook locally, by installing the following toolchain:
* [VirtualBox](https://www.virtualbox.org/)
* [Vagrant](https://www.vagrantup.com/)
* [Chef Development Kit](https://downloads.chef.io/chef-dk/)
* [Vagrant Berkshelf Plugin](https://github.com/berkshelf/vagrant-berkshelf)

When the above dependencies are installed, you can test this cookbook easily by
simply issuing `vagrant up`.

Testing
-------------------

The cookbook is testable with kitchen and foodcritic. The basic tests can be
run through rake.

By issuing `bundle exec rake`, foodcritic tests are run.

By issuing `kitchen test`, the cookbook is used on Ubuntu-14.04 and CentOS-7.0.

Contributing
------------
Contributions can be made by using the GitHub Pull Request system.

## License and Authors

Author:: Dieter Blomme (dieterblomme@gmail.com)

License and Authors

* Author:: Dieter Blomme (dieterblomme@gmail.com

Copyright:: 2015, Picabit

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
)


[Aegir]:http://www.aegirproject.org/
[Drupal]:http://www.drupal.org/
