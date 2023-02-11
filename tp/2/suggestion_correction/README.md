# TP2 : Appréhender l'environnement Linux

# I. Service SSH

## 1. Analyse du service

🌞 **S'assurer que le service `sshd` est démarré**

```
[it4@tp2 ~]$ systemctl status sshd
● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2022-11-22 15:09:23 CET; 35min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 684 (sshd)
      Tasks: 1 (limit: 5905)
     Memory: 5.4M
        CPU: 262ms
     CGroup: /system.slice/sshd.service
             └─684 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"
```

🌞 **Analyser les processus liés au service SSH**

```bash
[it4@tp2 ~]$ ps -ef | grep sshd
root         684       1  0 15:09 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root        1876     684  0 15:44 ?        00:00:00 sshd: it4 [priv]
it4         1879    1876  0 15:44 ?        00:00:00 sshd: it4@pts/0
it4         1922    1880  0 15:45 pts/0    00:00:00 grep --color=auto sshd
```

🌞 **Déterminer le port sur lequel écoute le service SSH**

```bash
[it4@tp2 ~]$ sudo ss -alnpt | grep sshd
LISTEN 0      128          0.0.0.0:22         0.0.0.0:*    users:(("sshd",pid=684,fd=3))                                                                      
LISTEN 0      128             [::]:22            [::]:*    users:(("sshd",pid=684,fd=4)) 
```
🌞 **Consulter les logs du service SSH**

```bash
[it4@tp2 ~]$ sudo journalctl -xe -u sshd
░░ 
░░ A start job for unit sshd.service has begun execution.
░░ 
░░ The job identifier is 245.
Nov 22 15:09:23 nc sshd[684]: Server listening on 0.0.0.0 port 22.
Nov 22 15:09:23 nc sshd[684]: Server listening on :: port 22.
Nov 22 15:09:23 nc systemd[1]: Started OpenSSH server daemon.
░░ Subject: A start job for unit sshd.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░ 
░░ A start job for unit sshd.service has finished successfully.
```

```bash
[it4@tp2 ~]$ sudo tail -n10 /var/log/secure 
Nov 22 15:46:53 nc sudo[1929]: pam_unix(sudo:auth): auth could not identify password for [it4]
Nov 22 15:46:58 nc sudo[1931]:     it4 : TTY=pts/0 ; PWD=/home/it4 ; USER=root ; COMMAND=/sbin/ss -alnpt
Nov 22 15:46:58 nc sudo[1931]: pam_unix(sudo:session): session opened for user root(uid=0) by it4(uid=1000)
Nov 22 15:46:58 nc sudo[1931]: pam_unix(sudo:session): session closed for user root
Nov 22 15:47:23 nc sudo[1945]:     it4 : TTY=pts/0 ; PWD=/home/it4 ; USER=root ; COMMAND=/bin/journalctl -xe -u sshd
Nov 22 15:47:23 nc sudo[1945]: pam_unix(sudo:session): session opened for user root(uid=0) by it4(uid=1000)
Nov 22 15:47:25 nc sudo[1945]: pam_unix(sudo:session): session closed for user root
Nov 22 15:47:27 nc sudo[1949]:     it4 : TTY=pts/0 ; PWD=/home/it4 ; USER=root ; COMMAND=/bin/journalctl -xe -u sshd
Nov 22 15:47:27 nc sudo[1949]: pam_unix(sudo:session): session opened for user root(uid=0) by it4(uid=1000)
Nov 22 15:47:27 nc sudo[1949]: pam_unix(sudo:session): session closed for user root
```


## 2. Modification du service

🌞 **Identifier le fichier de configuration du serveur SSH**

```bash
[it4@tp2 ~]$ ls -al /etc/ssh/sshd_config
-rw-------. 1 root root 3669 Sep 20 20:46 /etc/ssh/sshd_config
```

🌞 **Modifier le fichier de conf**

```bash
# on récup un nombre random
[it4@tp2 ~]$ echo $RANDOM
19582

# modif du fichier de conf du serv SSH
[it4@tp2 ~]$ sudo vim /etc/ssh/sshd_config
[it4@tp2 ~]$ sudo cat /etc/ssh/sshd_config | grep "Port "
Port 19582

# gestion de firewall
[it4@tp2 ~]$ sudo firewall-cmd --add-port=19582/tcp --permanent
success
[it4@tp2 ~]$ sudo firewall-cmd --remove-service=ssh --permanent
success
[it4@tp2 ~]$ sudo firewall-cmd --reload
success
```

🌞 **Redémarrer le service**

```bash
[it4@tp2 ~]$ sudo systemctl restart sshd
```

🌞 **Effectuer une connexion SSH sur le nouveau port**

```bash
[it4@nowhere tp]$ ssh 10.44.44.3 -p 19582
Last login: Tue Nov 22 15:44:44 2022 from 10.44.44.1
```

✨ **Bonus : affiner la conf du serveur SSH**

```bash
# on modifie la conf du serv SSH
[it4@tp2 ~]$ sudo vim /etc/ssh/sshd_config

# mise en évidence des lignes modifiées
## on désactive la possibilité de se co en tant que root via SSH
[it4@tp2 ~]$ sudo cat /etc/ssh/sshd_config | grep '^PermitRootLogin'
PermitRootLogin no
## on désactive la possibilité de se co avec des mots de passe vides
[it4@tp2 ~]$ sudo cat /etc/ssh/sshd_config | grep '^PermitEmpty'
PermitEmptyPasswords no

# on redémarre le service pour que les changements prennent effet
[it4@tp2 ~]$ sudo systemctl restart sshd
```

# II. Service HTTP

## 1. Mise en place

🌞 **Installer le serveur NGINX**

```bash
[it4@tp2 ~]$ sudo dnf install -y nginx
[...]
```

🌞 **Démarrer le service NGINX**

```bash
[it4@tp2 ~]$ sudo systemctl start nginx
```

🌞 **Déterminer sur quel port tourne NGINX**

```bash
# on repère le port utilisé par NGINX : 80 en TCP
[it4@tp2 ~]$ sudo ss -alnpt | grep nginx
LISTEN 0      511          0.0.0.0:80         0.0.0.0:*    users:(("nginx",pid=2506,fd=6),("nginx",pid=2505,fd=6))
LISTEN 0      511             [::]:80            [::]:*    users:(("nginx",pid=2506,fd=7),("nginx",pid=2505,fd=7))

# on gère le firewall de façon adéquate
[it4@tp2 ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[it4@tp2 ~]$ sudo firewall-cmd --reload
success
```

🌞 **Déterminer les processus liés à l'exécution de NGINX**

```bash
[it4@tp2 ~]$ ps -ef | grep nginx
root        2505       1  0 15:57 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx       2506    2505  0 15:57 ?        00:00:00 nginx: worker process
it4         2539    1880  0 15:59 pts/0    00:00:00 grep --color=auto nginx
```

🌞 **Euh wait**

```bash
[it4@nowhere tp]$ curl http://10.44.44.3 | head -n7
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!doctype html>
<html>
1  <head>
0    <meta charset='utf-8'>
0    <meta name='viewport' content='width=device-width, initial-scale=1'>
     <title>HTTP Server Test Page powered by: Rocky Linux</title>
     <style type="text/css">
7620  100  7620    0     0  1591k      0 --:--:-- --:--:-- --:--:-- 1860k
curl: (23) Failed writing body
```

## 2. Analyser la conf de NGINX

🌞 **Déterminer le path du fichier de configuration de NGINX**

```bash
[it4@tp2 ~]$ ls -al /etc/nginx/nginx.conf
-rw-r--r--. 1 root root 2334 May 16  2022 /etc/nginx/nginx.conf
```

🌞 **Trouver dans le fichier de conf**

```bash
# le bloc serveur qui permet de servir le site par défaut
[it4@tp2 ~]$ cat /etc/nginx/nginx.conf | grep '^ *server {' -A 16
    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }

# les lignes d'include
[it4@tp2 ~]$ cat /etc/nginx/nginx.conf | grep include
include /usr/share/nginx/modules/*.conf;
    include             /etc/nginx/mime.types;
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/default.d/*.conf;
#        include /etc/nginx/default.d/*.conf;
```

## 3. Déployer un nouveau site web

🌞 **Créer un site web**

```bash
[it4@tp2 ~]$ sudo mkdir /var/www/tp2_linux
[it4@tp2 ~]$ sudo vim /var/www/tp2_linux/index.html
[it4@tp2 ~]$ cat /var/www/tp2_linux/index.html
<h1>MEOW mon premier serveur web</h1>
```

🌞 **Adapter la conf NGINX**

```bash
# génération d'un port random
[it4@tp2 ~]$ echo $RANDOM
22209

# modif de la conf de nginx
[it4@tp2 ~]$ sudo vim /etc/nginx/conf.d/tp2.b1.conf
[it4@tp2 ~]$ cat /etc/nginx/conf.d/tp2.b1.conf
server {
  listen 22209;

  root /var/www/tp2_linux;
}

# gestion adéquate du firewall
[it4@tp2 ~]$ sudo firewall-cmd --add-port=22209/tcp --permanent
success
[it4@tp2 ~]$ sudo firewall-cmd --reload
success

# redémarrage du service nginx pour que les changements prennent effet
[it4@tp2 ~]$ sudo systemctl restart nginx
```

🌞 **Visitez votre super site web**

```bash
[it4@tp2 ~]$ curl http://10.44.44.3:22209
<h1>MEOW mon premier serveur web</h1>
```

# III. Your own services

## 2. Analyse des services existants

🌞 **Afficher le fichier de service SSH**

```bash
[it4@tp2 ~]$ sudo systemctl status sshd  | grep loaded
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
[it4@tp2 ~]$  cat  /usr/lib/systemd/system/sshd.service
[Unit]
Description=OpenSSH server daemon
Documentation=man:sshd(8) man:sshd_config(5)
After=network.target sshd-keygen.target
Wants=sshd-keygen.target

[Service]
Type=notify
EnvironmentFile=-/etc/sysconfig/sshd
ExecStart=/usr/sbin/sshd -D $OPTIONS
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure
RestartSec=42s

[Install]
WantedBy=multi-user.target
[it4@tp2 ~]$  cat  /usr/lib/systemd/system/sshd.service | grep ExecStart=
ExecStart=/usr/sbin/sshd -D $OPTIONS
```

🌞 **Afficher le fichier de service NGINX**

```bash
[it4@tp2 ~]$ sudo systemctl cat nginx | grep ExecStart=
ExecStart=/usr/sbin/nginx
```

## 3. Création de service

🌞 **Créez le fichier `/etc/systemd/system/tp2_nc.service`**

```bash
# génération du nombre aléatoire
[it4@tp2 ~]$ echo $RANDOM
22064

# création du service
[it4@tp2 ~]$ sudo vim /etc/systemd/system/tp2_nc.service
[it4@tp2 ~]$ cat /etc/systemd/system/tp2_nc.service
[Unit]    
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 22064
```

🌞 **Indiquer au système qu'on a modifié les fichiers de service**

```bash
[it4@tp2 ~]$ sudo systemctl daemon-reload
```

🌞 **Démarrer notre service de ouf**

```bash
[it4@tp2 ~]$ sudo systemctl start tp2_nc
```

🌞 **Vérifier que ça fonctionne**

```bash
# le status de notre service nc custom
[it4@tp2 ~]$ sudo systemctl status tp2_nc
● tp2_nc.service - Super netcat tout fou
     Loaded: loaded (/etc/systemd/system/tp2_nc.service; static)
     Active: active (running) since Tue 2022-11-22 16:17:24 CET; 2min 8s ago
   Main PID: 2867 (nc)
      Tasks: 1 (limit: 5905)
     Memory: 1.1M
        CPU: 4ms
     CGroup: /system.slice/tp2_nc.service
             └─2867 /usr/bin/nc -l 22064

Nov 22 16:17:24 tp2.b1 systemd[1]: Started Super netcat tout fou.

# on observe que nc écoute bien derrière le port choisi
[it4@tp2 ~]$ sudo ss -alnpt | grep nc
LISTEN 0      10           0.0.0.0:22064      0.0.0.0:*    users:(("nc",pid=2867,fd=4))                           
LISTEN 0      10              [::]:22064         [::]:*    users:(("nc",pid=2867,fd=3))                           

# on gère le firewall de façon adéquate
[it4@tp2 ~]$ sudo firewall-cmd --add-port=22064/tcp --permanent
success
[it4@tp2 ~]$ sudo firewall-cmd --reload
```

```bash
# test depuis le PC hôte
[it4@tp2 ~]$ nc 10.44.44.3 22064
MEOW bro
^C
```


🌞 **Les logs de votre service**

- mais euh, ça s'affiche où les messages envoyés par le client ? Dans les logs !
- `sudo journalctl -xe -u tp2_nc` pour visualiser les logs de votre service
- `sudo journalctl -xe -u tp2_nc -f ` pour visualiser **en temps réel** les logs de votre service
  - `-f` comme follow (on "suit" l'arrivée des logs en temps réel)
- dans le compte-rendu je veux
  - une commande `journalctl` filtrée avec `grep` qui affiche la ligne qui indique le démarrage du service
  - une commande `journalctl` filtrée avec `grep` qui affiche un message reçu qui a été envoyé par le client
  - une commande `journalctl` filtrée avec `grep` qui affiche la ligne qui indique l'arrêt du service

```bash
# une ligne de log qui indique que le service a correctement démarré
[it4@tp2 ~]$ sudo journalctl -xe | grep start | tail -n1
░░ A start job for unit tp2_nc.service has finished successfully.

# l'un des messages envoyés par le client
[it4@tp2 ~]$ sudo journalctl -xe | grep MEOW
Nov 22 16:23:21 tp2.b1 nc[2971]: MEOW bro

# un message qui indique que le service a terminé de s'exécuter
[it4@tp2 ~]$ sudo journalctl -xe -u tp2_nc | grep Deactivated | tail -n1
Nov 22 16:23:22 tp2.b1 systemd[1]: tp2_nc.service: Deactivated successfully.
```

🌞 **Affiner la définition du service**

```bash
# modification du service
[it4@tp2 ~]$ sudo vim /etc/systemd/system/tp2_nc.service
[it4@tp2 ~]$ sudo cat /etc/systemd/system/tp2_nc.service
[Unit]    
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 22064
Restart=always

# on indique au système qu'on a modifié le fichier .service
[it4@tp2 ~]$ sudo systemctl daemon-reload

# on redémarre le service pour que notre changement prenne effet
[it4@tp2 ~]$ sudo systemctl restart tp2_nc
```

On peut alors, depuis le client, effectuer des connexions répétées, et depuis le serveur, utiliser `journalctl -xe -u tp2_nc -f` pour visualiser que le serveur s'allume -> reçoit des messages -> se termine -> se relance automatiquement.

**Client** :

```bash
[it4@tp2 ~]$ date
Tue Nov 22 04:34:23 PM CET 2022
[it4@tp2 ~]$ nc 10.44.44.3 22064
toujours là ?

^C
[it4@tp2 ~]$ date
Tue Nov 22 04:34:27 PM CET 2022
[it4@tp2 ~]$ nc 10.44.44.3 22064
meo
cool
^C
```

**Serveur** :

```bash
ov 22 16:34:25 tp2.b1 nc[3171]: toujours là ?
Nov 22 16:34:26 tp2.b1 systemd[1]: tp2_nc.service: Deactivated successfully.
░░ Subject: Unit succeeded
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░ 
░░ The unit tp2_nc.service has successfully entered the 'dead' state.
Nov 22 16:34:26 tp2.b1 systemd[1]: tp2_nc.service: Scheduled restart job, restart counter is at 8.
░░ Subject: Automatic restarting of a unit has been scheduled
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░ 
░░ Automatic restarting of the unit tp2_nc.service has been scheduled, as the result for
░░ the configured Restart= setting for the unit.
Nov 22 16:34:26 tp2.b1 systemd[1]: Stopped Super netcat tout fou.
░░ Subject: A stop job for unit tp2_nc.service has finished
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░ 
░░ A stop job for unit tp2_nc.service has finished.
░░ 
░░ The job identifier is 3229 and the job result is done.
Nov 22 16:34:26 tp2.b1 systemd[1]: Started Super netcat tout fou.
░░ Subject: A start job for unit tp2_nc.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░ 
░░ A start job for unit tp2_nc.service has finished successfully.
░░ 
░░ The job identifier is 3229.
Nov 22 16:34:30 tp2.b1 nc[3174]: meo
Nov 22 16:34:32 tp2.b1 nc[3174]: cool
Nov 22 16:34:32 tp2.b1 systemd[1]: tp2_nc.service: Deactivated successfully.
░░ Subject: Unit succeeded
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░ 
░░ The unit tp2_nc.service has successfully entered the 'dead' state.
Nov 22 16:34:32 tp2.b1 systemd[1]: tp2_nc.service: Scheduled restart job, restart counter is at 9.
░░ Subject: Automatic restarting of a unit has been scheduled
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░ 
░░ Automatic restarting of the unit tp2_nc.service has been scheduled, as the result for
░░ the configured Restart= setting for the unit.
Nov 22 16:34:32 tp2.b1 systemd[1]: Stopped Super netcat tout fou.
░░ Subject: A stop job for unit tp2_nc.service has finished
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░ 
░░ A stop job for unit tp2_nc.service has finished.
░░ 
░░ The job identifier is 3315 and the job result is done.
Nov 22 16:34:32 tp2.b1 systemd[1]: Started Super netcat tout fou.
░░ Subject: A start job for unit tp2_nc.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░ 
░░ A start job for unit tp2_nc.service has finished successfully.
░░ 
░░ The job identifier is 3315.
```

