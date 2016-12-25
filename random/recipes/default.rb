#
# Cookbook Name:: random
# Recipe:: defaultmc	
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

the_app = search(:aws_opsworks_app).first

package 'php7.0'

package 'libapache2-mod-php7.0'

package 'php7.0-mbstring'

package 'phpunit'

package 'apache2' #do 
	#action :upgrade
#end

service 'apache2' do
	action [:enable, :restart]
end

# file '/var/www/html/index.html' do
# 	action :delete
# end
# 
# file '/var/www/html/index.php' do
# 	content '<html>
# <body>
# <h1>
# <?php
# echo phpversion();
# ?>
# </h1>
# </body>
# </html>'
# 	mode '0640'
# 	owner 'www-data'
# 	group 'www-data'
# end

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

file '/var/www/html/theappkey.html' do
	content "#{the_app['app_source']['ssh_key']}"
	owner 'www-data'
	group 'www-data'
end
