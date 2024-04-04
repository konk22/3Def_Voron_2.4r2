#!/bin/bash

# 1. Создание директории klipper_usb_autocopy
mkdir ${HOME}/klipper_usb_autocopy

# Переход в директорию klipper_usb_autocopy
cd ${HOME}/klipper_usb_autocopy || exit

# Задаем пути к файлам на Github
GITHUB_REPO="https://raw.githubusercontent.com/konk22/klipper_usb_autocopy/master"
RULES_FILE="99-mountcopy.rules"
SERVICE_FILE="usb-mount@.service"
MOUNTCOPY_SCRIPT="mountcopy"

# Загрузка файлов с Github и перемещение их в соответствующие директории
wget -O "$RULES_FILE" "$GITHUB_REPO/$RULES_FILE"
sudo mv "$RULES_FILE" /etc/udev/rules.d/

wget -O "$SERVICE_FILE" "$GITHUB_REPO/$SERVICE_FILE"
sudo mv "$SERVICE_FILE" /etc/systemd/system/

wget -O "$MOUNTCOPY_SCRIPT" "$GITHUB_REPO/$MOUNTCOPY_SCRIPT"
sudo mv "$MOUNTCOPY_SCRIPT" /usr/bin/

# Назначение прав на выполнение скрипта mountcopy
sudo chmod +x "/usr/bin/$MOUNTCOPY_SCRIPT"

# Перезагрузка правил udev и запуск триггера
sudo udevadm control --reload-rules && sudo udevadm trigger
