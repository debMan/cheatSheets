# Server Setup: A simple personal cheatsheet

_**Note:**_ This document is not completed.  
This is my personal **Linux Server Setup** cheatsheet.

## VPS

After buy a vps:

1. change root pass 
2. make root inactive
3. add new user
``` bash
adduser mrht74
usermod -aG sudo mrht74
```
3. update and upgrade
4. disable and remove cloud services and snapd
5. install python3-pip and python3 and git
6. install vim and best config
7. change the default SSH port
``` bash
sudo vim /etc/ssh/sshd_config
```
8. Enable 2FA (optional)
9. use SSH keys 
``` bash
ssh-copy-id mrht74@Remote
```
10. set ssh config on client
``` bash
vim ~/.ssh/config 			
```
11. set webmin [Click here](www.webmin.com)
12. Set up a firewall
13. Backup your server
14. Set up monitoring
15. Set up a mail server
16. Install an (S)FTP server
17. Telegram MTProto
 [Click here](https://github.com/TelegramMessenger/MTProxy)
18. start vpn server
 [link 1](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-openvpn-server-on-ubuntu-16-04)
 [link 2](https://www.linuxbabe.com/ubuntu/openconnect-vpn-server-ocserv-ubuntu-16-04-17-10-lets-encrypt)

