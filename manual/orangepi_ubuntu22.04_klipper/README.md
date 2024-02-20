# Инструкция по подготовке дистрибутива Ubuntu 22.04 и установке Klipper на Orangepi Zero 3 

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
* Отключаем ненужные службы для ускорения загрузки. ПРИМЕЧАНИЕ: если используется bluetooth, то ```bluetooth.service``` необходимо удалить из команд:
  ```
  sudo apt-get remove networkd-dispatcher
  sudo systemctl stop systemd-networkd.service dnsmasq.service lircd.service containerd.service bluetooth.service
  sudo systemctl disable systemd-networkd.service dnsmasq.service lircd.service containerd.service bluetooth.service
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
* Запускаем скрипт Kiauh:  
  ```
  ./kiauh/kiauh.sh
  ```  
* Вас встретит следующее окно. Нажимаем ```1```, затем устанавливаем по очереди: Klipper, Moonraker, Mainsail, KlipperScreen, Telegram Bot, Crowsnest, Mobileraker:  
   
  ![](https://raw.githubusercontent.com/konk22/opz3_ubuntu_klipper/main/images/kiauh_1.png)  
    
  ![](https://raw.githubusercontent.com/konk22/opz3_ubuntu_klipper/main/images/kiauh_1.png)  
    
* После установки всех пакетов нажимаем ```B``` и выходим на начальное окно. Оно должно выглядеть так:  
    
  ![](https://raw.githubusercontent.com/konk22/opz3_ubuntu_klipper/main/images/kiauh_3.png)  

* Теперь устанавливаем K-ShakeTune:
  ```
  wget -O - https://raw.githubusercontent.com/Frix-x/klippain-shaketune/main/install.sh | bash
  ```
* Когда будет создан файл конфига ```print.cfg``` в начало файла необходимо будет добавить:
  ```
  [include K-ShakeTune/*.cfg]
  ```
    
## На этом подготовка дистрибутива Ubuntu и установка Klipper завершена.
