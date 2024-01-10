#! /bin/bash
workspacemain=$HOME/invitu-devel
workspacerepos=$workspacemain/allrepos
## Welcome message
echo "Bonjour, bienvenue dans l'outils de lancement d'environement odoo automatique (by Coco@invitu)"
## prompt project name (requierd for python check/install)
echo "Indiquez le nom de votre projet"
#Read input in the assigned variable
read nameproject
## prompt project version (requierd for python check/install)
echo "Indiquez la version d'odoo que vous souhaitez utilisez : (Format 8,9,10,11,12,13,14,15,16,17)"
#Read input in the assigned variable
read odooversion

#We check and make project folder if not exist
echo "Nous vérifions votre dossier de projet ..."
projectpath=$workspacemain/projects/$nameproject$odooversion

if [ -d $projectpath ]
then
    echo 'Votre workspace project existe déja !'
else
    echo 'Création du workspace projet.'
    mkdir $projectpath
fi

#######
# combinaison de versions
# ODOO 08 : python 2.7.9
# ODOO 09 : python 2.7.9 
# ODOO 10 : python 2.7.9
# ODOO 11 : python 3.5
# ODOO 12 : python 3.5
# ODOO 13 : python 3.6
# ODOO 14 : python 3.8
# ODOO 15 : python 3.8
# ODOO 16 : python 3.10
# ODOO 17 : python 3.10
#########
#We check odooversion with pyenv_version

case $odooversion in
    "8" | "9" | "10")
    pyenv_version="2.7.9"
    pyenvsystem=$(pyenv versions | grep -m 1 2.7.9)
    ;;
    "11" | "12")
    pyenv_version="3.5"
    pyenvsystem=$(pyenv versions | grep -m 1 3.5)
    ;;
    "13")
    pyenv_version="3.6"
    pyenvsystem=$(pyenv versions | grep -m 1 3.6)
    ;;
    "14" | "15")
    pyenv_version="3.8"
    pyenvsystem=$(pyenv versions | grep -m 1 3.8)
    ;;
    "16" | "17")
    pyenv_version="3.10"
    pyenvsystem=$(pyenv versions | grep -m 1 3.10)
    ;;
esac

## We check or install python environement for odoo version

echo 'Nous vérifions si py env est installé.'

if [ -z "$pyenvsystem"  ]
then
    echo 'Nous installons votre pyenv pour Odoo.'
    pyenv install -v $pyenv_version
else
    echo 'Pyenv pour Odoo est déja installé, rien à faire.'
fi

## We create environement
pyenv_name=odoo$odooversion
pyenv_create=$(pyenv versions | grep -m 1 $pyenv_name)

if [ -z "$pyenv_create"  ]
then
    echo 'Création environement pyenv'
    pyenv virtualenv $pyenv_version $pyenv_name
else
    echo 'Votre environement est déja créer'
fi

#We check odoo version update
odoov="$odooversion.0"
echo "On se déplace dans le répertoire Odoo"
odoopath=$workspacerepos/gitodoo/odoo
cd $odoopath
echo "On effectue un git checkout et git pull de la version."
git checkout $odoov && git pull

#We check if modules.csv is present
echo "On vérifie si le fichier modules.csv existe..."
modulefile="$projectpath/modules.csv"
if [ -f $modulefile ]
then
    echo "Fichier présent."
else
    echo "Vous devez créer le fichier modules.csv dans votre projet $projectpath pour poursuivre !"
    exit
fi

#We check and download repos from conf csv file
echo "On importe les modules contenue dans modules.csv"


#Read each line of the file in each iteration

while IFS="," read -r module_name module_link

do

#We can make file process here
echo "On détermine quels type de module est invoqué :"

echo $module_link
if [[ $module_link == http* ]]; then
    echo 'Module via url : on supprime le lien symbolique et on recupere le module'
    if [[ -L "$projectpath/$module_name" ]]; then
        unlink $projectpath/$module_name
    fi
    echo 'on supprime aussi le dossier pour permettre une MAJ propre'
    if [[ -d "$projectpath/$module_name" ]]; then
        rm -rf $projectpath/$module_name
    fi
    repo="$(echo $module_link | cut -d/ -f5)"
    branch="$(echo $module_link | cut -d/ -f7)"
    echo $branch
    module_url=${module_link/\/tree\//\/archive\/}
    echo $module_url
    echo "wget -O - $module_url.tar.gz | tar -xz --strip=1 $repo-$branch/$module_name"
    wget -O - $module_url.tar.gz | tar -xvz -C $projectpath --strip=1 $repo-$branch/$module_name

elif  [[ $module_link == git* ]]; then
    echo 'Module via repos : on supprime le dossier et on crée le lien symbolique'
    if [[ -d "$projectpath/$module_name" ]]; then
        rm -rf $projectpath/$module_name
    fi
    echo $workspacerepos/$module_link
    if [ ! -d $workspacerepos/$module_link ]; then
        echo "please git clone the repo $module_link first"
    fi
    # On supprime le lien au cas où le repo a changé
    if [ -L $projectpath/$module_name ]; then
        echo "UNLINK"
        unlink $projectpath/$module_name
    fi
    cd $workspacerepos/$module_link
    git checkout $odoov && git pull
    ln -s $workspacerepos/$module_link/$module_name $projectpath

elif [[ $module_name == \#* ]]; then
    echo 'commentaire'

else
    echo "Erreur dans le fichier de déclaration des modules $module_name $module_link"
    exit
fi

#end of while in file
done < $modulefile


#We provide cmd for odoo lauch
echo ""
echo "Pour lancer votre environement odoo vous devez saisir cette commande :"
echo "${PYENV_ROOT}/versions/$pyenv_name/bin/python $odoopath/odoo-bin --limit-time-real=3600 --addons-path=$odoopath/addons,$projectpath -d $nameproject$odooversion"
echo "Si vous ne souhaitez pas de donnée de test, ajouter cet argument à la commande ci-dessus : --without-demo=all"
echo "Votre projet Odoo est prêt !"
