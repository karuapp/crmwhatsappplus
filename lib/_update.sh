#!/bin/bash
# 
# system management

#######################################
# installs node
# Arguments:
#   None
#######################################
update_node_install() {
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
update_bd_update() {
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
update_stop_pm2() {
  print_banner
  printf "${WHITE} 💻 Agora, vamos para os serviços no deploy...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  pm2 stop all
EOF

  sleep 2
}

#######################################
# move update folder
# Arguments:
#   None
#######################################
update_mv_crmplus() {
  print_banner
  printf "${WHITE} 💻 Agora, vamos mover a update até o deploy...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  cp "${PROJECT_ROOT}"/update.zip /home/deploy/
EOF

  sleep 2
}

#######################################
# delete backend folder
# Arguments:
#   None
#######################################
update_delete_backend() {
  print_banner
  printf "${WHITE} 💻 Agora, vamos deletar o backend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  cd /home/deploy/crmplus/backend || exit
  rm -rf node_modules
  rm -rf dist
  rm -f package.json
  rm -f package-lock.json
EOF

  sleep 2
}

#######################################
# delete frontend folder
# Arguments:
#   None
#######################################
update_delete_frontend() {
  print_banner
  printf "${WHITE} 💻 Agora, vamos deletar o frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  cd /home/deploy/crmplus/frontend || exit
  find src -mindepth 1 -not -name 'App.vue' -not -name 'index.template.html' -exec rm -rf {} +
  rm -rf src-pwa
  rm -f public/POSTMAN_v2.json
  rm -f babel.config.js
  rm -f package.json
  rm -f quasar.conf.js
EOF

  sleep 2
}

#######################################
# delete frontend folder
# Arguments:
#   None
#######################################
update_tos() {
  print_banner
  printf "${WHITE} 💻 Agora, vamos atualizar os termos de uso...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  cd /home/deploy || exit
  rm -f aviso_de_privacidade.pdf
  rm -f termos_de_uso.pdf
EOF

  sleep 2
}

#######################################
# unzip update
# Arguments:
#   None
#######################################
update_unzip_crmplus() {
  print_banner
  printf "${WHITE} 💻 Fazendo unzip da update...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  unzip update.zip
EOF

  sleep 2
}

#######################################
# delete zip
# Arguments:
#   None
#######################################
update_delete_zip() {
  print_banner
  printf "${WHITE} 💻 Vamos delete o zip do update...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  cd /home/deploy || exit
  rm -f update.zip
EOF

  sleep 2
}

#######################################
# installs node.js dependencies
# Arguments:
#   None
#######################################
update_backend_node_dependencies() {
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
update_backend_db_migrate() {
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
update_backend_db_seed() {
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
# installed node packages
# Arguments:
#   None
#######################################
update_frontend_node_dependencies() {
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
update_frontend_node_build() {
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
# stop all services
# Arguments:
#   None
#######################################
update_start_pm2() {
  print_banner
  printf "${WHITE} 💻 Agora, vamos reiniciar os serviços no deploy...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  pm2 restart all
EOF

  sleep 2
}

#######################################
# creates final message
# Arguments:
#   None
#######################################
update_success() {
  print_banner
  printf "${GREEN} 💻 Atualização concluída!${NC}"
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