## Установка\настройка srsRAN 4G(Linux)

### Необходимые библиотеки:
```Bash
sudo apt-get install build-essential cmake libfftw3-dev libmbedtls-dev libboost-program-options-dev libconfig++-dev libsctp-dev
```

### Zero MQ

libzmq

```Bash
git clone https://github.com/zeromq/libzmq.git
cd libzmq
./autogen.sh
./configure
make
sudo make install
sudo ldconfig
```

czmq

```Bash
git clone https://github.com/zeromq/czmq.git
cd czmq
./autogen.sh
./configure
make
sudo make install
sudo ldconfig
```

### srsRAN 4G
```Bash
git clone https://github.com/srsRAN/srsRAN_4G.git
cd srsRAN_4G
mkdir build
cd build
cmake ../
make
make test

sudo make install
srsran_install_configs.sh user
```
### srsRAN GUI
```Bash
git clone https://github.com/srsLTE/srsGUI.git
cd srsgui
mkdir build
cd build
cmake ../
make 
```

### Возникшие проблемы
Команда
```Bash
make test
```

Останавливалась на 7ом тесте. Не выдавала ошибок, не останавливала тесты. Команда:
```Bash
ctest --verbose
```
Так же останавливалась при 7ом тесте

При команде:
```Bash
sudo make test
```
Тесты прошли, вывод в терминал:

```Bash
The following tests FAILED:
	876 - benchmark_radio_multi_rf (Failed)
```

Возможное решение:

Добавить права на доступ
```Bash
sudo usermod -a -G plugdev $USER
sudo usermod -a -G usb $USER
sudo chmod -R 777 /dev/bus/usb/  # Временное решение (небезопасно!)
```

После чего перезагрузить компьютер.


## Созданный сценарий

[start_srsRAN.sh](/start_srsRAN.sh)

В данном сценарии можно удобно менять конфигурации. Для этого необходимо найти файлы конфигураций srsRAN

```Bash
cd ~/.config/srsran
```
Выбрать необходимые настройки и вставить в соответствующие массивы:
	
- args_enb - Настройки базовой станции
- args_ue - Настройки мобильного устройства

### Использование

Запуск скрипта:

```Bash
./start_srsRAN.sh -pas
```
После чего ввести пароль для sudo

### Результат

![image](/third_party/start_srsran.png)

## Отправка собственных данных

Для отправки собственных данных можно воспользоваться утилитой netcat в Linux.

Вводим следующие команды в терминал:

```Bash
sudo ip netns exec ue1 nc -l -p 1234 > received_file.txt
```

Где:

- ip netns exec ue1

    - ip netns – управление сетевыми пространствами (network namespaces) в Linux.

    - exec ue1 – выполнить команду внутри сетевого пространства ue1.

    - UE (User Equipment) работает в изолированном сетевом пространстве ue1, поэтому все сетевые команды (включая nc) должны выполняться внутри него.

- nc -l -p 1234

    - nc (или netcat) – утилита для работы с сетевыми соединениями (отправка/приём данных через TCP/UDP).

    - -l (listen) – запустить netcat в режиме сервера (ожидание входящих подключений).

    - -p 1234 (port) – слушать на порту 1234.

- \> received_file

    - \> – перенаправление вывода (stdout) в файл.

    - received_file – путь и имя файла, в который будут записаны полученные данные.

```Bash
nc 172.16.0.2 1234 < file_to_send.txt
```

Где:

- nc - netcat
- 172.16.0.2 - IP устройства(в нашей эмуляции - 172.16.0.1 для БС и 172.16.0.2 для UE)
- 1234 - Номер порта передачи
- /< file_to_send - путь и имя файла для отправки

### Проверка

*Картинка рябит из-за конвертации в .gif. Форматы .mp4 .mov .webm не удалось отобразить*

![gif](/third_party/tx_file.gif)

Во время передачи файла, можно ввести команду
```Bash
ls -lh filename
```
Чтобы вывести текущий размер файла

![image](/third_party/check_file.jpg)


