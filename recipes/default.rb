#
# Cookbook Name:: memcached
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
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

package "memcached" do
  action :install
end

package "libmemcache-dev" do
  action :upgrade
end

service "memcached" do
  action :nothing
  supports :status => true, :start => true, :stop => true, :restart => true
end

template "/etc/memcached.conf" do
  source "memcached.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :listen => node[:memcached][:listen],
    :user => node[:memcached][:user],
    :port => node[:memcached][:port],
    :memory => node[:memcached][:memory]
  )
  notifies :restart, resources(:service => "memcached"), :immediately
end

case node[:lsb][:codename]
when "karmic"
  template "/etc/default/memcached" do
    source "memcached.default.erb"
    owner "root"
    group "root"
    mode "0644"
    notifies :restart, resources(:service => "memcached"), :immediately
  end
end

monit_watch "memcached"
