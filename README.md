
# Kubeansi
Este proyecto intenta automatizar el despliegue de clusters con kubernetes, y quizá en un futuro no demasiado lejano el de OKD.

### Requisitos:
* Centos 7 Minimal


## Instalación
### Instalacion base
```console
$ yum install -y epel-release
$ yum update -y
$ yum install -y git unzip wget curl
$ reboot
```

### Instalacion Ansible
```console
$ sudo yum install -y ansible
```
#### Version utilizada durante estas pruebas
```
ansible 2.9.2
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/root/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/site-packages/ansible
  executable location = /usr/bin/ansible
  python version = 2.7.5 (default, Aug  7 2019, 00:51:29) [GCC 4.8.5 20150623 (Red Hat 4.8.5-39)]
```

### Instalacion kubeansi
```console
$ git clone https://<usuario>:<password>@github.com/epava1516/kubeansi
or
$ git clone https://github.com/epava1516/kubeansi
$ cd kubeansi
$ ./install.sh
```

### Actualizacion
```console
$ project-update
```


## To fix
* Fix services failling during and after server setup