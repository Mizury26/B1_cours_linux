# TP5 : Self-hosted cloud

Dans ce TP on va exploiter le savoir accumulé jusqu'alors pour **mettre en place une vraie solution : NextCloud.**

NextCloud est une solution **libre et opensource.** Il fournit une interface web qui **propose des fonctionnalités** comme l'hébergement de fichiers, de la visioconférence, des agendas partagés etc. Le tout sur une interface sexy.

On voit l'application NextCloud **dans le monde réel utilisée** par des particuliers comme des entreprises pour accéder à ces fonctionnalités.

**On s'approche donc un peu plus d'un cas réel pour ce TP**, avec à la clé une jolie interface qui propose de vrais services :)

![There is no cloud](./pics/there_is_no_cloud.jpg)

## Sommaire

- [TP5 : Self-hosted cloud](#tp5--self-hosted-cloud)
  - [Sommaire](#sommaire)
  - [Checklist](#checklist)
- [I. Présentation des composants de NextCloud](#i-présentation-des-composants-de-nextcloud)
  - [1. Présentation du setup](#1-présentation-du-setup)
  - [2. Présentation des étapes](#2-présentation-des-étapes)
- [II. Let's go](#ii-lets-go)

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

# I. Présentation des composants de NextCloud

## 1. Présentation du setup

NextCloud est une application web codée en PHP, qui nécessite une base de données SQL pour fonctionner.

Nous allons procéder au setup suivant :

➜ 🖥️ **une VM `web.linux.tp5`**

- on y installera un serveur Web : **Apache**
  - le serveur web traite les requêtes HTTP reçues des clients
  - il fait passer le contenu des requêtes à NextCloud
  - NextCloud décide quels fichiers HTML, CSS, et JS il faut donner au client
  - le serveur Web effectue une réponse HTTP qui contient ces fichiers HTML, CSS, et JS
- il faudra aussi installer PHP
  - pour que NextCloud puisse s'exécuter
  - compliqué d'exécuter du PHP si on a pas installé le langage :)

![Apache](./pics/apache.png)

➜ 🖥️ **une VM `db.linux.tp5`**

- on y installera un service de base de données SQL : **MariaDB**
- NextCloud pourra s'y connecter
  - on aura créé une base de données exprès pour lui

![MariaDB](./pics/mariadb.png)

➜ **puis mise en place de NextCloud**

- sur la machine `web.linux.tp5`
- c'est donc une application PHP

![NextCloud](./pics/nextcloud.png)

## 2. Présentation des étapes

Dans l'ordre on va :

➜ **installer le serveur web** sur `web.linux.tp5`

- installer le service
- lancer le service
- explorer le service, prendre la maîtrise dessus, regarder sur quel port il tourne, où est sa conf, ses logs, etc.

➜ **installer le service de base de données** sur `db.linux.tp5`

- installer le service
- lancer le service
- EXPLORER LE SERVICE, encore :)

➜ **préparer le service de base de données pour NextCloud**

- se connecter au service en local
- créer un utilisateur et une base de données dédiés à NextCloud

➜ **installer PHP** sur `web.linux.tp5`

- un peu chiant, il nous faut une version spécifique, je vous ai préparé les instructions :)

➜ **installer NextCloud** sur `web.linux.tp5`

- petite commande pour récupérer une archive sur internet qui contient le code
- on l'extrait au bon endroit, on gère les permissions
- et ça roule

➜ **on retourne configurer le serveur Web** sur `web.linux.tp5`

- on indiquera qu'on a mis en place un site Web (NextCloud) dans un dossier spécifique
- on redémarre et BAM c'est tout bon

➜ **accéder à l'interface de NextCloud** depuis votre navigateur

# II. Let's go

Pour + de lisibilité, j'ai encore découpé le TP en 3 parties :

- [**Partie 1** : Mise en place et maîtrise du serveur Web](./part1/README.md)
- [**Partie 2** : Mise en place et maîtrise du serveur de base de données](./part2/README.md)
- [**Partie 3** : Configuration et mise en place de NextCloud](./part3/README.md)
- [**Partie 4** : Automatiser la résolution du TP](./part4/README.md) (partie bonus, facultatif)
