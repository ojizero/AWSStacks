#
# Cookbook Name:: deployy
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

the_app = search(:aws_opsworks_app).first # I assume it should store the application assigned via opsworks stacks

deploy '/var/www/html/' do
	repo the_app['app_source']['url']
	ssh_wrapper '/home/ubuntu/.ssh/wrapper.sh'
	symlink_before_migrate ({})
	user 'root'
	#group 'www-data'
	action :deploy

	branch 'oji_branch'

	before_symlink do
		execute 'preinstall' do
			command 'cd /var/www/html && php composer.phar install'
		end

		execute 'postinstall' do
			command 'systemctl restart apache2'
		end
	end
end

template '/var/www/html/.env' do

end

