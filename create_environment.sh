#! /bin/bash
## Welcome message
## Prerequisities
##########
## pyenv Installation
#########
# dependencies for Fedora/CentOS/RHEL
# sudo dnf install git gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel libffi-devel patch
#######
# install with :  curl https://pyenv.run | bash
# and copy on your bashrc the following lines :
#
echo "Bonjour, bienvenue dans l'outils de création d'environement odoo V17 automatique (by Coco@invitu)"

## We create the path of workspace if not exsist
workspacemain="$HOME/invitu-devel"
if [ -d $workspacemain ]
then
    echo 'Votre workspace racine existe déja !'
else
    echo 'Création du workspace racine'
    mkdir $workspacemain
fi

#Workspace project
workspaceproject="$workspacemain/projects"
if [ -d $workspaceproject ]
then
    echo 'Votre workspace project existe déja !'
else
    echo 'Création du workspace project'
    mkdir $workspaceproject
fi
#Workspace allrepos
workspacerepos="$workspacemain/allrepos/"

if [ -d $workspacerepos ]
then
    echo 'Votre workspace allrepos existe déja !'
else
    echo 'Création du workspace allrepos'
    mkdir $workspacerepos
fi

#We define python environement match for Odoo 17
pyenv_version="3.10"
pyenvsystem=$(pyenv versions | grep -m 1 3.10)

## We check or install python environement for odoo version 17

echo 'Nous vérifions si py env est installé.'

if [ -z "$pyenvsystem"  ]
then
    echo 'Nous installons votre pyenv pour Odoo 17.'
    pyenv install $pyenv_version
else
    echo 'Pyenv pour Odoo 17 est déja installé, rien à faire.'
fi

## We git odoo branch with version
workspaceodoo="$workspacerepos/gitodoo"
if [ -d $workspaceodoo ]
then
    echo 'Odoo est présent rien à faire'
else
    echo 'Odoo pas présent, nous effectuons un gitclone de la branche main 17'
    mkdir -p $workspaceodoo && cd $workspaceodoo
    git clone https://www.github.com/odoo/odoo --depth 1 --branch 17.0 --single-branch
fi
