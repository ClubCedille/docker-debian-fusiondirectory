# fusiondirectory
FusionDirectory docker image

<img src="http://kubernetes.io/kubernetes/img/warning.png" alt="WARNING"
     width="25" height="25">
<img src="http://kubernetes.io/kubernetes/img/warning.png" alt="WARNING"
     width="25" height="25">
<img src="http://kubernetes.io/kubernetes/img/warning.png" alt="WARNING"
     width="25" height="25">
<img src="http://kubernetes.io/kubernetes/img/warning.png" alt="WARNING"
     width="25" height="25">
<img src="http://kubernetes.io/kubernetes/img/warning.png" alt="WARNING"
     width="25" height="25">

**Warning : The last version of Fusions directory isn't tested with theses scripts. Then, if you want use this image on production, it's recommended to refer to this branch https://github.com/ClubCedille/docker-debian-fusiondirectory/tree/1.0.14 **

## Quickstart

```
git clone -b 1.0.14 https://github.com/clubcedille/docker-debian-fusiondirectory.git
cd docker-debian-fusiondirectory/
docker-compose up
```

Then, it's possible to access on Fusion Directory web ui on localhost :

http://127.0.0.1:10080/fusiondirectory


## Deploying this project using Ansible (Under developpement)

```
git clone https://github.com/clubcedille/docker-debian-fusiondirectory.git
cd docker-debian-fusiondirectory/ansible
```

Configure hosts : inventories/production/hosts

Configure admin username/password : inventories/production/group_vars/all

Install project depedencies : `ansible-galaxy install -r requirements.yml`

Run the project : `ansible-playbook playbook.yml`

http://127.0.0.1:10080/fusiondirectory

## TODO

- [x] Put ldap database in Docker volume.
- Add more options on this Docker image.
- Test more deployer for Debian using ansible
