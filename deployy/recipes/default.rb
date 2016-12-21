#
# Cookbook Name:: deployy
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

the_app = search(:aws_opsworks_app).first # I assume it should store the application assigned via opsworks stacks

#for now create a random file to test stuff out
file '/var/www/html/theapp.html' do
	content "#{the_app['attributes'].to_a}"
	mode '0775'
	owner 'www-data'
	group 'www-data'
end

