#!/bin/bash

echo "Iniciando a simulação de provisionamento de ambiente de 3 microsserviços..."
echo "----------------------------------------------------------"

# Variáveis importantes
MYSQL_CONTAINER="db-app"
MYSQL_ROOT_PASSWORD="senha_super_segura"
NGINX_CONTAINER="proxy-nginx"
NGINX_HOST_PORT="80"

echo "Variáveis de configuração:"
echo "  MySQL Container: $MYSQL_CONTAINER"
echo "  Senha Root MySQL: $MYSQL_ROOT_PASSWORD"
echo "  Container Nginx: $NGINX_CONTAINER (Porta Host: $NGINX_HOST_PORT)"
echo "----------------------------------------------------------"

# ------------------------------------------------------------------------------
# 1. Instalar o Docker (assumindo já instalado)
echo "Etapa 1: Verificando se o Docker está instalado..."
if command -v docker &> /dev/null; then
 echo "Docker já está instalado."
else   
 echo "Docker não está instalado. Execute as etapas de instalação."
true # Adicione aqui os comandos de instalação do Docker se necessário
fi
echo "----------------------------------------------------------"

# ------------------------------------------------------------------------------
# 2. Instalação do Container MySQL (assumindo já rodando)
echo "Etapa 2: Verificando se o Container MySQL está rodando..."
if docker ps -q --filter name="$MYSQL_CONTAINER" | grep -q .; then
    echo "Container MySQL '$MYSQL_CONTAINER' já está rodando."
else
    echo "Container MySQL '$MYSQL_CONTAINER' não está rodando. Execute as etapas de criação."
    # Adicione aqui os comandos de criação do container MySQL se necessário
fi
echo "----------------------------------------------------------"

# ------------------------------------------------------------------------------
# 3. Configurar o Swarm (Modo Simples - Apenas um nó manager)
echo "Etapa 3: Inicializando o Swarm (se ainda não inicializado)..."
if docker swarm info 2>&1 | grep -q "Swarm: active"; then
    echo "Swarm já está inicializado."
else
    echo "Inicializando o Swarm..."
  # docker swarm init --advertise-addr $(ip addr show eth0 | grep "inet " | awk '{print $2}' | cut -d/ -f1)
fi
echo "----------------------------------------------------------"
# ------------------------------------------------------------------------------
# 4. Simulação de Criação de Serviços Swarm para os Microsserviços
echo "Etapa 4: Criando serviços de exemplo no Swarm..."
echo "Criando o serviço 'usuarios-api'..."
#docker service create --name usuarios-api --replicas 1 -p 8081:5000 python:3.9-slim-buster
echo "Criando o serviço 'catalogo-api'..."
#docker service create --name catalogo-api --replicas 1 -p 8082:3000 node:16-alpine
echo "Criando o serviço 'pedidos-api'..."
#docker service create --name pedidos-api --replicas 1 -p 8083:8080 openjdk:17-jre-slim
echo "Serviços 'usuarios-api', 'catalogo-api' e 'pedidos-api' criados no Swarm (simulação)."
echo "----------------------------------------------------------"

# ------------------------------------------------------------------------------
# 5. Configurar um Container Nginx como um Proxy Reverso para os Serviços Swarm
echo "Etapa 5: Configurando o Container Nginx como Proxy Reverso..."
if docker ps -q --filter name="$NGINX_CONTAINER" | grep -q .; then
    echo "Container Nginx '$NGINX_CONTAINER' já está rodando."
else
    echo "Criando o Container Nginx '$NGINX_CONTAINER'..."
    docker pull nginx:latest
    docker run -d --name $NGINX_CONTAINER \
               -p $NGINX_HOST_PORT:80 \ 
               -v nginx_config:/etc/nginx/conf.d \
               nginx:latest
fi

echo "Criando a configuração do Nginx para rotear para os serviços Swarm..."
NGINX_CONFIG="/etc/nginx/conf.d/default.conf"
echo "upstream usuarios_upstream {
    server usuarios-api:5000;
}

upstream catalogo_upstream {
    server catalogo-api:3000;
}

upstream pedidos_upstream {
    server pedidos-api:8080;
}

server {
    listen $NGINX_HOST_PORT;
    server_name localhost;
 location /usuarios/ {
        proxy_pass http://usuarios_upstream;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location /catalogo/ {
        proxy_pass http://catalogo_upstream;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location /pedidos/ {
        proxy_pass http://pedidos_upstream;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}" | sudo tee $NGINX_CONFIG

echo "Configuração do Nginx criada. Reinicie o container Nginx para aplicar as alterações:"
docker restart $NGINX_CONTAINER

echo "----------------------------------------------------------"
echo "Simulação de provisionamento concluída. Os serviços Swarm foram criados (com imagens genéricas) e o Nginx está configurado para rotear o tráfego."
