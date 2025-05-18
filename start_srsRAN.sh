#!/bin/bash

args_enb=(
    "--rf.device_name=zmq"
    "--channel.dl.enable=true"
    "--channel.dl.awgn.enable=true"
    "--channel.dl.awgn.snr=30"
    "--rf.device_args='fail_on_disconnect=true,tx_port=tcp://*:2000,rx_port=tcp://localhost:2001,id=enb,base_srate=23.04e6'"
    # "--gui.enable=true"
)

args_ue=(
    "--log.all_level=debug"
    "--gui.enable=true"
    "--rf.device_name=zmq"
    "--rf.device_args='tx_port=tcp://*:2001,rx_port=tcp://localhost:2000,id=ue,base_srate=23.04e6'"
    "--gw.netns=ue1"
    # "--channel.dl.enable=true"
    # "--channel.dl.awgn.enable=true"
    # "--channel.dl.awgn.snr=30"
    # "--channel.ul.enable=true"
    # "--channel.ul.awgn.enable=true"
    # "--channel.ul.awgn.snr=30"
    "--log.phy_lib_level=debug"
    # "--general.metrics_json_enable=true"
    # "--general.metrics_period_secs=1"
    # "--general.metrics_json_filename=~/Desktop/ue_metrics.json"
    
    
)

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
#EPC
gnome-terminal -- bash -c "echo $SUDO_PASSWORD | sudo -S ./srsepc/src/srsepc; exec bash"
#eNB
gnome-terminal -- bash -c "./srsenb/src/srsenb ${args_enb[*]};exec bash"
#UE
gnome-terminal -- bash -c "echo $SUDO_PASSWORD | sudo -S ./srsue/src/srsue ${args_ue[*]}; exec bash"
#Ping
gnome-terminal -- bash -c "ping 172.16.0.2; exec bash"


