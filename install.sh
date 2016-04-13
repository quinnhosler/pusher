#!/bin/bash

# check if PHP is installed
php -v >> /dev/null
if [ $? -ne 0 ]; then echo "PHP is not installed"; exit 1; fi

apache2 -v >> /dev/null
if [ $? -ne 0 ]; then echo "PHP is not installed"; exit 1; fi

# May break, depends on current version of Composer
php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php
php -r "if (hash('SHA384', file_get_contents('composer-setup.php')) === '7228c001f88bee97506740ef0888240bd8a760b046ee16db8f4095c0d8d525f2367663f22a46b48d072c816e7fe19959') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

if [ ! -a "composer.phar" ]; then echo "Composer install failed"; exit 1; fi

# change permissions for composer (just in case)
sudo chmod +x composer.phar

# run composer install
php composer.phar install

# modify php.ini 
files=( $(sudo find / -name "php.ini") )
for file in files; do 
	grep "extension=zmq.so" $file >> /dev/null
	if [ $? -ne 0 ]; then
		sudo echo "extension=zmq.so" >> $file
		if [ $? -ne 0 ]; then 
			echo "error adding extension to $file, skipping file"
		fi
	fi
done

