# Дипломная работа
#### Карасев Максим ИА-131

# TODO

1. -[x] [Установка\настройка srsRAN 4G](#установканастройка-srsran-4glinux)
2. -[x] [Настроить сценарий: Базовая станция <--> мобильное устройство](#созданный-сценарий)
3. -[ ] Настроить отслеживание метрик оценщика канала
4. -[ ] [Подставлять собственные исходные данные с разным уровнем изначального шума](#отправка-собственных-данных)
5. -[ ] Запустить код с помощью USRP(радиомодуль)

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

### Использование

Запуск скрипта:

```Bash
./start_srsRAN.sh -pas
```
После чего ввести пароль для sudo


## Отправка собственных данных

Для отправки собственных данных можно воспользоваться утилитой NC в Linux.

Вводим следующие команды в терминал:

```Bash
nc -l -p PORT > newfile
```

Где:

- Port - номер порта приема(для моей задачи файл отправляется с базовой станции на мобильное устройство, Port UE = 2001)
- newfile - файл, в который запишутся передаваемые файлы

```Bash
cat file | nc IP PORT
```

Где:

- file - путь до файла, который нужно передать
- IP - IP устройства(в нашей эмуляции - 172.16.0.1 для БС и 172.16.0.2 для UE)
- PORT - Номер порта передачи(PORT BS = 2000)

### Проверка

![image](/third_party/NC_CAT_2001.jpg)

![image](/third_party/NC_CAT_500MB.png)

### Мысли по терминалу

На первом скриншоте передавалось видео обьемом ~120 MB

На втором скриншоте передавался файл размером ~520 MB

Оба передались в один тик, из чего делаю вывод, что либо я не правильно использую утилиту NC, либо она не подходит в данном случае

## Дальнейшие задачи

1. Разобраться с передачей файла с BS на UE

2. В ~/.config/srsran/ue.conf и ~/.config/srsran/enb.conf закомментированны множество настроек:

	- metrics_csv_enable - записывает метрики в csv-таблицу
	
		На данном этапе, при раскомментировании этой, и связанных с ней функций создается таблица с единственной записью: #EOF

	- Различные настройки канала(AWGN, fading, delay, Radio-link failure, SNR)

	- GUI - графический интерфейс, способный отображать графики в реальном времени

3. Запустить код на радиомодуле

