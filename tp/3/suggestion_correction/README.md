# TP 3 : We do a little scripting

## Sommaire

- [TP 3 : We do a little scripting](#tp-3--we-do-a-little-scripting)
  - [Sommaire](#sommaire)
- [0. Un premier script](#0-un-premier-script)
- [I. Script carte d'identité](#i-script-carte-didentité)
  - [Rendu](#rendu)
- [II. Script youtube-dl](#ii-script-youtube-dl)
  - [Rendu](#rendu-1)
- [III. MAKE IT A SERVICE](#iii-make-it-a-service)
  - [Rendu](#rendu-2)
- [IV. Bonus](#iv-bonus)

# I. Script carte d'identité

➜ [Script idcard.sh](./idcard/idcard.sh)

➜ Exemple d'exécution

```bash
[it4@tp3 ~]$ sudo /tmp/idcard/id_card.sh 
Machine name : tp3
OS Rocky Linux and kernel version is 5.14.0-162.6.1.el9_1.x86_64
IP : 10.5.1.103/24
RAM : 1.4Gi memory available on 1.7Gi total memory
Disk : 2.6G space left
Top 5 processes by RAM usage :
  - python
  - /usr/bin/python3
  - /usr/sbin/NetworkManager
  - /usr/lib/systemd/systemd
  - /usr/lib/systemd/systemd
Listening ports :
  - 22 tcp : sshd
  - 323 udp : chronyd
Here is your random cat : cat_pic.jpeg
```

# II. Script youtube-dl

➜ Préparation de l'environnement

```bash
[it4@tp3 ~]$ sudo useradd yt
[it4@tp3 ~]$ sudo mkdir -p /srv/yt/downloads /var/log/yt
[it4@tp3 ~]$ sudo chown -R yt:yt /srv/yt /var/log/yt
```

➜ [Script yt.sh](./yt/yt.sh) 

- à déposer dans `/srv/yt`

```bash
[it4@tp3 ~]$ sudo chown yt:yt /srv/yt/yt.sh
[it4@tp3 ~]$ sudo chmod 700 /srv/yt/yt.sh
```

- exemple d'exécution

```bash
# Show date
[it4@tp3 ~]$ date
Mon Jan 16 10:29:17 CET 2023

# Empty log file
[it4@tp3 ~]$ cat /var/log/yt/download.log

# Script execution
[it4@tp3 ~]$ sudo -u yt /srv/yt/yt.sh https://www.youtube.com/watch?v=jhFDyDgMVUI
[OK] Video https://www.youtube.com/watch?v=jhFDyDgMVUI was downloaded.
[INFO] File path : /srv/yt/downloads/One Second Video/One Second Video.mp4

# Show logfile
[it4@tp3 ~]$ cat /var/log/yt/download.log 
[23/01/16 10:29:25] Video https://www.youtube.com/watch?v=jhFDyDgMVUI was downloaded. File path : /srv/yt/downloads/One Second Video/One Second Video.mp4

# Show downloads folder
[it4@tp3 ~]$ ls /srv/yt/downloads/One\ Second\ Video/
'One Second Video.mp4'   description
```

# III. MAKE IT A SERVICE

➜ Création du [fichier de service](./yt-v2/yt-v2.service)

- on le dépose dans `/etc/systemd/system/yt-v2.service`

➜ Création du script [yt-v2.sh](./yt-v2/yt-v2.sh)

- on le stock au chemin `/srv/yt/yt-v2.sh`

➜ Démarrage et interactions avec le service

```bash
# on reload la conf car on vient de déposer un nouveau fichier .service
[it4@tp3 ~]$ sudo systemctl daemon-reload

# on peut démarrer le service
[it4@tp3 ~]$ sudo systemctl start yt-v2

# on peut observer le status de notre service
[it4@tp3 ~]$ systemctl status yt-v2
● yt-v2.service - Youtube downloader daemon
     Loaded: loaded (/etc/systemd/system/yt-v2.service; disabled; vendor preset: disabled)
     Active: active (running) since Mon 2023-01-16 14:29:31 CET; 1min 32s ago
   Main PID: 12180 (yt-v2.sh)
      Tasks: 2 (limit: 11067)
     Memory: 39.3M
        CPU: 7.276s
     CGroup: /system.slice/yt-v2.service
             ├─12180 /bin/bash /srv/yt/yt-v2.sh
             └─12190 python /usr/local/bin/youtube-dl "https://www.youtube.com/watch?v=apCqRBHQbjM" -o "./downloads/Funny Penalty Kicks/Funny Penalty Kicks.mp4" --write-description

Jan 16 14:29:31 tp3 systemd[1]: Started Youtube downloader daemon.
Jan 16 14:29:31 tp3 yt-v2.sh[12180]: [INFO] Found the following URL : https://www.youtube.com/watch?v=apCqRBHQbjM. Trying to download video.
```

➜ Et ça donne, dans un terminal :

![ASCIINEMA meow](./yt-v2/yt-v2.svg)
