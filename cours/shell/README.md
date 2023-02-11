# Le Shell

## Sommaire

- [Le Shell](#le-shell)
  - [Sommaire](#sommaire)
  - [1. Code retour](#1-code-retour)
  - [2. Flux](#2-flux)
    - [A. Entrée standard](#a-entrée-standard)
    - [B. Sorties](#b-sorties)

## 1. Code retour

Chaque commande exécutée retourne un code retour.

S'il est égal à 0, tout s'est bien passé, la commande s'est correctement exécutée, avec succès.

S'il est différent de 0, alors la commande a échoué d'une façon ou d'une autre. La commande retourne souvent un code précis qui a une signification, signification qu'on peut obtenir en regardant le manuel de la commande.

Le code retour de la dernière commande exécutée est disponible dans la variable `$?`.

Exemple :

```bash
$ ls
fichier.txt
$ echo $?
0

$ goiurhjgiourj
bash: goiurhjgiourj: command not found
$ echo $?
127
```

> Pour `bash`, le code `127` ça veut dire `command not found`.

## 2. Flux

### A. Entrée standard

Les commandes prennent parfois des données en entrée, dans leur flux d'entrée qu'on appelle *entrée standard* ou ***STDIN***.

Pour envoyer des donnée dans l'entrée standard d'une commande, on utilise généralement le caractère `|`.

Exemple :

- on `cat` le fichier `/etc/passwd`
- on filtre sa sortie en ajoutant `| grep root`
- **on dit alors que le texte qui résultat de la commande `cat` a été envoyé dans l'entrée standard de `grep`**

```bash
$ cat /etc/passwd | grep root
root:x:0:0:root:/root:/bin/bash
```

### B. Sorties

Une commande donnée dispose de deux sorties : la *sortie standard* ou ***STDOUT***  et la *sortie d'erreur* ou ***STDERR***.

Si une commande doit écrire quelque chose dans le terminal quand tout se passe bien, qu'elle ne rencontre pas d'erreur, elle utilise ***STDOUT***.

Si une commande doit écrire un message d'erreur dans le terminal elle utilise ***STDERR***.

Il est possible de rediriger ces sorties vers des fichiers à l'aide du caractère `>`.

- `>` sert à rediriger *STDOUT* dans un fichier, en écrasant le contenu du fichier
- `>>` sert à rediriger *STDOUT* dans un fichier, en ajoutant au contenu existant du fichier
- `2>` sert à rediriger *STDERR* dans un fichier, en écrasant le contenu du fichier
- `2>>` sert à rediriger *STDERRT* dans un fichier, en ajoutant au contenu existant du fichier

Exemple :

```bash
$ echo toto
toto
$ echo toto > super_fichier # on redirige le texte sorti en STDOUT "toto" dans un fichier
$ cat super_fichier # on affiche le contenu du fichier créé
toto

$ echo titi > super_fichier # efface le contenu fichier
$ cat super_fichier
titi
$ echo tata >> super_fichier # on ajoute du text au contenu existant
$ cat super_fichier
titi
tata

$ goiurhjgiourj # affiche une erreur
bash: goiurhjgiourj: command not found
$ goiurhjgiourj > super_fichier # ne redirige rien car le message sort en STDERR
bash: goiurhjgiourj: command not found
$ goiurhjgiourj 2> super_fichier # on redirige l'erreur dans un fichier texte
$ cat super_fichier # dans le fichier se trouve notre message d'erreur
bash: goiurhjgiourj: command not found
```
