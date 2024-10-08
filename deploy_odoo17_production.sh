#! /bin/bash
workspace=/var/opt/odoo/17.0/
## Welcome message
echo "Bonjour, bienvenue dans l'outil de déploiement odoo automatique"
echo "Indiquez la date des MAJ (AAAAMMJJ)"
#Read date in the assigned variable
read date

cd /root
for i in `/bin/ls *_$date.tar.gz`
do
    echo $i
    if [[ $i == *"invitu_"$date".tar.gz" ]]; then
        module=${i%_v17_invitu_"$date"\.tar\.gz}
        echo "INVITU"
        echo $module
        folder="$module"_"$date"
        echo $folder
        cd $workspace/invitu-addons
        /bin/tar xvzf /root/$i 
        /bin/rm $module -f
        /bin/ln -s $folder $module
        cd $workspace/other-addons
        /bin/ln -s ../invitu-addons/$module
    elif [[ $i == "theme_"*$date".tar.gz" ]]; then
        module=${i%_v17_"$date"\.tar\.gz}
        echo "THEME"
        echo $module
        folder="$module"_"$date"
        echo $folder
        cd $workspace/themes_sources
        /bin/tar xvzf /root/$i 
        /bin/rm $module -f
        /bin/ln -s $folder $module
        cd $workspace/themes
        /bin/ln -s ../themes_sources/$module
    else
        module=${i%_v17_special_"$date"\.tar\.gz}
        echo "SPECIAL"
        echo $module
        folder="$module"_"$date"
        echo $folder
        cd $workspace/special-addons
        /bin/tar xvzf /root/$i 
        /bin/rm $module -f
        /bin/ln -s $folder $module
        cd $workspace/other-addons
        /bin/ln -s ../special-addons/$module
    fi
done
