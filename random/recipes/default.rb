#
# Cookbook Name:: random
# Recipe:: defaultmc	
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

package 'php'

script 'Add repo for PHP71' do
	interpreter 'bash'
	code 'curl https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm > epel-release-latest-7.noarch.rpm &&
curl http://rpms.remirepo.net/enterprise/remi-release-7.rpm > remi-release-7.rpm &&
rpm -Uvh remi-release-7.rpm epel-release-latest-7.noarch.rpm &&
subscription-manager repos --enable=rhel-7-server-optional-rpms && 
yum-config-manager --enable remi-php71 && 
yum update -y php'
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

