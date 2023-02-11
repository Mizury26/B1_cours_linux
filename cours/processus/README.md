# Processus

Dans ce cours on va parler de processus. Le but est de répondre aux questions suivantes :

- qu'est-ce qu'un *processus* ?
- comment les *processus* sont gérés dans un système GNU/Linux ?
- comment on interagit avec un *processus* pendant qu'il s'exécute ?

Hope u enjoy.

![Program thinking](./pics/program.jpg)

## Sommaire

- [Processus](#processus)
  - [Sommaire](#sommaire)
- [I. Intro](#i-intro)
- [II. La vie des processus](#ii-la-vie-des-processus)
  - [1. Arborescence de processus](#1-arborescence-de-processus)
  - [2. Fin de vie des processus](#2-fin-de-vie-des-processus)
  - [3. Environnement](#3-environnement)
- [III. Gestion de processus](#iii-gestion-de-processus)
  - [1. Les signaux](#1-les-signaux)
  - [2. Arrière plan](#2-arrière-plan)
  - [3. Services](#3-services)

# I. Intro

➜ **Un *processus* est un *programme* en *cours d'exécution*.**

> Mettons tout de suite un truc de côté : les mots "application", "logiciel", "programme", "exécutable", "software" désignent la même chose. Les commandes utilisées dans le terminal sont aussi des *programmes*.

Un ***programme*** est **un fichier stocké sur le disque** dur d'une machine, et qui **contient une suite d'instructions**. Cette suite d'instruction, c'est du code en assembleur : c'est le langage du processeur.

Pour démystifier un peu, un exemple très court et très simpliste d'assembleur, que vous voyez à quoi ça ressemble :

```assembly
; stocke l'entier 7 dans le registre AX
MOV AX,7 

; stocke l'entier 8 dans le registre BX
MOV BX,8 

; additionne le contenu de AX et BX, stocke le résultat dans AX
ADD AX,BX 
```

> C'est un langage extrêmement simpliste : une instruction par ligne (cette instruction, votre processeur SAIT comment l'exécuter).

Lorsqu'on **exécute** un *programme*, il est **copié du disque à la mémoire vive** (RAM). Une fois déplacé en RAM, **le processeur peut alors lire les instructions, et les exécuter**.

C'est **le noyau** qui a **la tâche de copier un programme du disque vers la mémoire**, et **d'ordonner au processeur d'exécuter des instructions**.

On dit que le *programme* est ***en cours d'exécution*** lorsqu'il a été déplacé en RAM, et que le processeur a reçu l'ordre d'exécuter ces instructions déplacées en RAM.

Un *programme* prend parfois des données en ***entrée*** (comme un `firefox` dans lequel vous saisissez une URL), et produit des données en ***sortie*** (comme un `firefox` qui affiche une fenêtre).

> Quand on dit qu'un processeur a 4 *coeurs* et qu'il est *cadencé* à 3,3GHz, cela veut dire que chacun des coeurs du processeur exécute 3,3 milliards d'instructions assembleur par seconde. PAR SECONDE. Prenez le temps de digérer l'info. Forcément, avec autant d'instructions à la seconde, un ordi n'a aucun mal à nous donner l'illusion que plein de programmes s'exécutent en même temps.

# II. La vie des processus

Une fois le *noyau* (ou *kernel* en anglais) et les différentes applications qui constituent l'OS sont en cours d'exécution, l'utilisateur peut alors prendre la main et utiliser l'OS.

De façon concrète, **un humain qui utilise un OS, ça veut dire qu'à son tour, il demande à exécuter des programmes**, des logiciels, des applications (pour rappel, ces mots désignent la même chose).

## 1. Arborescence de processus

➜ **Le noyau gère les *processus* dans une structure arborescente**

➜ **Chaque programme est exécuté par un *processus* déjà en cours d'exécution** (forcément)

- par exemple, vous exécuter la commande `ls` dans votre shell
  - votre shell, c'est un `bash`
  - ce `bash` c'est un processus en cours d'exécution
  - on dit alors que `ls` est le processus-enfant de `bash`
- autre exemple : vous doublez-cliquez sur l'icone de Firefox sur le bureau
  - votre interface graphique, c'est un shell, c'est un processus en cours d'exécution
  - on dit alors que Firefox est le processus-enfant de votre interface graphique

➜ **Chaque programme porte un identifiant unique appelé *PID***

- le *processus* qui lance un programme est le *parent*
- le programme qui est exécuté devient le *processus* *enfant*
- **on appelle *PPID* d'un *processus* le *PID* du *parent* de ce processus**

➜ **Il est aisé de visualiser cette structure arborescente avec les commandes suivantes**

```bash
# la commande 'ps -ef' est la plus utilisée pour visualiser les process en cours d'exécution
## la colonne PID indique le PID du processus
## la colonne PPID indique le PID de son père
## la colonne CMD indique quel programme a été lancé pour résulter en un processus
[it4@nowhere ~]$ ps -ef
UID          PID    PPID  STIME     TIME CMD
root           1       0  13:58 00:00:00 /sbin/init
[...] # on enlève quelques lignes pour la simplicité de l'exemple
root         447       1  13:58 00:00:00 login -- it4
it4          494       1  13:58 00:00:00 /usr/lib/systemd/systemd --user
it4          495     494  13:58 00:00:00 (sd-pam)
it4          501     494  13:58 00:00:00 /usr/bin/ssh-agent -D -a /run/user/1000/ssh-agent.socket
it4          502     447  13:58 00:00:00 -bash
it4          505     502  13:58 00:00:00 xinit /etc/xdg/xfce4/xinitrc -- /etc/X11/xinit/xserverrc vt1
it4          506     505  13:58 00:00:11 /usr/lib/Xorg -nolisten tcp :0 vt1
it4          518     505  13:58 00:00:00 xfce4-session
it4          525     494  13:58 00:00:00 /usr/bin/dbus-daemon --session --address=systemd: --nofork --nopidfile --systemd-activation --syslog-only
it4          533     494  13:58 00:00:00 /usr/lib/at-spi-bus-launcher
it4          539     533  13:58 00:00:00 /usr/bin/dbus-daemon --config-file=/usr/share/defaults/at-spi2/accessibility.conf --nofork --print-address 11 --addr
it4          543     494  13:58 00:00:00 /usr/lib/xfce4/xfconf/xfconfd
it4          548     494  13:58 00:00:00 /usr/lib/at-spi2-registryd --use-gnome-session
polkitd      550       1  13:58 00:00:00 /usr/lib/polkit-1/polkitd --no-debug
it4          560     494  13:58 00:00:00 /usr/bin/xfce4-screensaver
it4          566       1  13:58 00:00:00 /usr/bin/ssh-agent -s
it4          573     494  13:58 00:00:00 /usr/bin/gpg-agent --supervised
it4          575     518  13:58 00:00:04 xfwm4 --display :0.0 --sm-client-id 2fccb1db0-975a-42c6-be0d-9bec18cf1b9a
it4          586     518  13:58 00:00:00 xfsettingsd --display :0.0 --sm-client-id 2437d92ae-f4ab-4658-ac71-f9c79c30c8b4
it4          588     494  13:58 00:00:00 /usr/bin/pulseaudio --daemonize=no --log-target=journal
rtkit        591       1  13:58 00:00:00 /usr/lib/rtkit-daemon
it4          596     518  13:59 00:00:01 xfce4-panel --display :0.0 --sm-client-id 2cc18a04f-008b-463f-93b5-ae161c115e94
it4          600     518  13:59 00:00:00 Thunar --sm-client-id 2b3370c95-55f6-47f0-9e6f-58f47a141f4c --daemon
it4          605     518  13:59 00:00:00 xfdesktop --display :0.0 --sm-client-id 2b81724dc-3ca7-47e5-a751-1beaffa48d2f
it4          613     518  13:59 00:00:00 xfce4-power-manager --restart --sm-client-id 219caaa6b-87c2-431e-9b63-409e34a3b77e
it4          618     596  13:59 00:00:00 /usr/lib/xfce4/panel/wrapper-2.0 /usr/lib/xfce4/panel/plugins/libsystray.so 6 16777228 systray Status Tray Plugin Pr
it4          619     596  13:59 00:00:02 /usr/lib/xfce4/panel/wrapper-2.0 /usr/lib/xfce4/panel/plugins/libpulseaudio-plugin.so 8 16777229 pulseaudio PulseAud
it4          620     596  13:59 00:00:02 /usr/lib/xfce4/panel/wrapper-2.0 /usr/lib/xfce4/panel/plugins/libxfce4powermanager.so 9 16777230 power-manager-plugi
it4          621     596  13:59 00:00:00 /usr/lib/xfce4/panel/wrapper-2.0 /usr/lib/xfce4/panel/plugins/libnotification-plugin.so 10 16777231 notification-plu
it4          632     518  13:59 00:00:00 /usr/bin/python /usr/bin/blueman-applet
it4          636     518  13:59 00:00:00 nm-applet
root         637       1  13:59 00:00:01 /usr/lib/upowerd
it4          642     518  13:59 00:00:00 /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
it4          651     588  13:59 00:00:00 /usr/lib/pulse/gsettings-helper
it4          652     518  13:59 00:00:00 /usr/lib/xfce4/notifyd/xfce4-notifyd
it4          654     596  13:59 00:00:00 /usr/lib/xfce4/panel/wrapper-2.0 /usr/lib/xfce4/panel/plugins/libactions.so 14 16777232 actions Action Buttons Log o
root         661       2  13:59 00:00:00 [krfcommd]
it4          760     494  13:59 00:00:00 /usr/lib/bluetooth/obexd
it4          762       1  13:59 00:00:02 /usr/bin/python /usr/bin/blueman-tray
root         799       2  14:04 00:00:02 [kworker/3:0-events]
it4          871     596  14:06 00:00:00 xfce4-appfinder --collapsed
it4          885     871  14:06 00:00:01 /usr/bin/python /usr/bin/terminator
it4          913     885  14:06 00:00:00 /bin/bash
root         916       1  14:06 00:00:00 NetworkManager
root         921       1  14:06 00:00:00 /usr/bin/wpa_supplicant -u -s -O /run/wpa_supplicant
it4          962     871  14:06 00:00:36 /usr/lib/firefox/firefox
it4         1056     962  14:06 00:00:00 /usr/lib/firefox/firefox -contentproc -parentBuildID 20221007233509 -prefsLen 27773 -prefMapSize 229579 -appDir /usr
it4         1081     962  14:06 00:00:00 /usr/lib/firefox/firefox -contentproc -childID 1 -isForBrowser -prefsLen 27773 -prefMapSize 229579 -jsInitLen 246848
it4         1131     962  14:06 00:00:02 /usr/lib/firefox/firefox -contentproc -childID 2 -isForBrowser -prefsLen 33266 -prefMapSize 229579 -jsInitLen 246848
it4         1192     962  14:07 00:00:22 /usr/lib/firefox/firefox -contentproc -childID 3 -isForBrowser -prefsLen 33325 -prefMapSize 229579 -jsInitLen 246848
it4         1196     962  14:07 00:00:00 /usr/lib/firefox/firefox -contentproc -childID 4 -isForBrowser -prefsLen 33325 -prefMapSize 229579 -jsInitLen 246848
it4         1198     962  14:07 00:00:00 /usr/lib/firefox/firefox -contentproc -childID 5 -isForBrowser -prefsLen 33325 -prefMapSize 229579 -jsInitLen 246848
it4         1262     962  14:07 00:00:00 /usr/lib/firefox/firefox -contentproc -childID 6 -isForBrowser -prefsLen 33325 -prefMapSize 229579 -jsInitLen 246848
root        1366       2  14:11 00:00:00 [kworker/u8:2-events_power_efficient]
root        1498       2  14:34 00:00:00 [kworker/u8:1-events_unbound]
root        1548       2  14:36 00:00:00 [kworker/0:2-events]
root        1562       2  14:37 00:00:00 [kworker/3:2-events]
root        1567       2  14:38 00:00:00 [kworker/1:0-events]
root        1587       2  14:40 00:00:00 [kworker/u8:3-events_unbound]
root        1588       2  14:40 00:00:00 [kworker/2:1-mm_percpu_wq]
root        1598       2  14:42 00:00:00 [kworker/3:1-mm_percpu_wq]
root        1604       2  14:43 00:00:00 [kworker/0:0-events]
root        1611       2  14:45 00:00:00 [kworker/1:2]
root        1653       2  14:46 00:00:00 [kworker/u9:1-rb_allocator]
it4         1661     913  14:46 00:00:00 vim README.md
it4         1665     885  14:46 00:00:00 /bin/bash
it4         1666    1665  14:46 00:00:00 ps -ef
```

```bash
# cette commande permet de réprésenter sous la forme d'un arbre les processus
[it4@nowhere ~]$ pstree -p
```

## 2. Fin de vie des processus

➜ **Lorsqu'un *processus* se termine :**

- il retourne un code retour
- il est déchargé de la RAM

➜ **Le code retour**

- est égal à 0 si le *processus* s'est terminé correctement
- est différent de 0 (entre 1 et 127) si le *processus* ne s'est pas terminé correctement
  - chaque code a une signification différente suivant le programme
  - c'est les développeurs du programme qui décident ce que signifie leurs codes retour
  - avec l'exception du 0 qui est la convention pour dire que tout s'est bien passé
- depuis un shell, on peut consulter le code retour du dernier *processus* qui s'est terminé dans la variable `$?` :

```bash
[it4@nowhere ~]$ echo "toto"
toto
[it4@nowhere ~]$ echo $? # on vérifie le code retour de echo "toto"
0

[it4@nowhere ~]$ ls /srv
ftp  http  test  yt
[it4@nowhere ~]$ echo $? # on vérifie le code retour de la commande ls /srv
0

[it4@nowhere ~]$ jiejdoijeidjzoidjo
bash: jiejdoijeidjzoidjo: command not found
[it4@nowhere ~]$ echo $? # le code retour est différent de 0. Pour bash, "127" ça veut dire command not found
127

[it4@nowhere ~]$ ls /toto
ls: cannot access '/toto': No such file or directory
[it4@nowhere ~]$ echo $?
2
```

## 3. Environnement

➜ **Chaque *processus* est exécuté dans un environnement donné**

- mettons les termes : on l'appelle *environnement d'exécution* ou *runtime*
- ça désigne notamment :
  - le dossier depuis lequel est exécuté le programme
  - des variables d'environnement, disponibles pour le *processus* pendant son exécution
  - l'utilisateur qui a demandé l'exécution du *processus*, ce qui déterminera les droits du *processus*
  - etc.

# III. Gestion de processus

## 1. Les signaux

➜ **Pour interagir avec un *processus* en cours d'exécution, on peut lui envoyer des signaux.**

C'est un mécanisme commun à tous les OS, et vous l'avez tous déjà fait : quand tu cliques sur la croix rouge là, pour fermer ton ptit programme préféré. Bah tu lui envoies un signal.  
Tu lui dis "sitopl copain, arrête ton exécution".  
Ce qu'on appelle communément "fermer" un programme c'est, concrètement, envoyer un *signal* à un *processus* qui l'interprètera comme "ferme toi, l'utilisateur n'a plus besoin de toi mec".

> Il existe une liste de signaux prédéfinis disponibles dans chaque OS. [Vous trouverez ici un `man`](https://man7.org/linux/man-pages/man7/signal.7.html) qui contient un tableau des signaux disponibles au sein d'un système GNU/Linux.

➜ **La commande `kill` sert à envoyer un signal à un *processus*.**

- la commande s'utilise comme ça : `kill <OPTIONS> <PID>`
- la principale option utilisée consiste à préciser le numéro du signal qu'on veut envoyer ou son nom
- `kill -2 <PID>` pour envoyer un `SIGINT`

➜ **Voyons ceux auxquels vous serez le plus confronté**

- `SIGTERM` et `SIGINT`
  - permettent de demander à un *processus* de se terminer
  - utilisé notamment :
    - clic sur la croix rouge pour fermer un programme en cours d'exécution
    - `CTRL+C` pour couper un process dans un terminal
  - le *processus* choisit quoi faire à la réception de ce *signal*
    - le développeur peut demander à son programme de lancer une fonction particulière quand tel ou tel *signal* est reçu
    - on dit alors que le *processus* "***trap***" le *signal*
- `SIGSTOP`
  - demande au noyau de stopper l'exécution du processus
  - le *processus* n'a pas son mot à dire, c'est le noyau qui reçoit ce signal
- `SIGKILL`
  - le fameux `kill -9`
  - demande au noyau de décharger le programme de la RAM
  - le *processus* n'a pas sont mot à dire, et il est immédiatement déchargé de la RAM par le noyau
  - *pouf* il n'existe plus

> Attention à la manipulation du `SIGKILL` qui résulte en une fermeture "violente" du programme. Le programme pourrait laisser derrière lui des ports ouverts, des fichiers ouverts, ou encore des *processus* orphelins (qui seront alors adoptés par le PID 1).

![sigkill](./pics/sigkill.png)

## 2. Arrière plan

➜ **On peut lancer des *processus* en arrière-plan**

- on le fait généralement avec le caractère `&` positionné en fin de commande
  - par exemple `sleep 10 &`
- on peut utiliser la commande `jobs` pour voir les programmes en arrière-plan
- on peut alors utiliser les commandes
  - `fg` pour ramener un *processus* au premier-plan (comme `foreground` qui veut dire premier plan en anglais)
  - `kill` pour lui envoyer un signal

➜ **Mise en évidence**

- vous pouvez reproduire les commandes pour mieux comprendre :)

```bash
# on lance un process sleep en tâche de fond
[it4@nowhere ~]$ sleep 10000 &
[1] 1949

# visualiser le process en fond
[it4@nowhere ~]$ jobs
[1]+  Running                 sleep 10000 &

# visualiser le PID du process en fond
[it4@nowhere ~]$ jobs -p
1949

# on lance un deuxième process en fond
[it4@nowhere ~]$ sleep 99999 &
[2] 1950

# visualiser les deux process en fond
[it4@nowhere ~]$ jobs
[1]-  Running                 sleep 10000 &
[2]+  Running                 sleep 99999 &

# récupérer au premier plan le deuxième qui a été lancé
[it4@nowhere ~]$ fg 2
sleep 99999
^C # appui sur CTRL + C pour fermer le processus
[it4@nowhere ~]$ jobs -p
1949
[it4@nowhere ~]$ kill 1949
[1]-  Terminated              sleep 10000
```

## 3. Services

➜ **Un *service* concrètement, c'est juste un processus**

- vraiment, c'est tout
- lancer un service, c'est lancer un processus

➜ **La différence c'est que le *service* est lancé dans un environnement spécifique et prédictible**

- on va définir explicitement tout son *environnement d'exécution* (terme qui été défini plus haut dans ce document)
- on utilise la commande `systemctl` pour interagir avec les services au sein d'un système GNU/Linux
