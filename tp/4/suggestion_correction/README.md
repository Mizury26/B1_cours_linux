# TP4 : Real services

# Partie 1 : Partitionnement du serveur de stockage

🌞 **Partitionner le disque à l'aide de LVM**

```
[it4@storage ~]$ lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda           8:0    0    5G  0 disk 
├─sda1        8:1    0    1G  0 part /boot
└─sda2        8:2    0    4G  0 part 
  ├─rl-root 253:0    0  3.5G  0 lvm  /
  └─rl-swap 253:1    0  512M  0 lvm  [SWAP]
sdb           8:16   0    2G  0 disk 
sr0          11:0    1 1024M  0 rom  

[it4@storage ~]$ sudo pvcreate /dev/sdb
  Physical volume "/dev/sdb" successfully created.

[it4@storage ~]$ sudo vgcreate storage /dev/sdb
  Volume group "storage" successfully created

[it4@storage ~]$ sudo lvcreate -l 100%FREE storage --name tp4_data
  Logical volume "tp4_data" created.
```

🌞 **Formater la partition**

```bash
[it4@storage ~]$ sudo mkfs.ext4 /dev/storage/tp4_data 
mke2fs 1.46.5 (30-Dec-2021)
Creating filesystem with 523264 4k blocks and 130816 inodes
Filesystem UUID: c2a38a00-89dc-49e6-a164-374d7662471b
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done 
```

🌞 **Monter la partition**

```bash
[it4@storage ~]$ sudo mkdir /storage
[it4@storage ~]$ sudo mount /dev/storage/tp4_data /storage/
[it4@storage ~]$ sudo vim /etc/fstab 
[it4@storage ~]$ 
[it4@storage ~]$ sudo umount /storage/
[it4@storage ~]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
mount: /storage does not contain SELinux labels.
       You just mounted a file system that supports labels which does not
       contain labels, onto an SELinux box. It is likely that confined
       applications will generate AVC messages and not be allowed access to
       this file system.  For more details see restorecon(8) and mount(8).
/storage                 : successfully mounted
[it4@storage ~]$ cat /etc/fstab 

#
# /etc/fstab
# Created by anaconda on Mon Jan  9 12:25:01 2023
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
/dev/mapper/rl-root     /                       xfs     defaults        0 0
UUID=ccd0e43c-f46e-42a0-aadc-15baf71c02bb /boot xfs     defaults        0 0
/dev/mapper/rl-swap     none                    swap    defaults        0 0
/dev/storage/tp4_data   /storage                ext4    defaults        0 0
```


# Partie 2 : Serveur de partage de fichiers

- avoir deux dossiers sur **`storage.tp4.linux`** partagés
  - `/storage/site_web_1/`
  - `/storage/site_web_2/`
- la machine **`web.tp4.linux`** monte ces deux dossiers à travers le réseau
  - le dossier `/storage/site_web_1/` est monté dans `/var/www/site_web_1/`
  - le dossier `/storage/site_web_2/` est monté dans `/var/www/site_web_2/`

🌞 **Donnez les commandes réalisées sur le serveur NFS `storage.tp4.linux`**

```bash
# installation du paquet nfs-utils qui permet de lancer le serveur NFS
[it4@web ~]$ sudo dnf install -y nfs-utils
```

```bash
# création des dossiers à partager
[it4@storage ~]$ sudo mkdir -p /storage/site_web_{1,2}
[it4@storage ~]$ sudo chown -R nobody /storage/site_web_*
```

```bash
# conf des dossiers à partager sur le réseau
[it4@storage ~]$ sudo vim /etc/exports
[it4@storage ~]$ cat /etc/exports
/storage/site_web_1 10.104.1.11(rw,sync,no_subtree_check)
/storage/site_web_2 10.104.1.11(rw,sync,no_subtree_check)

# démarrage du serveur NFS
[it4@storage ~]$ sudo systemctl start nfs-server
[it4@storage ~]$ sudo systemctl enable nfs-server

# ouverture des ports firewall nécessaires
[it4@storage ~]$ firewall-cmd --permanent --add-service=nfs
[it4@storage ~]$ firewall-cmd --permanent --add-service=mountd
[it4@storage ~]$ firewall-cmd --permanent --add-service=rpc-bind
[it4@storage ~]$ firewall-cmd --reload
```

🌞 **Donnez les commandes réalisées sur le client NFS `web.tp4.linux`**

```bash
# installation des nfs-utils pour pouvoir monter des partitions en nfs
[it4@web ~]$ sudo dnf install -y nfs-utils
```

```bash
# création des points de montage
[it4@web ~]$ sudo mkdir -p /var/www/site_web_{1,2}
```

```bash
# test de montage manuel des partitions
[it4@web ~]$ sudo mount -t nfs 10.104.1.12:/storage/site_web_1 /var/www/site_web_1/
[it4@web ~]$ sudo mount -t nfs 10.104.1.12:/storage/site_web_2 /var/www/site_web_2/

# vérif
[it4@web ~]$ df -h
Filesystem                       Size  Used Avail Use% Mounted on
devtmpfs                         4.0M     0  4.0M   0% /dev
tmpfs                            886M     0  886M   0% /dev/shm
tmpfs                            355M  5.0M  350M   2% /run
/dev/mapper/rl-root              3.5G  1.2G  2.4G  33% /
/dev/sda1                       1014M  299M  716M  30% /boot
tmpfs                            178M     0  178M   0% /run/user/1000
10.104.1.12:/storage/site_web_1  2.0G     0  1.9G   0% /var/www/site_web_1
10.104.1.12:/storage/site_web_2  2.0G     0  1.9G   0% /var/www/site_web_2
```

```bash
# montage automatique des partitions avec fstab
[it4@web ~]$ sudo vim /etc/fstab 
[it4@web ~]$ cat /etc/fstab
#
# /etc/fstab
# Created by anaconda on Mon Jan  9 12:25:01 2023
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
/dev/mapper/rl-root                       /                       xfs     defaults        0 0
UUID=ccd0e43c-f46e-42a0-aadc-15baf71c02bb /boot                   xfs     defaults        0 0
/dev/mapper/rl-swap                       none                    swap    defaults        0 0
10.104.1.12:/storage/site_web_1           /var/www/site_web_1     nfs     defaults        0 0
10.104.1.12:/storage/site_web_2           /var/www/site_web_2     nfs     defaults        0 0

# démontage manuel
[it4@web ~]$ sudo umount /var/www/site_web_1/
[it4@web ~]$ sudo umount /var/www/site_web_2/

# test du montage automatique avec fstab
[it4@web ~]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
mount.nfs: timeout set for Mon Jan 16 16:40:23 2023
mount.nfs: trying text-based options 'vers=4.2,addr=10.104.1.12,clientaddr=10.104.1.11'
/var/www/site_web_1      : successfully mounted
mount.nfs: timeout set for Mon Jan 16 16:40:23 2023
mount.nfs: trying text-based options 'vers=4.2,addr=10.104.1.12,clientaddr=10.104.1.11'
/var/www/site_web_2      : successfully mounted

# vérif
[it4@web ~]$ df -h
Filesystem                       Size  Used Avail Use% Mounted on
devtmpfs                         4.0M     0  4.0M   0% /dev
tmpfs                            886M     0  886M   0% /dev/shm
tmpfs                            355M  5.0M  350M   2% /run
/dev/mapper/rl-root              3.5G  1.2G  2.4G  33% /
/dev/sda1                       1014M  299M  716M  30% /boot
tmpfs                            178M     0  178M   0% /run/user/1000
10.104.1.12:/storage/site_web_1  2.0G     0  1.9G   0% /var/www/site_web_1
10.104.1.12:/storage/site_web_2  2.0G     0  1.9G   0% /var/www/site_web_2
```
# Partie 3 : Serveur web

## 2. Install

🌞 **Installez NGINX**

```bash
# installation du service NGINX
[it4@web ~]$ sudo dnf install -y nginx
```

## 3. Analyse


```bash
# démarrage + activation (start + enable) du service
[it4@web ~]$ sudo systemctl enable --now nginx
```

🌞 **Analysez le service NGINX**

```bash
[it4@web ~]$ ps -ef | grep nginx
root        5297       1  0 17:08 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx       5298    5297  0 17:08 ?        00:00:00 nginx: worker process
it4         5300    4214  0 17:08 pts/0    00:00:00 grep --color=auto nginx

[it4@web ~]$ sudo ss -alnpt | grep nginx
LISTEN 0      511          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=5298,fd=6),("nginx",pid=5297,fd=6))
LISTEN 0      511             [::]:80           [::]:*    users:(("nginx",pid=5298,fd=7),("nginx",pid=5297,fd=7))

[it4@web ~]$ cat /etc/nginx/nginx.conf | grep root
        root         /usr/share/nginx/html;
#        root         /usr/share/nginx/html;

# les fichiers appartiennent à root mais sont lisibles par tous les autres, y comrpis notre user nginx
[it4@web ~]$ ls -al /usr/share/nginx/html
total 12
drwxr-xr-x. 3 root root  143 Jan 16 17:06 .
drwxr-xr-x. 4 root root   33 Jan 16 17:06 ..
-rw-r--r--. 1 root root 3332 Oct 31 16:35 404.html
-rw-r--r--. 1 root root 3404 Oct 31 16:35 50x.html
drwxr-xr-x. 2 root root   27 Jan 16 17:06 icons
lrwxrwxrwx. 1 root root   25 Oct 31 16:37 index.html -> ../../testpage/index.html
-rw-r--r--. 1 root root  368 Oct 31 16:35 nginx-logo.png
lrwxrwxrwx. 1 root root   14 Oct 31 16:37 poweredby.png -> nginx-logo.png
lrwxrwxrwx. 1 root root   37 Oct 31 16:37 system_noindex_logo.png -> ../../pixmaps/system-noindex-logo.png
```

## 4. Visite du service web

🌞 **Configurez le firewall pour autoriser le trafic vers le service NGINX**

```
[it4@web ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
susuccess
[it4@web ~]$ sudo firewall-cmd --reload
success
```

🌞 **Accéder au site web**

```bash
# depuis le PC hôte
❯ curl 10.104.1.11 -silent  | head -n10
HTTP/1.1 200 OK
Server: nginx/1.20.1
Date: Mon, 16 Jan 2023 16:12:14 GMT
Content-Type: text/html
Content-Length: 7620
Last-Modified: Wed, 27 Jul 2022 18:05:24 GMT
Connection: keep-alive
ETag: "62e17e64-1dc4"
Accept-Ranges: bytes
```

🌞 **Vérifier les logs d'accès**

```bash
[it4@web ~]$ sudo tail -n3 /var/log/nginx/access.log
10.104.1.1 - - [16/Jan/2023:17:12:05 +0100] "GET / HTTP/1.1" 200 7620 "-" "curl/7.87.0" "-"
10.104.1.1 - - [16/Jan/2023:17:12:12 +0100] "GET / HTTP/1.1" 200 7620 "nt" "curl/7.87.0" "-"
10.104.1.1 - - [16/Jan/2023:17:12:14 +0100] "GET / HTTP/1.1" 200 7620 "nt" "curl/7.87.0" "-"
```

## 5. Modif de la conf du serveur web

🌞 **Changer le port d'écoute**

```bash
# modif du firewall pour ouvrir le nouveau port et fermer l'ancien
[it4@web ~]$ sudo firewall-cmd --remove-port=80/tcp --permanent
success
[it4@web sudo firewall-cmd --add-port=8080/tcp --permanent
success
[it4@web ~]$ sudo firewall-cmd --reload
success

# modif de la conf de NGINX pour lui ordonner d'écouter sur le port 8080 plutôt que 80
[it4@web ~]$ sudo vim /etc/nginx/nginx.conf
[it4@web ~]$ grep 8080 /etc/nginx/nginx.conf
        listen       8080;

# rédémarrage du service
[it4@web ~]$ sudo systemctl restart nginx

# on vérifie qu'il écoute sur le nouveau port
[it4@web ~]$ sudo ss -alnpt | grep nginx
LISTEN 0      511          0.0.0.0:8080      0.0.0.0:*    users:(("nginx",pid=5361,fd=6),("nginx",pid=5360,fd=6))
```

```bash
# depuis le client
❯ curl 10.104.1.11:8080 -silent  | head -n10
HTTP/1.1 200 OK
Server: nginx/1.20.1
Date: Mon, 16 Jan 2023 16:14:03 GMT
Content-Type: text/html
Content-Length: 7620
Last-Modified: Wed, 27 Jul 2022 18:05:24 GMT
Connection: keep-alive
ETag: "62e17e64-1dc4"
Accept-Ranges: bytes
```

🌞 **Changer l'utilisateur qui lance le service**

```bash
# création du user web
[it4@web ~]$ sudo useradd -m -d /home/web web

# on indique à NGINX qu'il doit exécuter le processus sous l'identité de ce nouvel utilisateur
[it4@web ~]$ sudo vim /etc/nginx/nginx.conf
[it4@web ~]$ grep user /etc/nginx/nginx.conf
user web;
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
[it4@web ~]$ grep user /etc/nginx/nginx.conf | grep web
user web;

# redémarrage de NGINX pour que le changement de la conf prenne effet
[it4@web ~]$ sudo systemctl restart nginx

# vérif
[it4@web ~]$ ps -ef | grep nginx
root        5391       1  0 17:17 ?        00:00:00 nginx: master process /usr/sbin/nginx
web         5393    5391  0 17:17 ?        00:00:00 nginx: worker process
it4         5395    4214  0 17:17 pts/0    00:00:00 grep --color=auto nginx
```

## 6. Deux sites web sur un seul serveur

🌞 **Repérez dans le fichier de conf**

```bash
[it4@web ~]$ grep 'conf.d' /etc/nginx/nginx.conf
    # Load modular configuration files from the /etc/nginx/conf.d directory.
    include /etc/nginx/conf.d/*.conf;
```

```bash
# fichier de conf du premier site
[it4@web ~]$ sudo vim /etc/nginx/conf.d/site_web_1.conf
[it4@web ~]$ cat /etc/nginx/conf.d/site_web_1.conf
server {
  listen 8080;
  root /var/www/site_web_1;
}

# fichier de conf du second site
[it4@web ~]$ sudo vim /etc/nginx/conf.d/site_web_2.conf
[it4@web ~]$ cat /etc/nginx/conf.d/site_web_2.conf
server {
  listen 8888;
  root /var/www/site_web_2;
}

# redémarrage de NGINX pour que la conf prenne effet
[it4@web ~]$ sudo systemctl restart nginx

# création des deux pages d'accueil HTML
[it4@web ~]$ echo 'hello site1' | sudo tee  /var/www/site_web_1/index.html
hello site1
[it4@web ~]$ echo 'hello site2' | sudo tee  /var/www/site_web_2/index.html
hello site2

# ouverture du port firewall
[it4@web ~]$ sudo firewall-cmd --add-port=8888/tcp --permanent
success
[it4@web ~]$ sudo firewall-cmd --reload
success
```
🌞 **Prouvez que les deux sites sont disponibles**

```bash
# sur le PC hôte
❯ curl 10.104.1.11:8080
hello site1
❯ curl 10.104.1.11:8888
hello site2
```
