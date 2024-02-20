## Установка CanBoot и прошивки Klipper на MKS Monster8v2:  
* Устанавливаем CanBoot:  
  ```
  cd ~
  git clone https://github.com/Arksine/CanBoot
  ```  
* Устанавливаем Pyserial:  
  ```
  pip3 install pyserial
  ```  
* Выключаем принтер от сети 220, затем переводим плату MKS Monster8v2 в режим DFU:  
    * Ставим перемычку в блоке "select" (зеленый квадрат, замкнута левая группа контактов);  
    * Ставим перемычку питания платы в положение "On" (красный квадрат, замкнуты верхние контакты);  
    * Подключаем питание Orangepi Zero 3 к внешнему источнику питания, например зарядка для телефона или повербанк. К сети 220 принтер не подключаем!!!  
    * Зажимаем кнопки Reset и Boot. Отпускаем сначала Reset, затем Boot  

![](https://raw.githubusercontent.com/konk22/opz3_ubuntu_klipper/main/images/MKSMonster8v2_DFU.png)  
  
* Подключаемся через SSH к Orangepi Zero 3, и проверяем подключился ли MCU. В ответ должны получить ```STMicroelectronics STM Device in DFU mode```:  
  ![](https://raw.githubusercontent.com/konk22/opz3_ubuntu_klipper/main/images/lsusb_DFU_mod_MKSMonster8v2.png)  
    
* Компилируем прошивку CanBoot для MKS Monster8v2:  
  ```
  cd CanBoot
  make menuconfig
  ```  
* Выставляем настройки как на картинке:  

  ![](https://raw.githubusercontent.com/konk22/opz3_ubuntu_klipper/main/images/CanBoot_MKSMonster8v2.png)  

* Компилируем:  
  ```
  make clean
  make
  ```  
* Прошиваем CanBoot в MKS Monster8v2. ПРИМЕЧАНИЕ. Если после вышеизложенного вы видите ошибку, не волнуйтесь, все в порядке, если у вас есть надпись «Файл загружен успешно» в строке перед ошибкой:  
  ```
  sudo dfu-util -a 0 -D ~/CanBoot/out/canboot.bin --dfuse-address 0x08000000:force:mass-erase:leave -d 0483:df11
  ```  
* Проверяем загружен ли CanBoot. Дважды нажимаем Reset, затем вводим команды:  
  ```
  lsusb
  в ответ должны получить OpenMoko stm32f407xx
  ls /dev/serial/by-id/
  в ответ должны получить серийный номер устройства /dev/serial/by-id/usb-CanBoot_stm32f407xx_<серийный номер>-if00
  ПРИМЕЧАНИЕ: /dev/serial/by-id/usb-CanBoot_stm32f407xx_<серийный номер>-if00 необходим для следующих шагов
  ```  
* Компилируем прошивку для Klipper:  
  ```
  cd ~/klipper
  make menuconfig
  ```  
* Выставляем настройки как на картинке:

![](https://raw.githubusercontent.com/konk22/opz3_ubuntu_klipper/main/images/klipper_MKSMonster8v2.png)
      
* Компилируем:  
  ```
  make clean
  make
  ```  
* Прошиваем MKS Monster8v2 только что скомпилированной прошивкой Klipper через CanBoot:  
  ```
  python3 ~/CanBoot/scripts/flash_can.py -d  /dev/serial/by-id/usb-CanBoot_stm32f407xx_<серийный номер>-if00
  ```  

  ![](https://raw.githubusercontent.com/konk22/opz3_ubuntu_klipper/main/images/flash_klipper_MKSMonster8v2.png)  
* Настраиваем интерфейс CAN0 на Orangepi Zero 3. Создадим файл интерфейса:  
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
* Проверяем установлена ли связь с MKS Monster8v2 после прошивки. В ответе должна быть строка с ```1b50:606f OpenMoko```:  
  ```
  lsusb
  ```  

  ![](https://raw.githubusercontent.com/konk22/opz3_ubuntu_klipper/main/images/lsusb_MKSMonster8v2.png)  

* Отключаем внешнее питание от orangepi. Ставим перемычку питания платы в положение "Off" (красный квадрат, замкнуты нижние контакты):  
   
  ![](https://raw.githubusercontent.com/konk22/opz3_ubuntu_klipper/main/images/MKSMonster8v2_DFU.png)  
  
* Подключаем питание 220 к принтеру и проверяем видит ли Orangepi Zero 3 наш MKS Monster8v2:  
  ```
  ~/CanBoot/scripts/flash_can.py -i can0 -q
  ```  

  ![](https://raw.githubusercontent.com/konk22/opz3_ubuntu_klipper/main/images/uuid_msu.png)  

* Проверяем работает ли интерфейс CAN0:  

  ![](https://raw.githubusercontent.com/konk22/opz3_ubuntu_klipper/main/images/CAN0_up.png)  

* Получаем UUID MKS Monster8v2. ПРИМЕЧАНИЕ: Команда возвращает UUID только для неинициализарованных MCU в Klipper (printer.cfg):  
  ```
  ~/CanBoot/scripts/flash_can.py -i can0 -q
  ```  
  ![](https://raw.githubusercontent.com/konk22/opz3_ubuntu_klipper/main/images/uuid_msu2.png)  
    
* Для инициализируем MSU в printer.cfg, добавим данные строки:  
  ```
  [mcu]
  canbus_uuid: <ВСТАВИТЬ UUID>
  ```  
