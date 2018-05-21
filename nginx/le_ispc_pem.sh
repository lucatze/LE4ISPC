#!/bin/sh
### BEGIN INIT INFO
# Provides:  LE ISPSERVER.PEM AUTO UPDATER
# Required-Start:  $local_fs $network
# Required-Stop:  $local_fs
# Default-Start:  2 3 4 5
# Default-Stop:  0 1 6
# Short-Description:  LE ISPSERVER.PEM AUTO UPDATER
# Description:  Update ispserver.pem automatically after ISPC LE SSL certs are renewed.
### END INIT INFO
cd /usr/local/ispconfig/interface/ssl/
mv ispserver.pem ispserver.pem-$(date +"%y%m%d%H%M%S").bak
cat ispserver.{key,crt} > ispserver.pem
chmod 600 ispserver.pem
chmod 600 /etc/ssl/private/pure-ftpd.pem
service pure-ftpd-mysql restart
if [ -d "/etc/monit" ]; then
  service monit restart
fi
service postfix restart
service dovecot restart
service nginx restart

# Enable and modify accordingly to automate to transfer LE SSL certs to other servers 
# scp -P XX -r /etc/letsencrypt/ root@server2.domain.tld:~/etc/
# Use -P XX if your ssh use different port then default 22, where XX is assigned ssh port number.
# You can also use rsync if you have it installed in your system
# rsync -a -e "ssh -p XX" /etc/letsencrypt/ root@server2.domain.tld:~/etc/letsencrypt/
# Use "ssh -p XX" if your ssh use different port then default 22, where XX is assigned ssh port number.
# Copy and add similar line if you have more server(s).
