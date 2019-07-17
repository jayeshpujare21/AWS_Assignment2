#! /bin/bash
apt-get update
apt-get install -y apache2
chmod 777 /var/www/html/index.html
cat <<EOF > /var/www/html/index.html
<html><body><h1>Hello World</h1>
<p>Installing Apache and this page was created from a simple startup script!</p>
</body></html>
EOF
