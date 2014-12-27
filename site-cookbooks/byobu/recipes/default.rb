#
# Cookbook Name:: byobu
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
byobu_filename = "byobu_5.87"
byobu_dirname = "byobu-5.87"

remote_file "#{Chef::Config['file_cache_path']}/#{byobu_filename}.orig.tar.gz" do
  source "https://launchpad.net/byobu/trunk/5.87/+download/#{byobu_filename}.orig.tar.gz"
  not_if 'which byobu'
end

bash 'install_byobu' do
  user 'root'
  cwd Chef::Config['file_cache_path']
  code <<-EOH
      tar -xzf #{byobu_filename}.orig.tar.gz
      cd #{byobu_dirname}
      ./configure
      make -j 4
      make install
      byobu-enable
    EOH
  not_if "which byobu"
end
