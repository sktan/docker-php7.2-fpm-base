# Docker PHP7.2-fpm Base
Docker base template for PHP7.2-fpm web applications

## Building the image

The build process can be run on Jenkins or locally with the commands below assuming you have a registry service somewhere. The docker image / push commands should be ignored if you do not have a registry service or intend to run locally.

```
#!/usr/bin/env bash
docker build . -t my-docker-website --no-cache
# Below only applies to pushing to a registry
docker image tag my-docker-website docker-registry.example.com/my-docker-website:latest
docker push docker-registry.example.com/my-docker-website:latest
```

## Running the container

Pulling from a registry and running the container:

* Replace /var/web_configs/config.php with the path to your application configuration file if applicable.

```
#!/usr/bin/env bash
docker image pull docker-registry.example.com/my-docker-website:latest
docker run -d -p 9001:9001 --restart=always --name my-docker-website -v /var/web_configs/config.php:/var/www/html/config.php docker-registry.example.com/my-docker-website:latest
```

Running a container locally:

```
#!/usr/bin/env bash
docker run -d -p 9001:9001 --restart=always --name my-docker-website -v /var/web_configs/config.php:/var/www/html/config.php my-docker-website
```

## Adding your website code

Clone / fork this repository, and then add your website files inside of the "website" directory. You can also mount your website files by using the following command:

```
#!/usr/bin/env bash
docker run -d -p 9001:9001 --restart=always --name my-docker-website -v /var/web_configs/config.php:/var/www/html/config.php -v /var/www/website_files/:/var/www/html my-docker-website
```

## Nginx configuration

A simple nginx configuration to get started.

```
server {
    server_name  www.example.com;
    listen       80;

    error_log /var/log/nginx/www.example.com.error.log;
    access_log  /var/log/nginx/www.example.com.access.log;

    root /var/www/html;
    index index.php;

    location ~ /\. {
        deny all;
    }

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass 127.0.0.1:9001;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
```
