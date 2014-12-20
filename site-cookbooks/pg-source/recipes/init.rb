group "postgres" do
  gid 401
  action [:create]
end

user "postgres" do
  comment "daemon user for postgres"
  uid      401
  group    'postgres'
  home     '/usr/local/pgsql'
  shell    '/bin/false'
  password nil
  supports :manage_home => true
  action   [:create, :manage]
end

directory '/usr/local/pgsql/data' do
  owner 'postgres'
  group 'postgres'
  mode '0700'
  action :create
end

bash 'init_pgsql' do
  user 'postgres'
  cwd '/usr/local/pgsql'
  
  code <<-EOH
      bin/initdb -D data

    EOH
  creates "/usr/local/pgsql/data/postgresql.conf"
end

file '/var/log/postgresql.log' do # empty log file 
  user 'postgres'
  owner 'postgres'
  mode 0644
  action :create
end

template "postgresql" do
  path "/etc/init.d/postgresql"
  owner "root"
  group "root"
  mode 0755
end

service "postgresql" do
  action [ :enable , :start ]
end


