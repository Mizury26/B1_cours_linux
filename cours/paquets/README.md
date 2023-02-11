# Paquets et gestionnaire de paquets

On va aborder ici plusieurs notions autour des **paquets** et des **gestionnaires de paquets**.

- [Paquets et gestionnaire de paquets](#paquets-et-gestionnaire-de-paquets)
  - [Paquet](#paquet)
  - [Gestionnaire de paquets](#gestionnaire-de-paquets)
  - [Dépôt](#dépôt)
  - [La place des paquets dans le monde Linux](#la-place-des-paquets-dans-le-monde-linux)
  - [Différents gestionnaires de paquets](#différents-gestionnaires-de-paquets)

## Paquet

➜ **Un paquet est une simple archive compressée** (un `.zip` ou `.tar.gz` par exemple).

Télécharger un paquet c'est donc juste télécharger un fichier compressé.

➜ **Quand on parle "d'installer" le paquet, on parle juste d'extraire le contenu de l'archive.**

Un paquet peut contenir une multitude de fichiers, qui seront copiés au moment de l'extration à des endroits spécifiques du système.

➜ Ainsi, un paquet permet à un éditeur donné de s'assurer que :

- les fichiers qu'il met à disposition sont téléchargés en un seul coup
- chaque fichier sera copié au bon endroit sur le système qui accueille le paquet
- chaque fichier sera géré (propriétaire, permissions)

## Gestionnaire de paquets

➜ **Un *gestionnaire de paquets* est un outil qui permet de télécharger des paquets.**

Généralement, ça s'utilise en ligne de commandes, comme par exemple `apt` ou `dnf`. Il existe aussi des interfaces graphiques, comme la bibliothèque logicielle qu'on trouve sur Ubuntu par exemple.

➜ **L'utilisation d'un tel outil permet de nombreux bénéfices, par rapport au téléchargement manuel** de paquets ou d'applications.

En effet, un *gestionnaire de paquets* :

- vérifie l'**intégrité** de chaque paquet téléchargé
  - il s'assure que le paquet n'a pas été altéré
  - le paquet téléchargé doit être identique au paquet stocké du côté de l'éditeur
- vérifie la **provenance** de chaque paquet téléchargé
  - grâce à l'utilisation de dépôt (voir partie suivante)
- gestion de **dépendances**
  - si on ordonne le téléchargement d'un paquet, c'est possible qu'on en récupère plusieurs
  - certains paquets dépendent d'autres paquets pour fonctionner
  - utiliser un *gestionnaire de paquets* permet de tout télécharger sans se faire chier :)
- peut **chiffrer** les téléchargements
  - pour rendre les échanges confidentiels

## Dépôt

➜ **Un dépôt de paquets (ou *package repository*)** est un serveur qui est accessible sur le réseau et qui a pour rôle de :

- stocker des paquets
- permet à des clients de télécharger les paquets stockés

Ainsi, il est récurrent qu'une machine donnée connaisse l'adresse de certains dépôts et les utilise par défaut lors du téléchargements de paquets.

> Généralement, les dépôts permettent le téléchargement de paquet *via* le protocole HTTP (ou HTTPS). C'est analoguqe à un simple téléchargemenbt Web donc. La différence c'est qu'on utilise un gesitonnaire de paquet pour lancer le téléchargement, plutôt qu'une connexion manuelle avec un navigateur web.

## La place des paquets dans le monde Linux

➜ **Au sein d'un OS GNU/Linux, le *gestionnaire de paquets* a une place primordiale.**

En effet, a été fait le choix que tout, absoluement TOUT le système soit livré sous forme modulaire, sous la forme de paquets.

Ainsi, le noyau est livré dans un paquet spécifique, de même pour toutes les autres applications qui, ensemble, constituent l'OS.

➜ Du fait que **les paquets et gestionnaires de paquets occupent cette place centrale dans les OS GNU/Linux, il est alors simple de modifier ou customiser le système** : il suffit d'ajouter, modifier, ou supprimer des paquets.

> De la même façon, les commandes qui listent tous les paquets installés sont en fait une liste exhaustive à 100% de tout votre système. Aussi bien le noyau, que l'OS, que les applications qu'on a rajouté par dessus.

➜ **Une machine GNU/Linux fraîchement installée connaît déjà l'adresse de certains dépôts**

- si un Debian est installé, alors les adresses des dépôts de Debian sont fournies à la machine
- une confiance égale doit être donnée dans tous les paquets, autant qu'en l'OS lui-même
- au sein d'un OS GNU/Linux, les mises à jour du système comme des simples applications sont des mises à jour de paquet

> Il est donc simple de mettre à jour complètement tout l'OS et toutes les applications installées en une seule commande (`dnf upgrade` sur une machine RedHat).

## Différents gestionnaires de paquets

➜ **Suivant votre OS, le *gestionnaire de paquets* utilisé ne sera pas le même.**

En voilà une petite liste, en fonction des OS les plus utilisés :

- GNU/Linux base RedHat (RHEL, Rocky, Fedora, CentOS, etc.) : `dnf`
- GNU/Linux base Debian (Debian, Ubuntu, Mint, Kali, etc.) : `apt` et `apt-get`
- GNU/Linux base Arch (Arch, BlackArch, Manjaro, etc.) : `pacman`
- Windows : Chocolatey
- MacOS : Ports et Brew

De même, un paquet possède un format spécifique et doit répondre à des bonnes pratiques. Ce format et ces bonns pratiques sont spéficiques au gestionnaire de paquet qui est utilisé.

> Sur Windows et MacOS, ils ne sont pas installés nativement. Cependant, ils sont généralement utilisés par tout utilisateur de ces plateformes avec un profil de technicien.

➜ **Il existe aussi des gestionnaires de paquets + spécifiques**

Par exemple, la plupart des langages modernes on un *gestionnaire de paquets* plus ou moins officiel.  
Dans ce cadre, le *gestionnaire de paquets* va permettre le téléchargement de librairies pour le langage en question.

En voici quelques exemples :

- Python : `pip`
- PHP : `composer`
- Node : `npm`
- Go : `go`
- .NET : `nuget`
