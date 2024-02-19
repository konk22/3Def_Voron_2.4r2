![](https://raw.githubusercontent.com/konk22/opz3_ubuntu_klipper/main/images/watermark800x450.png)  
# Инструкция по настройке и установке Klipper на Orangepi Zero 3 и чистый дистрибутив Ubuntu 22.04  
## Подготовка:  
* Для установки потребуется скачать дистрибутив Ubuntu 22.04 для Orangepi Zero 3:  
  ```
  http://www.orangepi.org/html/hardWare/computerAndMicrocontrollers/service-and-support/Orange-Pi-Zero-3.html
  ```  
* Записать его на SD карту:  
  * Для Windows: с помощью программы ```Rufus``` или ```BalenaEtcher```  
  * Linux или Mac: ```BalenaEtcher```  
    Подробная инструкция: [KlipperWiki](https://klipper.wiki/ru/home/initial/base#prepare_orange_flash)  
* Установить SD карту в Orangepi Zero 3, подключить клавиатуру и монитор (KlipperScreen HDMI)  
  * Подключаем Orangepi Zero 3 к WIFI.  
        Вводим команду: ```nmtui```  
        Выбираем ```Activate a connections```  
        Подключаемся к своей домашней WIFI сети  
        ![](https://raw.githubusercontent.com/konk22/opz3_ubuntu_klipper/main/images/nmtui_1.png)
    
* Клавиатуру можно отключать, она больше не понадобится  
* Подключаемся к Orangepi Zero 3 по SSH с помощью PuTTY  
* Переходим в пользователя root. Пароль ```orangepi```:  
  ```
  su
  ```  
* Меняем пароль для пользователя root:  
  ```
  passwd
  ```  
* Создаем пользователя ```pi```:  
  ```
  sudo adduser pi
  ```  
* Настраиваем права пользователю аналогично пользователя orangepi:  
  ```
  sudo usermod -aG tty,disk,dialout,sudo,audio,video,plugdev,games,users,systemd-journal,input,netdev pi
  ```  
* Меняем пользователя для автовхода. Меняем ```--autologin orangepi``` на ```--autologin pi```:  
  ```
  sudo nano /lib/systemd/system/getty@.service.d/override.conf
  ```  
* Перезагружаем Orangepi Zero 3. Снова подключаемся через SSH с учетными данными ```pi``` и снова переходим в пользователя root:  
  ```
  reboot
  su
  ```  
* Удаляем пользователя ```orangepi```:  
  ```
  sudo killall -9 -u orangepi && sudo deluser --remove-all-files orangepi
  ```  
* Настраиваем поведение sudo. Меняем строку ```%sudo   ALL=(ALL:ALL) ALL``` на строку ```%sudo   ALL=(ALL:ALL) ALL```:  
  ```
  sudo EDITOR=nano visudo
  ```  
* Снова перезагружаем и подключаемся через SSH после перезагрузки под пользователем pi:  
  ```
  reboot
  ```  
* Проверяем удален ли пользователь orangepi. Повторяем процедуру удаления если пользователь удален не полностью:  
  ```
  ls /home
  папки orangepi не должно быть в ответе
  su orangepi
  user orangepi does not exist or the user entry does not contain all the required fields
  ```  
* Отключим китайские репозитории и добавим глобальные:  
  ```
  sudo nano /etc/apt/sources.list
  ```  
* Закоментируем все строки и в конец добавим следующий текст:  
  ```
  deb http://ports.ubuntu.com/ jammy main restricted universe multiverse
  #deb-src http://ports.ubuntu.com/ jammy main restricted universe multiverse

  deb http://ports.ubuntu.com/ jammy-security main restricted universe multiverse
  #deb-src http://ports.ubuntu.com/ jammy-security main restricted universe multiverse

  deb http://ports.ubuntu.com/ jammy-updates main restricted universe multiverse
  #deb-src http://ports.ubuntu.com/ jammy-updates main restricted universe multiverse

  deb http://ports.ubuntu.com/ jammy-backports main restricted universe multiverse
  #deb-src http://ports.ubuntu.com/ jammy-backports main restricted universe multiverse
  ```  
* Отключим китайский репозиторий docker. Закоментируем все записи в файле:  
  ```
  sudo nano /etc/apt/sources.list.d/docker.list
  ```  
* Добавим глобальный репозиторий docker:  
  ```
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  ```  
* Исправить ошибку dnsmasq. Добавим или раскоментируем строку ```bind-interfaces```:  
  ```
  sudo nano /etc/dnsmasq.conf
  ```  
* Обновим систему. Ошибок и предупреждений не должно быть:  
  ```
  sudo apt update && sudo apt dist-upgrade -y
  ```  
* Установим пакеты необходимые для работы KlipperScreen:  
  ```
  sudo apt install xorg xinit xserver-xorg-legacy libjpeg-dev zlib1g-dev python3-pip python3-dev libatlas-base-dev python3-gi-cairo python3-virtualenv gir1.2-gtk-3.0 virtualenv matchbox-keyboard wireless-tools xdotool xinput x11-xserver-utils libopenjp2-7 python3-distutils python3-gi python3-setuptools python3-wheel
  pip3 install vext
  pip3 install vext.gi
  ```  
* Если необходимо, то обновим wiringpi:  
  ```
  sudo apt install --only-upgrade wiringpi
  ```  
* Меняем имя хоста. Я выбрал имя ```Voron```:  
  ```
  hostnamectl set-hostname Voron
  ```  
* Удаляем логотип Ubuntu:  
  ```
  sudo rm /usr/share/plymouth/themes/spinner/bgrt-fallback.png
  sudo rm /usr/share/plymouth/ubuntu-logo.png
  ```  
* Подготавливаем свой логотип в формате png с прозрачным фоном, размер 800x450, изображение должно быть немного выше середины картинки, или копируем его из предложенного примера в домашнюю директорию, а затем перемещаем в директорию темы по умолчанию:  
  ```
  sudo wget https://raw.githubusercontent.com/konk22/opz3_ubuntu_klipper/main/watermark800x450.png 
  sudo cp /home/pi/watermark800x450.png /usr/share/plymouth/themes/spinner/watermark.png
  ```  
* Копируем логотип загрузки системы в директорию plymouth:  
  ```
  sudo cp /home/pi/watermark800x450.png /usr/share/plymouth/ubuntu-logo.png
  ```  
* Обновим конфигурацию Plymouth и initramfs:  
  ```
  sudo update-initramfs -u
  ```  
* Если в процессе загрузки Orangepi Zero 3 необходимо увидеть лог загрузки, то необходимо на клавиатуре нажать F8.  
* Включим boot splash screen. Необходимо заменить ```bootlogo=false``` на ```bootlogo=true``` и в конец файла добавить строку ```extraargs="console=tty3 consoleblank=0 loglevel=1 quiet splash"```:  
  ```
  sudo nano /boot/orangepiEnv.txt
  ```  
* Для правильной работы KlipperScreen необходимо добавить настройку в конфиг xorg:  
  ```
  sudo bash -c "echo needs_root_rights=yes>>/etc/X11/Xwrapper.config"
  ```  
* Перезагружаем:  
  ```
  sudo reboot
  ```  
* Установим git:  
  ```
  sudo apt-get update && sudo apt-get install git -y
  ```  
* Скачиваем Kiauh и переходим в директорию Kiauh:  
  ```
  cd ~ && git clone https://github.com/dw-0/kiauh.git
  ```  
## На этом подготовка дистрибутива Ubuntu для установки Klipper завершена. Переходим к установке настройке Klipper:  
* Запускаем скрипт Kiauh:  
  ```
  ./kiauh/kiauh.sh
  ```  
* Вас встретит следующее окно. Нажимаем ```1```, затем устанавливаем по очереди: Klipper, Moonraker, Mainsail, KlipperScreen, Telegram Bot, Crowsnest, Mobileraker:  
   
  ![](https://raw.githubusercontent.com/konk22/opz3_ubuntu_klipper/main/images/kiauh_1.png)  
    
  ![](https://raw.githubusercontent.com/konk22/opz3_ubuntu_klipper/main/images/kiauh_1.png)  
    
* После установки всех пакетов нажимаем ```B``` и выходим на начальное окно. Оно должно выглядеть так:  
    
  ![](https://raw.githubusercontent.com/konk22/opz3_ubuntu_klipper/main/images/kiauh_3.png)  

## На этом установка Klipper и всех вспомогательных пакетов завершена. Переходим к установке CanBoot и прошивке MKS Monster8v2:  
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
    * Подключаем питание Orangepi Zero 3 к внешнему источнику питания, например зарядка для телефона или повербанк. К сети 220 принтер не подключаем!!!;  
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

* Получаем UUID MKS Monster8v2 и Fly-SB2040. ПРИМЕЧАНИЕ: Команда возвращает UUID только для неинициализарованных MCU в Klipper (printer.cfg):  
  ```
  ~/CanBoot/scripts/flash_can.py -i can0 -q
  ```  
  ![](https://raw.githubusercontent.com/konk22/opz3_ubuntu_klipper/main/images/uuid_msu2.png)  
    
* Для инициализируем MSU в printer.cfg, добавим данные строки:  
  ```
  [mcu]
  canbus_uuid: <ВСТАВИТЬ UUID>

  [mcu sb2040]
  canbus_uuid: <ВСТАВИТЬ UUID>	

  ```  
  
## Переходим к установке CanBoot и прошивке Mellow Fly-SB2040:  
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

* Проверяем раздел ```Настройки->Системная информация``` Mainsail. Должно быть видно ```mcu(stm32f407xx)```, ```mcu sb2040(rp2040)``` и версии прошивок Klipper везде должны быть одинаковые:  

  ![](https://raw.githubusercontent.com/konk22/opz3_ubuntu_klipper/main/images/monitor.png)  

## Настройка завершена.
