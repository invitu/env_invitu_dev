#! /bin/bash

## read config file
name_project=$(jq -r .project_name config_file.json )
branch_odoo=$(jq -r .branch_odoo config_file.json )

#########
## env python
# https://realpython.com/intro-to-pyenv/ 
#########
# dependencies for Fedora/CentOS/RHEL
# sudo yum install gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite \
# sqlite-devel openssl-devel xz xz-devel libffi-devel patch
#######
# install with :  curl https://pyenv.run | bash
# and copy on your bashrc the following lines :
#
#######
# combinaison de versions
# ODOO 08 : python 2.7.9
# ODOO 09 : python 2.7.9 
# https://www.odoo.com/documentation/10.0/setup/install.html
# ODOO 10 : python 2.7.9
# ODOO 11 : python 3.5
# ODOO 12 : python 3.5
# ODOO 13 : python 3.6
# ODOO 14 : python 3.8
# ODOO 15 : python 3.8
# ODOO 16 : python 3.10
# ODOO 17 : python 3.10
#########
# pour installer une version de python avec pyenv
# /ex : pyenv install 3.5 
# pour voir toutes les versions installer :
# pyenv versions

# Arborescence général 
# ici, le nom du projet est toto14
# laurent@fedora:~$ tree -L 2 invitu-devel/
# invitu-devel/
# ├── allrepos
# │   ├── gitinvitu
# │   ├── gitoca
# │   └── gitodoo
# └── projects
#    └── toto14


echo "val de la branch odoo $branch_odoo "

Workspace="$HOME/invitu-devel/projects/$name_project"

echo "Nom du projet : " $name_project

mkdir -p $Workspace


case $branch_odoo in

    "8.0")
        echo "on va utiliser la version 8.0 de ODOO avec python 2.7.9"
        ## on créé un dossier venv 2.7.9
        cd $Workspace/../
        pyenv virtualenv 2.7.9 $name_project
        echo "Tu peux activer l'env de dev en faisant :"
        echo "pyenv activate $name_project "
    ;;

    "9.0")
        echo "on va utiliser la version 9.0 de ODOO avec python 2.7.9"
        ## on créé un dossier venv 2.7.9
        cd $Workspace/../
        pyenv virtualenv 2.7.9 $name_project
        echo "Tu peux activer l'env de dev en faisant :"
        echo "pyenv activate $name_project "
    ;;

    "10.0")
        echo "on va utiliser la version 10 de ODOO avec python 2.7.9"
        ## on créé un dossier venv 2.7.9
        cd $Workspace/../
        pyenv virtualenv 2.7.9 $name_project
        echo "Tu peux activer l'env de dev en faisant :"
        echo "pyenv activate $name_project "
    ;;

    "11.0")
        echo "on va utiliser la version 11 de ODOO avec python 3.5"
        ## on créé un dossier venv 3.5
        cd $Workspace/../
        pyenv virtualenv 3.5 $name_project
        echo "Tu peux activer l'env de dev en faisant :"
        echo "pyenv activate $name_project "
    ;;

    "12.0")
        echo "on va utiliser la version 12 de ODOO avec python 3.5"
        ## on créé un dossier venv 3.5
        cd $Workspace/../
        pyenv virtualenv 3.5 $name_project
        echo "Tu peux activer l'env de dev en faisant :"
        echo "pyenv activate $name_project "
    ;;

    "13.0")
        echo "on va utiliser la version 13 de ODOO avec python 3.6"
        ## on créé un dossier venv 3.5
        cd $Workspace/../
        pyenv virtualenv 3.6 $name_project
        echo "Tu peux activer l'env de dev en faisant :"
        echo "pyenv activate $name_project "
    ;;

    "14.0")
        echo "on va utiliser la version 14 de ODOO avec python 3.8"
        ## on créé un dossier venv 3.8
        cd $Workspace/../
        pyenv virtualenv 3.8 $name_project
        echo "Tu peux activer l'env de dev en faisant :"
        echo "pyenv activate $name_project "
    ;;

    "15.0")
        echo "on va utiliser la version 15 de ODOO avec python 3.8"
        ## on créé un dossier venv 3.8
        cd $Workspace/../
        pyenv virtualenv 3.8 $name_project
        echo "Tu peux activer l'env de dev en faisant :"
        echo "pyenv activate $name_project "
    ;;

    "16.0")
        echo "on va utiliser la version 16 de ODOO avec python 3.10"
        ## on créé un dossier venv 3.10
        cd $Workspace/../
        pyenv virtualenv 3.10 $name_project
        echo "Tu peux activer l'env de dev en faisant :"
        echo "pyenv activate $name_project "
    ;;

    "17.0")
        echo "on va utiliser la version 17 de ODOO avec python 3.10"
        ## on créé un dossier venv 3.10
        cd $Workspace/../
        pyenv virtualenv 3.10 $name_project
        echo "Tu peux activer l'env de dev en faisant :"
        echo "pyenv activate $name_project "
    ;;

  *)
    echo "Should never get here either."
    ;;
esac


cd $Workspace
echo "on est dans le dossier $Workspace "

# LINK 
# on clone les depots selon leur branche en prenant le dernier commit
# git clone --depth 1 --branch 15.0 https://github.com/odoo/odoo
# pour prendre une autre branche 
# git fetch --depth 1  https://github.com/odoo/odoo 16.0
# git branch 16.0 FETCH_HEAD
# git checkout 16.0
#######
# link odoo
ln -sf ~/invitu-devel/allrepos/gitodoo/odoo  odoo
# link oca :: choisir et cloner les depots voulues
# ln -sf ~/invitu-devel/oca oca

#  CHECKOUT and PULL
################
cd $Workspace/odoo
git pull && git checkout $branch_odoo


# cd $Workspace/oca
# git checkout ...
# git pull  

#### END 