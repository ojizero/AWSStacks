#
# Cookbook Name:: random
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

package 'httpd' do 
	action :update
end

service 'httpd' do
	action [:enable, :start]
end

file '/var/www/html/index.html' do
	content 'This is a test page for testing.'
end

#template '/var/www/html/index.html' do
#
#end

