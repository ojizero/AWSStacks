#
# Cookbook Name:: deployy
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

the_app = search(:aws_opsworks_app).first

file '/var/www/html/theapp.html' do
	content "#{the_app.to_s}"
end

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
			command "cd #{release_path} && php composer.phar install"
		end

		execute 'postinstall' do
			command "chown -R www-data:www-data #{release_path} && systemctl restart apache2"
		end
	end
end

# template "#{release_path}/.env" do
# 	source 'env.erb'
# 	variables ({
# 		:the_url => 'heyy',
# 		:dbhost => 'linked and such',
# 		:dbname => the_app['environment']['namedb'],
# 		:dbuser => the_app['environment']['userdb'],
# 		:dbpass => the_app['environment']['passdb']
# 	})
# end
 
