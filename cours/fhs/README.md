# FHS : File Hierarchy Standard

- [FHS : File Hierarchy Standard](#fhs--file-hierarchy-standard)
- [I. Intro](#i-intro)
- [II. Overview](#ii-overview)
- [III. Dive](#iii-dive)
  - [1. /bin et /sbin](#1-bin-et-sbin)
  - [2. /boot](#2-boot)
  - [3. /dev](#3-dev)
  - [4. /etc](#4-etc)
  - [5. /home et /root](#5-home-et-root)
  - [6. /lib et /lib64](#6-lib-et-lib64)
  - [7. /mnt et /media](#7-mnt-et-media)
  - [8. /opt et /srv](#8-opt-et-srv)
  - [9. /tmp](#9-tmp)
  - [10. /usr](#10-usr)
  - [11. /var et /run](#11-var-et-run)
  - [12. /proc et /sys](#12-proc-et-sys)

# I. Intro

*FHS* est le sigle pour *Filesystem Hierarchy Standard*. C'est un standard maintenu par la Linux Foundation.

**Il définit l'organisation et le rôle des dossiers et fichiers au sein d'un système d'exploitation.** Beaucoup de systèmes UNIX, comme les distributions GNU/Linux, les distributions BSD ou MacOS ont adopté ce standard et le respectent plus ou moins scrupuleusement.

Il définit en particulier les dossiers à la racine du système de fichiers :

Dans ces systèmes, le début de l'arborescence est le dossier `/` : c'est la racine ou *root directory*. 

> Les systèmes Windows, eux, ont plusieurs racines, une pour chaque périphérique : `C:`, `D:`, `E:`, etc.

# II. Overview

| Directory          | Role                                                                                                                                                                                 |
|--------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `/bin`  et `/sbin` | Exécutables, **bin**aires de la machine. Contient les commandes élémentaires du système comme `ls`, `cat`, `cp` etc                                                                  |
| `/boot`            | Fichiers nécessaires au **boot**. Notamment le noyau linux (fichier `vmlinuz-linux`) et un système de secours (rescue mode, fichier `initramfs-linux.img`)                           |
| `/dev`             | Périphériques ("**dev**ices") de la machine. Plus spécifiquement, on peut y trouver des fichiers qui représentent les différents périphériques de la machine, comme les disques durs |
| `/etc`             | Fichiers de configuration du système et des applications                                                                                                                             |
| `/home`            | Répertoires personnels des utilisateurs                                                                                                                                              |
| `/lib` et `/lib64` | Librairies (32 bits) du système                                                                                                                                                      |
| `/media`           | Contient les points de montage des périphériques amovibles                                                                                                                           |
| `/mnt`             | Points de montages des périphériques permanents                                                                                                                                      |
| `/opt`     | Répertoire contenant des applications. Libre à l'administrateur d'y stocker ce qu'il veut                                                                                                                 |                                           |
| `/root`    | Répertoire personnel de l'utilisateur `root`                                                                                                                                                              |
| `/run`     | Données volatiles des applications en cours de fonctionnement (liées au **run**time des applications  par ex : fichier de PID, de lock, etc)                                                                                                                              |
| `/srv`     | Libre à l'administrateur d'y stocker ce qu'il veut, généralement réservé à des données d'administration (répertoire de backups, dump de bases de données, etc.)                                           |
| `/sys` et `/proc`     | Pseudo-répertoire qui représente l'état en temps réel de lu noyau/de l'OS                                                                                                                                 |
| `/tmp`     | Dossier temporaire qui est vidée à chaque reboot. Beaucoup d'applications ont besoin de la présence d'un tel dossier. Attention, ses permissions sont extrêmement ouvertes (`777`)                        |
| `/usr`     | Contient des dossiers similaires à ceux de la racine (`/usr/bin` par exemple) mais spécifique aux utilisateurs de la machines. `/usr/bin` contient les applications/binaires des utilisateurs par exemple |
| `/var`     | Donneés persistantes des applications. Par exemple, une base de données stocke ses données là-bas.                                                                                          |

# III. Dive

## 1. /bin et /sbin

> Afin de faciliter la lecture de ce doc, on rappelle que les termes suivants sont des synonymes : "application", "logiciel", "soft", "software", "programme", "binaire".

Ces dossiers contiennent les binaires de la machine.

Toutes ces commandes, on peut les appeler depuis le terminal, et certaines sont faites pour être exécutées sur une interface graphique.

## 2. /boot

Le dossier `/boot` contient deux principaux fichiers, qui sont des binaires :

- [le noyau linux](../intro/README.md#i-notion-de-noyau-et-dos) `vmlinux*`
  - la première application lancée lorsque la machine démarre
- le mode rescue `initramfs`
  - si le chargement du noyau chie dans la colle, on démarre en mode maintenance ou mode *rescue*
  - c'est le rôle du `initramfs`

## 3. /dev

Ici on va trouver tous les périphériques de la machines :

- disques durs
  - `/dev/sda` c'est le premier disque dur
  - `/dev/sdb` le deuxième, ainsi de suite
- mémoire vive (RAM)
  - `/dev/mem`
- clavier, souris, écran, etc.

On parle ici d'accéder à ces périphériques comme si c'était des fichiers. C'est à dire qu'on peut écrire des données brutes dans la mémoire vive ou sur le disque dur grâce à ces fichiers.

Il existe d'autres fichiers comme [`/dev/zero`](https://fr.wikipedia.org/wiki//dev/zero), [`/dev/random`](https://en.wikipedia.org/wiki//dev/random) et [`/dev/null`](https://fr.wikipedia.org/wiki/P%C3%A9riph%C3%A9rique_nul) que nous avons mentionné en cours.

## 4. /etc

**Ce répertoire contient toute la configuration du système.**

Il y a un fichier (si un suffit) ou un dossier par application du système. Ce dossier ne contient que des fichiers texte, modifiables à l'aide d'un simple éditeur de texte.

Les admins passent leur vie dans ce répertoire :3

## 5. /home et /root

**On trouve là les répertoire personnels des utilisateurs.** C'est là où, en tant que moldu, on passe notre vie.

Il existera dans `/home` un sous-répertoire pour chaque utilisateur du système.  
Par exemple un `/home/toto`.

> C'est l'équivalent de `/Users` dans MacOS ou `C:/Users` dans Windows.

On y trouve les traditionnels dossiers `Documents/`, `Musique/`, `Images/`, `Téléchargements`, etc.

---

**`/root` est simplement le répertoire personnel de l'utilisateur `root`** qui ne se trouve donc PAS dans `/home/root`.

## 6. /lib et /lib64

Ces répertoires contiennent les librairies du système.

Une librairie, c'est un bout de code réutilisable. Ce bout de code contient des fonctions, qu'il est possible d'appeler depuis un autre bout de code.

Par exemple, en Go, on utilise le mot-clé `import` pour importer les fonctions contenues dans une librairie donnée :

```go
package main

import "fmt"

func main() {
  fmt.Println("Hellooooooooooooooo)
}
```

Cela permet de ne pas recoder des fonctions utiles à toutes sortes de programmes différents. On va pas se faire chier à recoder la fonction `Println()` à chaque programme en Go si ? Meow.

## 7. /mnt et /media

Ici on trouvera les points de montage.

Quand on branche un nouveau périphérique de stockage (clé USB par exemple) à une machine, un dossier sera créé dans `/mnt` ou `/media`.

Le contenu du périphérique sera alors accessible dans ce sous-dossier.

> Et ui, pas de `D:/` comme dans Windows : la racine est unique ! Donc les périphériques sont accessibles directement dans un sous-dossier de cette racine unique. En l'occurence, un sous-dossier de `/mnt` ou `/media`.

## 8. /opt et /srv

Ces deux-là contiennent des trucs ajoutés à la machine par l'admin.

Par exemple, le dossier d'une application qui n'a pas été installée via des paquets, on s'attend à le trouver dans `/opt`.

## 9. /tmp

Ce dossier est le dossier temporaire dans les systèmes GNU/Linux.

Par temporaire, on entend que son contenu est purgé à chaque redémarrage de la machine.

C'est un dossier un peu particulier : tout le monde a les droits de lecture et d'écriture. C'est un dossier nécessaire au bon fonctionnement de beaucoup d'applications.

## 10. /usr

Historiquement, ce dossier contient tout ce qui est ajouté au système par l'utilisateur.

Aujourd'hui ce n'est plus tout à fait vrai dans les système GNU/Linux, mais on trouve effectivement les applications installées par l'utilisateur dans `/usr/bin` par exemple.

## 11. /var et /run

Les dossiers `/var` et `/run` contiennent les données des applications. Il existe évidemment une différence entre les deux :

- `/var` contient les données persistantes des applications
  - c'est à dire les données qui sont connservées lorsqu'on éteint puis redémarre l'application
- `/run` contient les données volatiles des applications
  - des données qui sont créées et utilisées pendant le fonctionnement de l'application
  - mais qui n'existent plus une fois l'application éteinte
  - `/run` c'est pour *runtime* ou *environnement d'exécution* en français

Les cas typiques (non exhaustif) :

- `/var/`
  - `/var/log` contient les logs du système et des applications. Un sous-dossier ou un fichier par application
  - `/var/lib/mysql` contient les données d'une éventuelle base de données installée (MySQL/MariaDB)
- `/run/`
  - on trouve des *PID file* (un fichier qui porte l'extension `.pid`)
    - c'est un simple fichier texte, qui contient un entier
    - lorsqu'un programme se lance, il écrit son fichier dans un *PID file*
    - ceci permet de facilement retrouve l'ID du processus de notre programme
  - on trouve des *lock file* (extension `.lock`)
    - c'est souvent un fichier vide
    - la seule chose qui compte c'est qu'il existe ou non
    - parfois un programme en fonctionnement effectue une tâche, mais il doit être le seul à effectuer cette tâche
    - il va alors créer un fichier de lock à un endroit spécifique
    - si d'autres veulent effectuer cette tâche, ils vont d'abord vérifier que le fichier de lock n'existe pas. S'il existe déjà, alors ils attendent
    - le fichier de lock est supprimé une fois l'opération effectuée

## 12. /proc et /sys

Ces dossiers très particuliers n'existent pas sur le disque dur.

On dit souvent dans les systèmes GNU/Linux que "tout est fichier" *("everything is a file")*. Cela veut dire que tout dans Linux, se fait en manipulant des fichiers.

`/proc` et `/sys` sont la représentation de l'état de votre matériel et du noyau en temps réel, sous forme de fichiers.

Nous n'allons pas nous étendre DU TOUT là dessus dans la première année. :)