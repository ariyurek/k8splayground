package 'httpd' do
	action :install
end

template '/var/www/html/index.html' do
  source 'index.html.erb'
end

# example of bash resource to create directory and chown to apache

# bash 'inline script' do
#   user 'root'
#   code "mkdir -p /var/www/mysites/ && chown -R apache /var/www/mysites/"
#   # not_if '[ -d /var/www/mysites/]'
#   not_if do
#     File.directory?('/var/www/mysites/')
#   end
# end

# example of execute resource

# execute 'run a script' do
#   command <<-EOH
#   mkdir -p /var/www/mysites/ /
#   chown -R apache /var/www/mysites/
#   EOH
#   not_if do
#     File.directory?('/var/www/mysites/')
#   end
# end

# the directory resource that should be used
# when handling directory creation

directory '/var/www/mysites' do
	owner 'apache'
	recursive true
end

service 'httpd' do
	action [:enable,:start]
end

# ~/cookbooks/apache/recipes/server.rb

# notifies :action, 'resource[name]', :timer
# subscribes :action, 'resource[name]', :timer

# timer :before, :delayed, :immediately


package 'httpd' do
	action :install
end

template '/var/www/html/index.html' do
  source 'index.html.erb'
  notifies :restart, 'service[httpd]', :immediately
end

service 'httpd' do
	action [:enable,:start]
	subscribes :restart, 'template[/var/www/html/index.html', :immediately
end