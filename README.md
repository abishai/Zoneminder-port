# Zoneminder-port
Zoneminder port for BSD

Configuration file for nginx
```
server {
        listen 80 default;

        root /usr/local/www/zoneminder;
        index index.php;

	location = /cgi-bin/nph-zms {
        	include fastcgi_params;
        	fastcgi_param SCRIPT_FILENAME /usr/local/www/zoneminder/cgi-bin/nph-zms;
        	fastcgi_pass unix:/var/run/fcgiwrap/fcgiwrap.sock;
    	}

        location ~ \.php(?:$|/) { 
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
		include fastcgi_params;
                fastcgi_index  index.php;

                fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
                fastcgi_param  PATH_TRANSLATED  $document_root$fastcgi_script_name;
		fastcgi_pass   unix:/tmp/php-fpm.sock;
        }
}
```
