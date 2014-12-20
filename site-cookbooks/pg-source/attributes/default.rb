#
# Cookbook Name:: tmux
# Attribute:: default
#

default['pg-source']['version'] = '9.3.5'

default['pg-source']['configure_options'] = ['--enable-syslog', '--enable-debug', '--prefix=/usr/local/pgsql']
