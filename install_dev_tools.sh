#!/bin/bash

set -e

echo "Запуск скрипта встановлення DevOps-інструментів..."

check_installed() {
    command -v "$1" &> /dev/null
}

# Docker
if check_installed docker; then
    echo "Docker вже встановлений"
else
    echo "Встановлюємо Docker..."
    sudo apt update
    sudo apt install -y ca-certificates curl gnupg lsb-release
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    echo "Docker встановлено"
fi

# Docker Compose
if check_installed docker-compose; then
    echo "Docker Compose вже встановлений"
else
    echo "Встановлюємо Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "Docker Compose встановлено"
fi

# Python
if check_installed python3; then
    echo "Python вже встановлений"
else
    echo "Встановлюємо Python..."
    sudo apt update
    sudo apt install -y python3
    echo "Python встановлено"
fi

# pip3
if check_installed pip3; then
    echo "pip3 вже встановлений"
else
    echo "Встановлюємо pip3..."
    sudo apt install -y python3-pip
    echo "pip3 встановлено"
fi

# Django
if python3 -c "import django" &> /dev/null; then
    echo "Django вже встановлений"
else
    echo "Встановлюємо Django..."
    pip3 install django
    echo "Django встановлено"
fi

echo "Встановлення завершено!"
