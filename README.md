
# Kubeansi
Este proyecto intenta automatizar el despliegue de clusters con kubernetes, y quizá en un futuro no demasiado lejano el de OKD.

### Requisitos:
* Centos 7 Minimal


## Instalación
### Instalacion base
```bash
$ yum install -y epel-release
$ yum update -y
$ yum install -y git unzip wget curl
$ reboot
```

### Instalacion Ansible
```bash
$ sudo yum install -y ansible
```

### Instalacion kubeansi
```bash
$ git clone https://<usuario>:<password>@github.com/epava1516/kubeansi
or
$ git clone https://github.com/epava1516/kubeansi
$ cd kubeansi
$ ./install.sh
```

### Actualizacion
```bash
$ project-update
```
