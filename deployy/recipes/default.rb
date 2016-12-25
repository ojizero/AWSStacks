#
# Cookbook Name:: deployy
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

the_app = search(:aws_opsworks_app).first
database = search(:aws_opsworks_rds_db_instance).first
the_LB = search(:aws_opsworks_elastic_load_balancer).first

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

		template "#{release_path}/.env" do
			source 'env.erb'
  			variables ({
  		  		:the_url => the_LB['dns_name'],
	  		  	:dbhost => database['address'],
  			  	:dbname => the_app['environment']['namedb'],
  			  	:dbuser => database['db_user'], # the_app['environment']['userdb'],
	  		  	:dbpass => database['db_password'] # the_app['environment']['passdb']
  			})
		end
 		
		template '/etc/apache2/sites-available/000-default.conf' do
			source 'the_host_file_conf.erb'
		end
	end
end


