#
# Cookbook Name:: ejabberd
# Recipe:: default
#
# Copyright 2012, Jacques Marneweck
#
# All rights reserved - Do Not Redistribute
#

group "ejabberd" do
  gid node['ejabberd']['gid']
  not_if "grep '^ejabberd::#{node['ejabberd']['gid']}:$' /etc/group"
end

user "ejabberd" do
  uid node['ejabberd']['uid']
  gid node['ejabberd']['gid']
  comment "ejabberd user"
  home "/var/spool/ejabberd"
  shell "/usr/bin/false"
  supports :manage_home=>false
  action :create
  notifies :run, "execute[set-locked-password-for-ejabberd-user]", :immediately
  not_if "grep '^ejabberd:x:#{node['ejabberd']['uid']}:#{node['ejabberd']['gid']}:ejabberd user:/var/spool/ejabberd:/usr/bin/false$' /etc/passwd"
end

execute "set-locked-password-for-ejabberd-user" do
  command "passwd -l ejabberd"
  action :nothing
end

%w{
  ejabberd
}.each do |p|
  package "#{p}" do
    action :install
  end
end

template "/opt/local/etc/ejabberd/ejabberd.cfg" do
  source "ejabberd.cfg.erb"
  owner "root"
  group "ejabberd"
  mode "0640"
end

#service "pkgsrc/epmd" do
#  action [:enable]
#end

#service "pkgsrc/ejabberd" do
#  action [:enable]
#end
