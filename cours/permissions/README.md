# Gestion de permissions

![777](./pics/777.jpg)

## Sommaire

- [Gestion de permissions](#gestion-de-permissions)
  - [Sommaire](#sommaire)
  - [Principes généraux](#principes-généraux)
  - [Permissions POSIX](#permissions-posix)
  - [Un exeeeeeeeeemple](#un-exeeeeeeeeemple)
  - [La notation octale](#la-notation-octale)

## Principes généraux

**Quelques règles...**

- tous les fichiers appartiennent à un utilisateur donné
- tous les fichiers appartiennent aussi à un groupe donné
- tous les fichiers possèdent un jeu de permissions POSIX

## Permissions POSIX

**Les *permissions POSIX* correspondent aux *droits* ou *permissions* positionnés sur chacun des fichiers dans un système GNU/Linux.**

Chaque fichier possède 3 types de permission : `r` pour le droit de lecture *(read)*, `w` pour le droit d'écriture *(write)*, `x` pour le droit d'exécution *(execute)*.  

➜ **Avoir le droit *read*** sur un fichier permet de le lire, l'ouvrir, le consulter (ouvrir un fichier texte ou afficher une image JPEG par exemple).

➜ **Avoir le droit *write*** sur un fichier permet d'écrire dans le fichier c'est à dire de le modifier, de l'altérer, d'en faire ce qu'on veut en somme. 

> Ca paraît évident de pouvoir modifier un document Word, mais ça paraît tout aussi censé qu'on protège les fichiers qui contiennent nos mots de passe non ?

➜ **Avoir le droit *execute*** sur un fichier donne le droit à l'utilisateur d'exécuter le fichier. On met ce droit sur les exécutables, afin de pouvoir exécuter le programme.

> Par exemple ce droit est positionné sur la commande `firefox` qui permet de lancer `firefox.exe`.

---

**Chaque fichier possède 3 jeux de permission (3 fois `rwx` donc)** chacun étant relatifs à des utilisateurs différents :

- le **premier** jeu correspond aux **droits de l'utilisateur** propriétaire du fichier
- le **deuxième** jeu correspond aux **droits du groupe** propriétaire du fichier
- le **troisième** jeu correspond aux droits qu'on **tous les autres** utilisateurs sur le fichier

## Un exeeeeeeeeemple

**Un exemple, c vachmen + mieu :D**

```bash
$ ls -al
-rw-r--r-- 1 it4 admins 35567 Sep 22 23:00 file1 
```

➜ Sur l'exemple ci-dessus, le fichier `file1` :

- appartient à l'utilisateur `it4`
- appartient au groupe `admins`
- possède les permissions `rw-r--r--`

➜ Autrement dit, toujours sur l'exemple :

- l'utilisateur `it4` peut lire et modifier le fichier : `rw-`
  - il ne peut pas exécuter le fichier
- tous les membres du groupe `admins` peuvent seulement lire le fichier (*read*) : `r--`
  - ils ne peuvent ni modifier le fichier ni exécuter le fichier
- tous les autres utilisateurs ne peuvent que lire le fichier (*read*) : `r--`

## La notation octale

Afin de faciliter la manipulation des permissions, il est possible de les exprimer sous forme octale. Pour faire simple, on attribue un poids à chaque permission :

- `r` vaut 4
- `w` vaut 2
- `x` vaut 1

Quelques exemples :

- `rw-` peut s'écrire 6 (r + w, c'est 4 + 2)
- `rwx` peut s'écrire 7 (r + w + x, c'est 4 + 2 + 1)
- `--x` peut s'écrire 1 (x c'est 1)

Si on fait référence à l'ensemble des permissions d'un fichier on peut donc écrire :

- `rwxrw-r--` : 764
- `rwxr-xr-x` : 755
- `rw-r-----` : 640

**Ainsi, dans l'exemple présenté plus haut, les permissions du fichier `file1` sont 644.**
