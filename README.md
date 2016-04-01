# Zoneminder-port
Zoneminder port for BSD

Configuration file for nginx
```
server {
        listen 80 default;
        keepalive_timeout 70;

        root /usr/local/www/zoneminder;
        index index.php index.html index.htm;

	location = /cgi-bin/nph-zms {
		root /usr/local/www/zonemindeR;
        	include fastcgi_params;
        	fastcgi_param SCRIPT_FILENAME /usr/local/www/zoneminder/cgi-bin/nph-zms;
        	fastcgi_pass unix:/var/run/fcgiwrap/fcgiwrap.sock;
    	}

        location ~ \.php(?:$|/) { 
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
                fastcgi_pass   unix:/tmp/php-fpm.sock;
                fastcgi_index  index.php;

                fastcgi_param  DOCUMENT_ROOT    /usr/local/www/zoneminder;
                fastcgi_param  SCRIPT_FILENAME  /usr/local/www/zoneminder$fastcgi_script_name;
                fastcgi_param  PATH_TRANSLATED  /usr/local/www/zoneminder$fastcgi_script_name;

                include fastcgi_params;
        }
}
```
