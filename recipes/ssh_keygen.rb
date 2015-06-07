#
# Cookbook Name:: aegir3
# Recipe:: ssh_keygen
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

# We need to do this like this, since usermod (through the user cookbooK) doesn't work

# Create the .ssh directory
directory node['aegir3']['install_folder'] + '/.ssh' do
  owner     "aegir"
  group     "aegir"
  mode      '0755'
  recursive true
  only_if { Dir.exists?(node['aegir3']['install_folder']) }
end

fqdn, my_home = node['fqdn'], node['aegir3']['install_folder']
e = execute "create ssh keypair for aegir" do
  cwd       node['aegir3']['install_folder']
  user      "aegir"
  command   <<-KEYGEN.gsub(/^ +/, '')
    ssh-keygen -t dsa -f #{my_home}/.ssh/id_dsa -N '' \
      -C 'aegir@#{fqdn}-#{Time.now.strftime('%FT%T%z')}'
    chmod 0600 #{my_home}/.ssh/id_dsa
    chmod 0644 #{my_home}/.ssh/id_dsa.pub
  KEYGEN
  action    :run

  creates   "#{my_home}/.ssh/id_dsa"
  only_if { Dir.exists?(node['aegir3']['install_folder']) }
end
