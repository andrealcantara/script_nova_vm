#!/bin/bash

# Variaveis
MENSAGEM_VISUDO='\n# Especificacao para nao precisar de senha'

# Ajustes de Password
read -sp 'Root Passowrd: ' INPUT_ROOT
read -sp 'Ubuntu Passowrd: ' INPUT_UBUNTU



# Ajustes de Password do root
echo $INPUT_ROOT | passwd --stdin root

# Ajustes de Password do Ubuntu
adduser --disabled-password --gecos "Ubuntu" ubuntu
echo $INPUT_UBUNTU | passwd --stdin ubuntu
usermod -aG sudo ubuntu
usermod -aG adm ubuntu

echo '${MENSAGEM_VISUDO@E}' | sudo EDITOR='tee -a' visudo
echo 'Defaults:ubuntu  !authenticate' | sudo EDITOR='tee -a' visudo

# Atualização de pacotes
apt update && apt upgrade -y

# Atualização de Firewall
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow http
ufw allow https
ufw allow 8000
ufw limit ssh
ufw enable


echo 'Voce deve adicionar uma ssh Key no authorizedkeys primeiramente'
echo 'Depois deve alterar para nao[no] os seguintes parametros:'
echo 'PermitRootLogin PasswordAuthentication'
echo 'Comandos a seguir vao ajudar a encontrar os parametros'
echo 'sudo vim +/PermitRootLogin /etc/ssh/sshd_config'
echo 'sudo vim +/PasswordAuthentication /etc/ssh/sshd_config'
