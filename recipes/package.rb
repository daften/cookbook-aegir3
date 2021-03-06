#
# Cookbook Name:: aegir3
# Recipe:: package
#
# Author:: Dieter Blomme <dieterblomme@gmail.com>
#
# Copyright 2015, Picabit.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if debian?
  apt_repository "aegir-stable" do
    uri "http://debian.aegirproject.org"
    distribution "stable"
    components ["main"]
    key "http://debian.aegirproject.org/key.asc"
  end

  if node["aegir3"]["webserver"] == "nginx"
    directory "/var/lib/nginx" do
      owner "root"
      group "root"
      mode "0755"
    end

    include_recipe "nginx"

    %w(
      php5-cli
      php5-mysql
      php5-fpm
      php5-gd
    ).each do |pkg|
      package pkg
    end

    # Override the nginx conf template.
    begin
      override = resources(template: "nginx.conf")
      override.cookbook "aegir3"
    rescue Chef::Exceptions::ResourceNotFound
      Chef::Log.warn "Template not found!"
    end
  end

  package "aegir3" do
    response_file "aegir3.seed.erb"
    action :install
  end

  # Provide the option to manipulate php.ini
  include_recipe "php::ini"

  if node["aegir3"]["webserver"] == "apache2"
    # Restart apache for php.ini changes to take effect
    service "apache2" do
      supports restart: true, reload: true
      action :reload
      only_if { node["aegir3"]["webserver"] == "apache2" }
    end
  end

  bash "Enable tasks queue" do
    user "aegir"
    cwd node["aegir3"]["install_folder"]
    environment "HOME" => node["aegir3"]["install_folder"]
    code "drush @hostmaster vset --format=integer hosting_queue_tasks_enabled 1"
  end
end
