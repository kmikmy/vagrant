#
# Cookbook Name:: pg-source
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

packages = case node['platform_family']
           when 'rhel'
             %w(readline readline-devel zlib-devel)
           else
             %w(readline readline-devel zlib-devel)
           end

packages.each do |name|
  package name
end

tar_name = "postgresql-#{node['pg-source']['version']}"

remote_file "#{Chef::Config['file_cache_path']}/#{tar_name}.tar.gz" do
  source "https://ftp.postgresql.org/pub/source/v#{node['pg-source']['version']}/#{tar_name}.tar.gz"
#  notifies :run, 'bash[install_pg-source]', :immediately
end

bash 'install_pg-source' do
  user 'root'
  cwd Chef::Config['file_cache_path']
  code <<-EOH
      tar -xzf #{tar_name}.tar.gz
      cd #{tar_name}
      ./configure #{node['pg-source']['configure_options'].join(" ")}
      mv src/Makefile.global src/Makefile.global.origin
      sed -e "s/-O2 //" src/Makefile.global.origin > src/Makefile.global
      make -j 4
      make install
    EOH
  creates "/usr/local/pgsql/bin/psql"
end

# allocate file discribing path of shared library
template '/etc/ld.so.conf.d/libpq.conf' do
  owner  'root'
  group  'root'
  mode   '0644'
  notifies :run, 'bash[execute_ldconfig]', :immediately
end

### bash[execute_ldconfig] is defined in site-cookbooks/tmux ###
# bash 'execute_ldconfig' do 
#   user 'root'
#   code <<-EOH
#       ldconfig
#     EOH
#   action :nothing
# end
