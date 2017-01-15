#
# Cookbook Name:: random
# Recipe:: defaultmc	
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

the_app = search(:aws_opsworks_app).first

if the_app.nil? then # assuming `search(:aws_opsworks_app).first` would return nil on failure
	file '/home/ubuntu/tests' do
		content 'No app, crashe avoided though\n'
	end
else
	package 'php7.0'

	package 'libapache2-mod-php7.0'

	package 'php7.0-mbstring'

	package 'phpunit'

	package 'php-mysql'

	package 'php-mcrypt'

	# package 'apache2' #do 
	# 	#action :upgrade
	# #end
	# 
	# service 'apache2' do
	# 	action [:disable, :stop]
	# end

	package 'nginx'

	service 'nginx' do
		action [:enable, :restart]
	end

	file '/home/ubuntu/.ssh/key' do
		content "#{the_app['app_source']['ssh_key']}"
		mode '0400'
		owner 'root'
		group 'root'
	end

	template '/home/ubuntu/.ssh/wrapper.sh' do
		source 'the_wrapper.sh.erb'
		mode '0770'
		owner 'root'
	end

	# file '/var/www/html/theappkey.html' do
	# 	content "#{the_app['app_source']['ssh_key']}"
	# 	owner 'www-data'
	# 	group 'www-data'
	# end
end
