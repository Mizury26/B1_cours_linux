# TP6 : Travail autour de la solution NextCloud

Dans ce dernier TP, on va construire autour de la solution de la NextCloud pour améliorer son niveau de qualité ou de sécurité.

On se met dans la peau d'un admin jusqu'au bout, en proposant des fonctionnalités additionnelles permettant de s'assurer du bon fonctionnement de la solution dans le temps, de façon pérenne.

Ce qu'on fait avec NextCloud là est réplicable avec n'importe quelle autre application dans un autre environnement.

Concrètement, dans ce TP, on va :

- mettre en place un reverse proxy NGINX
  - il va protéger notre serveur web
- développer un script de sauvegarde
  - il sauvegardera à intervalles réguliers les fichiers liés à NextCloud
- installer fail2ban
  - pour se protéger des attaques de bruteforce
- mettre en place un monitoring simple
  - avec un autre outil libre : Netdata
  - il nous permettra de surveiller via une interface sexy l'état de notre serveur
  - et de nous envoyer des alertes (sur Discord) en cas de soucis

# 0. Setup

## Sommaire

- [TP6 : Travail autour de la solution NextCloud](#tp6--travail-autour-de-la-solution-nextcloud)
- [0. Setup](#0-setup)
  - [Sommaire](#sommaire)
  - [Checklist](#checklist)
  - [Le lab](#le-lab)
- [I. Here we go](#i-here-we-go)

## Checklist

![Checklist](./pics/checklist_is_here.jpg)

- [x] IP locale, statique ou dynamique
- [x] hostname défini
- [x] firewall actif, qui ne laisse passer que le strict nécessaire
- [x] SSH fonctionnel
- [x] accès Internet (une route par défaut, une carte NAT c'est très bien)
- [x] résolution de nom
- [x] SELinux activé en mode *"permissive"* (vérifiez avec `sestatus`, voir [mémo install VM tout en bas](https://gitlab.com/it4lik/b1-reseau-2022/-/blob/main/cours/memo/install_vm.md#4-pr%C3%A9parer-la-vm-au-clonage))
- [x] mettez à jour votre OS et tous les paquets (`dnf update -y`)

**Les éléments de la 📝checklist📝 sont STRICTEMENT OBLIGATOIRES à réaliser mais ne doivent PAS figurer dans le rendu.**

## Le lab

Vous pouvez réutiliser les VMs du TP précédent.

Dans la suite du TP, la machine qui porte NextCloud est appelée `web.tp6.linux` et celle qui porte la base de données `db.tp6.linux`.

Il est nécessaire en tout cas de partir avec NextCloud en place sur deux machines (web + db).

# I. Here we go

Pour plus de clarté, chaque partie est dans une page dédiée.

Chaque module est indépendant, et ils peuvent être faits dans le désordre.

- [Module 1 : Reverse Proxy](./1-reverse-proxy/README.md)
- [Module 2 : Sauvegarde du système de fichiers](./2-backup/README.md)
- [Module 3 : Fail2Ban](3-fail2ban/README.md)
- [Module 4 : Monitoring](4-monitoring/README.md)
