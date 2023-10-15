#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <your_domain>"
    exit 1
fi

your_domain="$1"

# Create the directory structure
sudo mkdir -p /var/www/"$your_domain"/html
sudo chown -R $USER:$USER /var/www/"$your_domain"/html
sudo chmod -R 755 /var/www/"$your_domain"

# Create the HTML index page
sudo echo '<html>
    <head>
        <title>Welcome to '"$your_domain"'!</title>
    </head>
    <body>
        <h1>Success! The '"$your_domain"' server block is working!</h1>
    </body>
</html>' >> /var/www/"$your_domain"/html/index.html

# Create an Nginx server block
sudo echo "server {
    listen 80;
    listen [::]:80;

    root /var/www/$your_domain/html;
    index index.html index.htm index.nginx-debian.html;

    server_name $your_domain www.$your_domain;

    location / {
        try_files \$uri \$uri/ =404;
    }
}" >> /etc/nginx/sites-available/"$your_domain"

# Enable the Nginx server block
sudo ln -s /etc/nginx/sites-available/"$your_domain" /etc/nginx/sites-enabled/
sudo systemctl restart nginx

echo "Server configuration for $your_domain is complete."
