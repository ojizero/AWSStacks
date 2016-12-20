#
# Cookbook Name:: random
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

package 'httpd' do 
	action :upgrade
end

service 'httpd' do
	action [:enable, :start]
end

file '/var/www/html/index.html' do
	content '<?php echo phpversion() ?>'
	mode '0775'
	owner 'apache'
	group 'apache'
end

#template '/var/www/html/index.html' do
#
#end

