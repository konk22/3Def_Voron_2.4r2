## Установка CanBoot и прошивка Klipper для Mellow Fly-SB2040:  

* Подготавливаем Mellow Fly-SB2040 к прошивке:  
	* Выключаем принтер от сети 220;  
	* Отключаем CAN проводку от модуля Fly-SB2040;  
	* Подключаем кабель Type-c к порту orangepi Zero 3;  
 	* Подключаем питание 220 к принтеру;  
	* Зажимаем кнопку Boot на Fly-SB2040;  
	* Подключаем провод Type-c к модулю Fly-SB2040 и отпускаем кнопку Boot;  
	* Подключаемся к принтеру по ssh  
* Компилируем прошивку CanBoot для Mellow Fly-SB2040:  
  ```
  cd ~/CanBoot
  make menuconfig
  ```  
* Выставляем настройки как на картинке:  
  
![](https://raw.githubusercontent.com/konk22/opz3_ubuntu_klipper/main/images/CanBoot_SB-2040.png)  

* Компилируем:  
  ```
  make clean
  make -j4
  ```  
* Проверяем подключение Fly-SB2040 к Orangepi Zero 3. В ответе должна быть строка ```Bus 006 Device 002: ID 2e8a:0003 Raspberry Pi RP2 Boot```:  
  ```
  lsusb
  ```  
* Прошиваем Fly-SB2040 только что скомпилированной прошивкой CanBoot:  
  ```
  cd ~/CanBoot
  make flash FLASH_DEVICE=2e8a:0003
  ```  
* Если не настраивали ранее, то добавляем интерфейс CAN0 на Orangepi Zero 3. Создадим файл интерфейса:  
  ```
  sudo nano /etc/network/interfaces.d/can0
  ```  
* Запишем настройки интерфейса в файл:  
  ```
  allow-hotplug can0
  iface can0 can static
	 bitrate 500000
	 up ifconfig $IFACE txqueuelen 256
	 pre-up ip link set can0 type can bitrate 500000
	 pre-up ip link set can0 txqueuelen 256

  ```  
* Перезагружаем:  
  ```
  sudo reboot
  ```  
* Компилируем прошивку Klipper для Fly-SB2040  
  ```
  cd ~/
  ./kiauh/kiauh.sh
  ```  
* Выставляем настройки как на картинке:  

  ![](https://raw.githubusercontent.com/konk22/opz3_ubuntu_klipper/main/images/klipper_Fly-SB2040.png)  

* Прошиваем Fly-SB2040 только что скомпилированной прошивкой Klipper. Дожидаемся надписи ```CAN Flash Success ``` как показано на картинке ниже:  
  ```
  python3 ~/klipper/lib/canboot/flash_can.py -u <UUID-Fly-SB2040>
  ```  

  ![](https://raw.githubusercontent.com/konk22/opz3_ubuntu_klipper/main/images/flash_klipper_Fly-SB2040.png)  

* Проверяем раздел ```Настройки->Системная информация``` Mainsail. Должно быть видно ```mcu sb2040(rp2040)``` и версии прошивок Klipper везде должны быть одинаковые:  

  ![](https://raw.githubusercontent.com/konk22/opz3_ubuntu_klipper/main/images/monitor.png)  
