#
# Cookbook Name:: random
# Recipe:: defaultmc	
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

package 'php'

execute 'Add repo for PHP71' do
	command 'curl https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && curl http://rpms.remirepo.net/enterprise/remi-release-7.rpm && rpm -Uvh remi-release-7.rpm epel-release-latest-7.noarch.rpm'
end

execute 'Enable the repo' do
	command 'yum install yum-utils && yum-config-manager --enable remi-php71'
end

execute 'Do the upgrade' do
	command 'yum update -y php'
end

package 'httpd' #do 
	#action :upgrade
#end

service 'httpd' do
	action [:enable, :restart]
end

file '/var/www/html/index.html' do
	action :delete
end

file '/var/www/html/index.php' do
	content '<html>
<body>
<h1>
<?php
echo phpversion();
?>
</h1>
</body>
</html>'
	mode '0775'
	owner 'apache'
	group 'apache'
end

#template '/var/www/html/index.html' do
#
#end

