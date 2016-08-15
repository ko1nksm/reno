# Renovating your home with reno.

Reno is the home directory management tool.

## Feature

* Provide framework to customize home directory.
* Simple and intuitive directory structure.
* Manage files (dotfiles) easily.
* Supports the generation of the file using templates.
* Supports scripts for install the applications.
* Pure bash. Works on many environments.


## Supports

* Linux
* MacOSX
* Cygwin
* Msys

### Requirements

* Bash 3.x (maybe 2.05b)
* Standard commands (coreutils, findutils)

## Installing

**via curl**

```
bash -c "$(curl -L https://github.com/ko1nksm/reno/raw/master/install.sh)"
```

or

**via wget**

```
bash -c "$(wget -O - https://github.com/ko1nksm/reno/raw/master/install.sh)"
```

or

**manual**

```
git clone https://github.com/ko1nksm/reno.git ~/.reno
ln -s ~/.reno/bin/reno ~/bin/reno
```

* Reno installed under ~/.reno
* Create a symbolic link ~/bin/reno that refers to ~/.reno/bin/reno.


## Quick start

~~~
$ reno init
reno: /home/me/.infill directory created.
reno: /home/me/.infill/README.md generated.
reno: /home/me/.infill/.gitignore generated.

$ mkdir ~/.infill/bash
$ touch ~/.infill/bash/.bashrc
$ echo bash > ~/.infill/default
$ tree ~/.infill -a
/root/.infill
|-- .INFILL_DIR
|-- .gitignore
|-- README.md
|-- bash
|   `-- .bashrc
`-- default

1 directory, 5 files

$ reno info
[Environments]
INFILL_DEFAULT: default
INFILL_DIR    : /home/me/.infill

[Global files]
.renorc     (HOME)      : none
.renorc     (INFILL_DIR): none
.renoignore (INFILL_DIR): none

[Available features]
  name                 Renofile .renoignore .renoattributes Files
- -------------------- -------- ----------- --------------- -----
  bash                 -        -           -                   1

[*] installed

[Group files]
name                 Contained features
-------------------- ------------------------------------------
default              bash

$ reno install
reno: default group
reno:  install bash

$ reno list -f
* /home/me/.bashrc -> /home/me/.infill/bash/.bashrc [soft,0644]
~~~

Try to run ```reno --help``` for help.

## Reno basics

* **reno** Command for management.
* **infill** Directory for customization data that you need to create.
* **feature** Installable feature in the infill.
* **group** Group file of the features.

Recommend you to manage the infill directory by version control system like git.

## Reno control files

### Renofile

For installation of the application, write script.

~/.infill/rbenv/Renofile

```
[env]
# Run when reno install / uninstall / list (for file check)

[install]
# Run when reno install
if [[ ! -e ~/.rbenv ]]; then
  git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
fi

[install:before]
# Before installing files (same as install)
[install:after]
# After installing files

[update]
git -C ~/.rbenv pull

[uninstall]
# Run when reno uninstall
rm -rf ~/.rbenv

[uninstall:before]
# Before uninstalling files
[uninstall:after]
# After uninstalling files (same as uninstall)
```

### .renorc

To change environment variables.

~/.infill/.renorc

~~~
# Run at startup
if [[ $(uname) = CYGWIN* ]]; then
  INFILL_DEFAULT=cygwin
fi
~~~

### .renoignore

To ignore file installation. Syntax similar to .gitignore.

~/.infill/.renorc

~~~
# ignore pattern
id_rsa
.DS_Store
Thumbs.db
~~~

**Symlink to directory**

Name ending with a slash, it means the following.

* It means the directory.
* Create symlink to the directory.
* Ignore files under the directory.


### .renoattributes

To change the installation mode and/or permissions.

~/.infill/feature/.renorc

~~~
# pattern            mode,mask
/.secret-file        soft,600
~~~

**pattern**

glob matching

**mode**

installation mode

|           | soft (default) | hard            | copy           | tmpl            |
| --------- | -------------- | --------------- | -------------- | --------------- |
| file      | create symlink | create hardlink | copy file      | apply templates |
| directory | create symlink | create symlink  | copy directory | not support     |

**mask**

Mask permission.


## Using templates

Templates engine Mo (Mustache) bundled.

* [{{ mustache }}](https://mustache.github.io/)
* [Mo - Mustache Templates in Bash](https://github.com/tests-always-included/mo)

### how to use

~/.infill/git/.gitconfig

~~~
[user]
  name = {{NAME}}
  email = {{EMAIL}}
~~~

~/.infill/git/Renofile

~~~
[env]
NAME="Your Name"
case $(hostname -f) in
  *.example.corp) EMAIL="name@example.corp" ;;
  *.example.home) EMAIL="name@example.home" ;;
esac
~~~

~/.infill/git/.renoattributes

~~~
.gitconfig        tmpl
~~~

## Deployment to another computer

``reno generate setup`` generates setup.sh.

Run setup.sh, then installs reno and infill from online.

Example

```
bash -c "$(curl -L https://example.com/path/to/your/setup.sh)"
```

setup.sh must be modified for your environment. Do NOT forget to edit.

## License

MIT license
