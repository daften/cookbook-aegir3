#
# Cookbook Name:: aegir3
# Provider:: extension
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

action :add do
  if !new_resource.repository_provision.nil?
    Chef::Log.info "Installing provision module from #{new_resource.name}"
    git "#{node['aegir3']['install_folder']}/.drush/provision_#{new_resource.name}" do
      repository new_resource.repository_provision
      revision new_resource.version
      action :sync
      user "aegir"
      group "aegir"
    end
    loc = Mixlib::ShellOut.new('drush cc drush',
      :user => 'aegir', :group => 'aegir', :environment => {'HOME' => Dir.home('aegir')})
    loc.run_command
    new_resource.updated_by_last_action(true)
  end

  if !new_resource.repository_hosting.nil?
    Chef::Log.info("Installing hosting module from #{new_resource.name}")
    loc = Mixlib::ShellOut.new('drush site-alias @hostmaster --component="site_path"',
      :user => 'aegir', :group => 'aegir', :environment => {'HOME' => Dir.home('aegir')})
    loc.run_command
    location_hostmaster = loc.stdout.strip

    git location_hostmaster + "/modules/hosting_#{new_resource.name}" do
      repository new_resource.repository_hosting
      revision new_resource.version
      action :sync
      user "aegir"
      group "aegir"
    end
    new_resource.updated_by_last_action(true)
  end
end

action :remove do
  Chef::Log.info "Removing #{new_resource.name}"
  if !new_resource.repository_provision.nil?
    directory "#{node['aegir3']['install_folder']}/.drush/provision_#{new_resource.name}" do
      recursive true
      action :delete
    end
    new_resource.updated_by_last_action(true)
  end
  if !new_resource.repository_hosting.nil?
    loc = Mixlib::ShellOut.new('drush site-alias @hostmaster --component="site_path"',
      :user => 'aegir', :group => 'aegir', :environment => {'HOME' => Dir.home('aegir')})
    loc.run_command
    location_hostmaster = loc.stdout.strip
    directory location_hostmaster + "/modules/hosting_#{new_resource.name}" do
      recursive true
      action :delete
    end
    new_resource.updated_by_last_action(true)
  end
end
