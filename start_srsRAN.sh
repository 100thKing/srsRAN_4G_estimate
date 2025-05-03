#!/bin/bash

# Проверяем, передан ли флаг -pas
if [[ "$1" != "-pas" ]]; then
    echo "Используйте флаг -pas для запуска скрипта."
    exit 1
fi

# Переходим в нужную директорию
cd ~/srsRAN_4G/build || { echo "Не удалось перейти в директорию ~/srsRAN_4G/build"; exit 1; }

# Запрашиваем пароль у пользователя
read -s -p "Введите пароль для sudo: " SUDO_PASSWORD
echo


# Открываем 5 терминалов и выполняем команды в каждом из них
gnome-terminal -- bash -c "echo $SUDO_PASSWORD | sudo -S ip netns add ue1; exec bash"
gnome-terminal -- bash -c "echo $SUDO_PASSWORD | sudo -S ./srsepc/src/srsepc; exec bash"
gnome-terminal -- bash -c "./srsenb/src/srsenb --rf.device_name=zmq --rf.device_args='fail_on_disconnect=true,tx_port=tcp://*:2000,rx_port=tcp://localhost:2001,id=enb,base_srate=23.04e6'; exec bash"
gnome-terminal -- bash -c "echo $SUDO_PASSWORD | sudo -S ./srsue/src/srsue --metrics.csv.output_file=~/Desktop/ue_channel_estimate.csv --rf.device_name=zmq --rf.device_args='tx_port=tcp://*:2001,rx_port=tcp://localhost:2000,id=ue,base_srate=23.04e6' --gw.netns=ue1; exec bash"
gnome-terminal -- bash -c "ping 172.16.0.2; exec bash"


