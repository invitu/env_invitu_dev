# Installation d'un environnement de developpement Odoo
> env_invitu_dev

## Development environment installation :
This script has been written to have a quickly odoo environment using python env and git stuff.

### 1. Create a workspace on your local environment
The workspace on the developer computer should be like this :

*~/invitu-devel/allrepos* : all the repos cloned from github

*~/invitu-devel/projects* : all the projects the developer works on

For example, we can have 3 repos gitodoo, gitoca, gitinvitu respectively : 
https://github.com/odoo/odoo, https://github.com/oca, https://github.com/invitu

For a project named "test" in Odoo v17, we will have *~/invitu-devel/projects/test17* 

### 2. In *~/invitu-devel/allrepos/gitinvitu*, clone this repo :
```
git clone https://github.com/invitu/env_invitu_dev.git
```
### 3. Fork the repo env_invitu_dev (github)

### 4. Create a new branch : 
```
git branch checkout -b [new-branch-name]
```

## Odoo installation

### Prerequisites :  

#### pyenv

> Pyenv is a popular tool for managing multiple versions of Python on your system. It allows you to easily switch between different Python versions for different projects.

1/ Dependencies for Fedora/CentOS/RHEL
``` 
sudo dnf install git gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel libffi-devel patch
```
2/ Use this command curl to install
```
curl https://pyenv.run | bash
```
3/ Add these lines into your *~/.bash_profile*
``` 
export PATH="$HOME/.pyenv/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
```
4/ Restart your shell for the changes to take effects

#### openldap/python (in *~/invitu-devel/allrepos/gitodoo/odoo*)
```
> connect as super-admin to install :
sudo bash
...
exit

> openldap install :
dnf install openldap-devel

> python version install and requirements :
dnf install python-ldap
$HOME/.pyenv/versions/odoo17/bin/pip3.12 install -r requirements.txt
```
#### postgresql 
To see if postgresql is installed, use these commands :
```
> version of postgresql (or error = not installed)
psql --version

> path
which psql

> add the path into your ~/.bash_profile
export PSQL="{path}" 
```

### Launch file : (from *~/invitu-devel/allrepos/gitinvitu/env_invitu_dev*)
```
./create_environment.sh
```
### Modules :
The module.csv file is where are defining the modules that will be installed in your Odoo environment.
It is filled with 2 elements :

1/ module_name,module_path (from allrepos/)

> example : partner_firstname,gitoca/partner-contact

2/ module_name,PR_branch_url (access the Pull request(PR) and retrieve the url of the PR source branch) 

> example : vidal_connector,https://github.com/dixmit/connector-vidal/tree/17.0-fix

1. create modules.csv on your project repo (in *~/invitu-devel/projects*) so these modules will be installed in your environment
2. in *~/invitu-devel/allrepos* clone the github repos 

### Install python environment for Odoo version 
> also in launch_project.sh
```
pyenv install -v {pyenv-version}
pyenv versions | grep -m 1 {pyenvname}
pyenv virtualenv {pyenv-version} {pyenvname}
```

#### When pyenv is installed :
```
./launch_project.sh
```

## Launch Odoo : *(from allrepos/gitodoo/odoo)*
> This command comes from launch_project.sh
```
/<pyenv_root>/versions/<pyenv_name>/bin/python /<odoo_path>/odoo-bin --limit-time-real=3600 --addons-paths=/<odoo_path>/addons,/<project_path> -d <name_project,odoo_version>
```
and now, you can use Odoo via 'localhost:8069'
