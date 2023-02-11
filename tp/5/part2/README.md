# Partie 2 : Mise en place et maîtrise du serveur de base de données

Petite section de mise en place du serveur de base de données sur `db.tp5.linux`. On ira pas aussi loin qu'Apache pour lui, simplement l'installer, faire une configuration élémentaire avec une commande guidée (`mysql_secure_installation`), et l'analyser un peu.

🖥️ **VM db.tp5.linux**

**N'oubliez pas de dérouler la [📝**checklist**📝](#checklist).**

| Machines        | IP            | Service                 |
|-----------------|---------------|-------------------------|
| `web.tp5.linux` | `10.105.1.11` | Serveur Web             |
| `db.tp5.linux`  | `10.105.1.12` | Serveur Base de Données |

🌞 **Install de MariaDB sur `db.tp5.linux`**

- déroulez [la doc d'install de Rocky](https://docs.rockylinux.org/guides/database/database_mariadb-server/)
- je veux dans le rendu **toutes** les commandes réalisées
- faites en sorte que le service de base de données démarre quand la machine s'allume
  - pareil que pour le serveur web, c'est une commande `systemctl` fiez-vous au mémo

🌞 **Port utilisé par MariaDB**

- vous repérerez le port utilisé par MariaDB avec une commande `ss` exécutée sur `db.tp5.linux`
  - filtrez les infos importantes avec un `| grep`
- il sera nécessaire de l'ouvrir dans le firewall

> La doc vous fait exécuter la commande `mysql_secure_installation` c'est un bon réflexe pour renforcer la base qui a une configuration un peu *chillax* à l'install.

🌞 **Processus liés à MariaDB**

- repérez les processus lancés lorsque vous lancez le service MariaDB
- utilisz une commande `ps`
  - filtrez les infos importantes avec un `| grep`

➜ **Une fois la db en place, go sur [la partie 3.](../part3/README.md)**
