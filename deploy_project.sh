#! /bin/bash
workspacemain=$HOME/invitu-devel
workspacerepos=$workspacemain/allrepos
## Welcome message
echo "Bonjour, bienvenue dans l'outil de déploiement odoo automatique"
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
echo "On importe les modules contenus dans modules.csv"


TTY=`tty`
#Read each line of the file in each iteration

while IFS="," read -r module_name module_link

do

#We can make file process here
echo "On détermine quels type de module est invoqué :"

echo $module_link
if [[ $module_name == \#* ]]; then
    echo 'commentaire'

elif [[ $module_link == http* ]]; then
    echo 'Module via url : on fait un tar.gz direct'
    cd $projectpath
    mv $module_name "$module_name"_"$(date +%Y%m%d)"
    #while true
    #do
    echo $module_name $module_link
    read -p "invitu (1) ou special (2) ?" input <$TTY
    case $input in
        exit) break ;;
        1)
            echo "Invitu"
            tar cvzf /tmp/"$module_name"_v"$odooversion"_invitu_"$(date +%Y%m%d)".tar.gz "$module_name"_"$(date +%Y%m%d)"
            echo "scp '$module_name'_v'$odooversion'_invitu_$(date +%Y%m%d).tar.gz"
            scp -P2222 /tmp/"$module_name"_v"$odooversion"_invitu_"$(date +%Y%m%d)".tar.gz root@odoov$odooversion:.
            ;;
        2)
            echo "Special"
            tar cvzf /tmp/"$module_name"_v"$odooversion"_special_"$(date +%Y%m%d)".tar.gz "$module_name"_"$(date +%Y%m%d)"
            echo "scp '$module_name'_v'$odooversion'_special_$(date +%Y%m%d).tar.gz"
            scp -P2222 /tmp/"$module_name"_v"$odooversion"_special_"$(date +%Y%m%d)".tar.gz root@odoov$odooversion:.
            ;;
        *) echo "Unknown response, enter a number 1-2 or type 'exit' to quit" ;;
    esac
    #done
    mv "$module_name"_"$(date +%Y%m%d)" $module_name

elif  [[ $module_link == git* ]]; then
    echo 'Module via repos : on fait un archive'
    cd $projectpath/$module_name
    if [[ $module_link == "gitinvitu"* ]];
    then
        git archive --format tgz --prefix "$module_name"_"$(date +%Y%m%d)"/ --output /tmp/"$module_name"_v"$odooversion"_invitu_"$(date +%Y%m%d)".tar.gz $odooversion.0
        echo "scp '$module_name'_v'$odooversion'_invitu_$(date +%Y%m%d).tar.gz"
        scp -P2222 /tmp/"$module_name"_v"$odooversion"_invitu_"$(date +%Y%m%d)".tar.gz root@odoov$odooversion:.
    else
        git archive --format tgz --prefix "$module_name"_"$(date +%Y%m%d)"/ --output /tmp/"$module_name"_v"$odooversion"_special_"$(date +%Y%m%d)".tar.gz $odooversion.0
        echo "scp '$module_name'_v'$odooversion'_special_$(date +%Y%m%d).tar.gz"
        scp -P2222 /tmp/"$module_name"_v"$odooversion"_special_"$(date +%Y%m%d)".tar.gz root@odoov$odooversion:.
    fi

else
    echo "Erreur dans le fichier de déclaration des modules $module_name $module_link"
    exit
fi

#end of while in file
done < $modulefile
