
# Kubeansi
Este proyecto intenta automatizar el despliegue de clusters con kubernetes, y quizá en un futuro no demasiado lejano el de OKD.

### Requisitos:
* Centos 7 Minimal


## Instalación
### Instalacion base
```console
[root@node ~]# yum install -y epel-release
[root@node ~]# yum install -y git python-netaddr
[root@node ~]# yum update -y
[root@node ~]# reboot
```

### Instalacion Ansible
```console
[root@node ~]# sudo yum install -y ansible
```
#### Version utilizada durante estas pruebas
```console
[root@node ~]# ansible --version
```
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
[root@node ~]# git clone https://<usuario>:<password>@github.com/epava1516/kubeansi
or
[root@node ~]# git clone https://github.com/epava1516/kubeansi
[root@node ~]# cd kubeansi
[root@node ~]# ./install.sh
```

### Actualizacion
```console
[root@node ~]# project-update
```


## To fix
* Fix services failling during and after server setup

* Durante el primer setup:

```console
TASK [pxeboot : Set IP in deploy PXE interface (ens37)] **********************************************************************************************************************************************************************************
fatal: [localhost]: FAILED! => {"changed": false, "msg": "AnsibleFilterError: The ipaddr filter requires python's netaddr be installed on the ansible controller"}
```

**Al volver a ejecutar no vuelve a suceder**

El fallo se debe a la supuesta falta del paquete "python-netaddr" el cual es instalado en el sexto task, tras fallar parece ser capaz de inicializar dicho paquete al volver a lanzar la ejecución, pero esto no debería suceder, por lo que su instalación tendrá que realizarse durante los preparativos al git clone **DE MOMENTO**