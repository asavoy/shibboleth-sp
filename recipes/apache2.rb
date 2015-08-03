#
# Cookbook Name:: shibboleth-sp
# Recipe:: apache2
#
# Copyright 2012
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

node.set['apache']['listen_ports'] = [node['shibboleth-sp']['apache2']['listen_port']]

# Install mod_shib for Apache.
package "libapache2-mod-shib2" do
end

# Install Apache.
include_recipe "apache2::default"

# Enable mod_proxy.
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"

# Enable mod_shib.
# HACK: This is needed to set the correct module name "mod_shib", otherwise
# it is set to "shib2_module" causing the error "undefined symbol" is thrown when
# starting Apache.
file "#{node['apache']['dir']}/mods-available/shib2.load" do
  content "LoadModule mod_shib #{node['apache']['libexecdir']}/mod_shib2.so"
end
apache_module "shib2" do
  enable true
end

# Build the doc root for the Shibboleth site, though we don't use it.
directory node['shibboleth-sp']['apache2']['doc_root'] do
  owner "www-data"
  group "www-data"
end

# Configure an Apache site that integrates Shibboleth authentication on a given path,
# and reverse proxies to a backend application, if user is authenticated.
web_app "shibsp_site" do
  listen_port node['shibboleth-sp']['apache2']['listen_port']
  backend_site node['shibboleth-sp']['apache2']['backend_site']
  proxy_pass_path node['shibboleth-sp']['apache2']['proxy_pass_path']
  # We must use the public hostname for the cluster as the ServerName for the VirtualHost,
  # as `mod_shib` looks at it to determine the hostname for the Shibboleth handler URLs.
  # Note, this affects the URLs generated in `/Shibboleth/Metadata`.
  #server_name "#{node['dns']['public_host']}"
  server_name node['shibboleth-sp']['apache2']['server_name']
  server_aliases ['*']
  docroot node['shibboleth-sp']['apache2']['doc_root']
end

# Setup firewall rules.
allow_eth2 = CommonUtil.validate_eth2_ip_range(node, node['959947-mathspace']['private_net'])

if allow_eth2
  # Allow communication over private net
  add_iptables_rule('INPUT', '-i eth2 -j ACCEPT', 50, 'Allow communication over private net')
end
