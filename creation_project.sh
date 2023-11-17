#! /bin/bash


## read config file

# all_infos = "config_file.json"

name_project = $(jq -r .project_name config_file.json )
branch_odoo = $(jq -r .branch_odoo config_file.json )


Workspace="~/Workspace/$name_project"

echo "Nom du projet : " $name_project

# create dir of project
if [[ ! -e $Workspace ]]; then
    mkdir -p ~/$Workspace
elif [[ ! -d ~/$Workspace ]]; then
    echo "$Workspace already exists but is not a directory" 1>&2
fi

cd ~/$name_project
echo "on est dans le dossier ~/$name_project "

# LINK 
#######
# link odoo
# ln -sf ~/invitu-devel/odoo  odoo
# link oca
# ln -sf ~/invitu-devel/oca oca

#  CHECKOUT and PULL
################
# cd $Workspace/odoo
# git checkout -b $branch_odoo  
# git pull

# cd $Workspace/oca
# git checkout ...
# git pull  


#### END 




