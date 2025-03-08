#!/bin/bash
# 
# system management

#######################################
# installs node
# Arguments:
#   None
#######################################
migration_node_install() {
  print_banner
  printf "${WHITE} 💻 Instalando nodejs...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
  apt-get install -y nodejs
EOF

  sleep 2
}

#######################################
# installs node
# Arguments:
#   None
#######################################
migration_bd_update() {
  print_banner
  printf "${WHITE} 💻 Atualizando permissões do banco...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  # Verifica se o contêiner está em execução
  if docker ps -q -f name=postgresql; then
    docker exec -u root postgresql bash -c "chown -R postgres:postgres /var/lib/postgresql/data"
  else
    echo "O contêiner postgresql não está em execução. Verifique o status do contêiner."
  fi
EOF

  sleep 2
}

#######################################
# stop all services
# Arguments:
#   None
#######################################
migration_stop_pm2() {
  print_banner
  printf "${WHITE} 💻 Agora, vamos para os serviços no deploy...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  pm2 delete all
EOF

  sleep 2
}

#######################################
# move migration folder
# Arguments:
#   None
#######################################
migration_mv_crmplus() {
  print_banner
  printf "${WHITE} 💻 Agora, vamos mover a migration até o deploy...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  cp "${PROJECT_ROOT}"/crmplus.zip /home/deploy/
  unzip -o /home/deploy/crmplus.zip -d /home/deploy/
  chmod -R 775 /home/deploy/crmplus
  rm -f /home/deploy/crmplus.zip
EOF

  sleep 2
}

#######################################
# delete backend folder
# Arguments:
#   None
#######################################
migration_delete_backend() {
  print_banner
  printf "${WHITE} 💻 Agora, vamos deletar o backend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  cd /home/deploy/crmplus/backend || exit
  rm -rf .wwebjs_auth
  rm -rf .wwebjs_cache
  rm -rf dist
  rm -f package.json
EOF

  sleep 2
}

#######################################
# delete frontend folder
# Arguments:
#   None
#######################################
migration_delete_frontend() {
  print_banner
  printf "${WHITE} 💻 Agora, vamos deletar o frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  cd /home/deploy/crmplus/frontend || exit
  rm -rf src
  rm -rf public
  rm -f package.json
  rm -f quasar.conf.js
EOF

  sleep 2
}

#######################################
# unzip migration
# Arguments:
#   None
#######################################
migration_unzip_crmplus() {
  print_banner
  printf "${WHITE} 💻 Movendo e fazendo unzip do crmplus...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  # Mover el archivo ZIP a /home/deploy/
  mv /crmwhatsappplus/crmplus.zip /home/deploy/

  # Cambiar propietario a deploy para evitar problemas de permisos
  chown deploy:deploy /home/deploy/crmplus.zip
  chmod 664 /home/deploy/crmplus.zip
EOF

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy || exit

  # Verificar si el archivo ZIP existe antes de descomprimir
  if [ -f crmplus.zip ]; then
    unzip -o crmplus.zip -d /home/deploy/
    echo "✅ Unzip finalizado!"
  else
    echo "⚠️ ERROR: No se encontró el archivo crmplus.zip en /home/deploy/"
  fi
EOF

  sleep 2
}


#######################################
# delete zip
# Arguments:
#   None
#######################################
migration_delete_zip() {
  print_banner
  printf "${WHITE} 💻 Vamos delete o zip do migration...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  cd /home/deploy || exit
  rm -f crmplus.zip
EOF

  sleep 2
}

#######################################
# installs node.js dependencies
# Arguments:
#   None
#######################################
migration_backend_node_dependencies() {
  print_banner
  printf "${WHITE} 💻 Instalando dependências do backend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/crmplus/backend
  npm install --force
EOF

  sleep 2
}

#######################################
# runs db migrate
# Arguments:
#   None
#######################################
migration_backend_db_migrate() {
  print_banner
  printf "${WHITE} 💻 Executando db:migrate...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/crmplus/backend
  npx sequelize db:migrate
EOF

  sleep 2
}

#######################################
# runs db seed
# Arguments:
#   None
#######################################
migration_backend_db_seed() {
  print_banner
  printf "${WHITE} 💻 Executando db:seed...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/crmplus/backend
  npx sequelize db:seed:all
EOF

  sleep 2
}

#######################################
# starts backend using pm2 in 
# production mode.
# Arguments:
#   None
#######################################
migration_backend_start_pm2() {
  print_banner
  printf "${WHITE} 💻 Iniciando pm2 (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/crmplus/backend
  pm2 start dist/server.js --name crmplus-backend
  pm2 save
EOF

  sleep 2
}

#######################################
# installed node packages
# Arguments:
#   None
#######################################
migration_frontend_node_dependencies() {
  print_banner
  printf "${WHITE} 💻 Instalando dependências do frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/crmplus/frontend
  npm install --force
EOF

  sleep 2
}

#######################################
# compiles frontend code
# Arguments:
#   None
#######################################
migration_frontend_node_build() {
  print_banner
  printf "${WHITE} 💻 Compilando o código do frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/crmplus/frontend
  export NODE_OPTIONS=--openssl-legacy-provider
  npx quasar build -P -m pwa
EOF

  sleep 2
}

#######################################
# starts frontend using pm2 in 
# production mode.
# Arguments:
#   None
#######################################
migration_frontend_start_pm2() {
  print_banner
  printf "${WHITE} 💻 Iniciando pm2 (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/crmplus/frontend
  pm2 start server.js --name crmplus-frontend
  pm2 save
EOF

  sleep 2
}


#######################################
# creates final message
# Arguments:
#   None
#######################################
migration_success() {
  print_banner
  printf "${GREEN} 💻 Migração concluída!${NC}"
  printf "\n\n"
  printf "Caso o sistema apresente alguma instabilidade, verifique os retornos dos processos, em busca de possíveis incosistências ou restaure o seu backup..."
  printf "\n"
  printf "${GREEN}FAQ: https://marcablancasaas.com/${NC}"
  printf "\n"
  printf "${GREEN}Suporte: https://marcablancasaas.com/${NC}"
  printf "\n"
  printf "${CYAN_LIGHT}";
  printf "${NC}";

  sleep 2
}