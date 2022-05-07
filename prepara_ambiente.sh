#!/bin/sh


echo "\n\n INICIANDO PREPARAÇÃO DE AMBIENTE LINUX"


echo "Passo 1 - Etapa (1/8) - Atualizando repositórios e configurações"
if ! sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get autoremove
then
    echo "Não foi possível concluir o passo 1 etapa 1/8!"
    exit 1
fi


echo "Passo 1 - Etapa (2/8) - Instalando pacotes de pré requisitos do docker"
if ! sudo apt-get install -y \
            apt-transport-https \
            ca-certificates \
            curl \
            software-properties-common \
            git
then
    echo "Não foi possível concluir o passo 1 etapa 2/8!"
    exit 1
fi


echo "Passo 1 - Etapa (3/8) - Importando a chave do pacote docker"
if ! curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
then
    echo "Não foi possível concluir o passo 1 etapa 3/8!"
    exit 1
fi


echo "Passo 1 - Etapa (4/8) - Adicionando repositório docker"
if ! sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(. /etc/os-release; echo "$UBUNTU_CODENAME") stable"
then
    echo "Não foi possível concluir o passo 1 etapa 4/8! (1/2)"
    exit 1
fi


if ! sudo apt-get update
then
    echo "Não foi possível concluir o passo 1 etapa 4/8 (2/2)!"
    exit 1
fi


echo "Passo 1 - Etapa (5/8) - Instalando docker-ce e docer-compose"
if ! sudo apt-get -y install docker-ce docker-compose
then
    echo "Não foi possível concluir o passo 1 etapa 5/8!"
    exit 1
fi


echo "Passo 1 - Etapa (6/8) - Criando grupo docker no sistema"
if ! sudo addgroup --system docker
then
    echo "O grupo docker já existe no sistema"
fi


echo "Passo 1 - Etapa (7/8) - Adicionando o seu usuário ao grupo docker"
if ! sudo adduser $USER docker
then
    echo "Usuário já pertence ao grupo docker!"
fi


echo "\n\n===== ATENÇÃO ====="
echo "Por favor digite exit para continuar!"
echo "\nexit"
echo "===== FIM DA ATENÇÃO ====="


if ! sudo newgrp docker
then
    echo "Não foi possível concluir o passo 1 etapa 5/8!"
fi


echo "\n\n Passo 2 - Configurando chave SSH"

echo "Passo 2 - Etapa (1/4) - Configurando Git e SSH"

read -p "Tecle enter para continuar: " location
location=${location:-~/.ssh/id_rsa}

if [ ! -f $location ]; then
    echo "\n\n Passo 2 - Etapa (2/4) - "
    read -p "Informe seu email que aparecerá no Git (ex. script@andreazza.dev): " email
    echo "\n\n Passo 2 - Etapa (3/4) - "
    read -p "Informe o nome que aparecerá no Git (ex. Gabolera Script): " name

    git config --global user.email "$email"
    git config --global user.name "$name"
    git config --global credential.helper 'cache --timeout=99999999'

    echo "\n Passo 2 - Etapa (4/4) - Gerando chave ssh "
    ssh-keygen -t -rsa -C $email -b 4096


    echo "\n\n==== ATENÇÃO ===="
    echo "\nCopie a chave abaixo e cole no seu git para facilitar o clone dos seus projetos \n\n"
    cat ~/.ssh/id_rsa.pub

    read -p "Pressione [Enter] para prosseguir." xnotused
fi





echo "\n\n Passo 3 - Instalando PHP 7.4 ... \n\n"

echo "Passo 3 - Etapa (1/8) - Adicionando repostory do PHP"
if ! sudo add-apt-repository -y ppa:ondrej/php
then
    echo "Não foi possível concluir o passo 3 etapa 1/8!"
    exit 1
fi

echo "Passo 3 - Etapa (2/8) - Atualizando dependências"
if ! sudo apt-get update
then
    echo "Não foi possível concluir o passo 3 etapa 2/8!"
    exit 1
fi

echo "Passo 3 - Etapa (3/8) - Instalando PHP"
if ! sudo apt-get install -y php7.4
then
    echo "Não foi possível concluir o passo 3 etapa 3/8!"
    exit 1
fi

echo "Passo 3 - Etapa (4/8) - Instalando PHP"
if ! sudo apt-get install -y php-pear php7.4-curl php7.4-dev php7.4-gd php7.4-mbstring php7.4-zip php7.4-mysql php7.4-xml && sudo pecl install mongodb && sudo echo '[extension=mongodb.so](http://extension%3Dmongodb.so/)' >> /etc/php/7.4/cli/php.ini
then
    echo "Não foi possível concluir o passo 3 etapa 4/8!"
    exit 1
fi

echo "Passo 3 - Etapa (5/8) - Instalando Composer"
if ! sudo apt-get install -y composer
then
    echo "Não foi possível concluir o passo 3 etapa 5/8!"
    exit 1
fi


echo "Passo 3 - Etapa (6/8) - Instalando NPM"
if ! sudo apt-get install -y npm
then
    echo "Não foi possível concluir o passo 3 etapa 6/8!"
    exit 1
fi


echo "Passo 3 - Etapa (7/8) - Instalando n (gerenciador de versões do node"
if ! sudo npm install n -g
then
    echo "Não foi possível concluir o passo 3 etapa 7/8!"
    exit 1
fi


if ! sudo mkdir -p ~/.npm
then
    echo "Não foi possível instalar criar a pasta ~/.npm \n"
fi

if ! sudo chown -R $(whoami) ~/.npm
then
    echo "Não foi possível atribuir as permissões para o usuário pasta ~/.npm \n"
fi

if ! sudo mkdir -p /usr/local/n
then
    echo "Não foi possível criar a pasta /usr/local/n \n"
fi

if ! sudo chown -R $(whoami) /usr/local/n
then
    echo "Não foi possível atribuir as permissões para o usuário na pasta /usr/local/n \n"
fi

if ! sudo mkdir -p /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share
then
    echo "Não foi possível criar as pastas /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share \n"
fi

if ! sudo chown -R $(whoami) /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share
then
    echo "Não foi possível atribuir as permissões para o usuário nas pastas /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share \n"
fi

if ! n 16
then
    echo "n não conseguiu instalar o node 16\n"
fi

echo "Passo 3 - Etapa (8/8) - Instalando Git Flow ... \n\n"
if ! sudo apt-get install -y git-flow
then
    echo "Não foi possível instalar o Git Flow \n"
    exit 1
else
    git config --add gitflow.multi-hotfix true
fi
