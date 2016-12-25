#
# Cookbook Name:: deployy
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

the_app = search(:aws_opsworks_app).first
database = search(:aws_opsworks_rds_db_instance).first
the_LB = search(:aws_opsworks_elastic_load_balancer).first

# file '/var/www/html/theapp.html' do
# 	content "#{the_app.to_s}"
# end

deploy '/var/www/html/' do
	repo the_app['app_source']['url']
	ssh_wrapper '/home/ubuntu/.ssh/wrapper.sh'
	symlink_before_migrate ({})
	user 'root'
	#group 'www-data'
	action :deploy

	branch 'oji_branch'

	before_symlink do
		execute 'install' do
			command "cd #{release_path} && php composer.phar install"
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
 
 		template '/etc/nginx/sites-available/default.conf' do
			source 'nginx_site.conf.erb'
		end
		
		execute 'key:generate' do
			command "cd #{release_path} && php artisan key:generate"
		end

		execute 'postinstall' do
			command "chown -R www-data:www-data #{release_path} && systemctl restart nginx"
		end
		
		execute 'genkey' do
			command "cd #{release_path} && php artisan key:generate"
		end
		
		execute 'SHOULDN\'T BE HERE' do
			command "cd #{release_path} && php artisan migrate"
		end
	end
end


