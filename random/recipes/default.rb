#
# Cookbook Name:: random
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

package 'php'

package 'httpd' #do 
	#action :upgrade
#end

service 'httpd' do
	action [:enable, :start]
end

# file '/var/www/html/index.html' do
# 	action :delete
# end

file '/var/www/html/index.html' do
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

