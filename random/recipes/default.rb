#
# Cookbook Name:: random
# Recipe:: defaultmc	
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

package 'php7.0'

packeg 'libapache2-mod-php7.0'

package 'apache2' #do 
	#action :upgrade
#end

service 'apache2' do
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
	mode '0640'
	owner 'www-data'
	group 'www-data'
end

#template '/var/www/html/index.html' do
#
#end

