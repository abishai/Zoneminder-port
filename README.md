# Zoneminder-port
Zoneminder port for FreeBSD

Configuration file for NGINX
```
server {
        listen 80 default;

        root /usr/local/www/zoneminder;
        try_files $uri $uri/ /index.php$is_args$args;
        index index.php;

        location = /cgi-bin/nph-zms {
                include fastcgi_params;
                fastcgi_param   SCRIPT_FILENAME $document_root$fastcgi_script_name;
                fastcgi_pass    unix:/var/run/fcgiwrap/fcgiwrap.sock;
    	}

        location ~ \.php$ { 
                include fastcgi_params;
                fastcgi_param   SCRIPT_FILENAME  $document_root$fastcgi_script_name;
                fastcgi_pass    unix:/var/run/php-fpm.sock;
        }
}
```
