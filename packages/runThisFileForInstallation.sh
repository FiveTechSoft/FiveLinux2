#!/bin/bash
read -p "Enter the user name you work with on your computer: " nombre
if [ "$nombre" != "" ]
then
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt install openssl -y
    sudo apt install curl -y
    sudo apt install gpm -y
    sudo apt install gcc -y
    sudo apt install git -y
    sudo apt update -y
    sudo apt-get install bash git gcc binutils fakeroot debhelper valgrind upx uncrustify -y
    sudo apt install libc6-dev -y
    sudo apt-get install libncurses-dev -y
    sudo apt-get install libslang2-dev -y
    sudo apt-get install libslang1-dev -y
    sudo apt-get install libx11-dev -y
    sudo apt-get install libgpm-dev -y
    sudo apt-get install libgpmg1-dev -y
    sudo apt-get install liballegro4.2-dev -y
    sudo apt-get install libcairo2-dev y
    sudo apt-get install libcups2-dev -y
    sudo apt-get install libcurl4-openssl-dev -y
    sudo apt-get install libcurl4-gnutls-dev -y
    sudo apt-get install firebird-dev -y
    sudo apt-get install libfirebird2.0-dev -y
    sudo apt-get install firebird2.1-dev -y
    sudo apt-get install libfreeimage-dev -y
    sudo apt-get install libgd2-xpm-dev -y
    sudo apt-get install libgd-xpm-dev -y
    sudo apt-get install libgs-dev -y
    sudo apt-get install libmagic-dev -y
    sudo apt-get install libmysqlclient15-dev -y
    sudo apt-get install unixodbc-dev -y
    sudo apt-get install libpq-dev -y
    sudo apt-get install libqt5-dev
    sudo apt update -y
    sudo apt-get install libbz2-dev -y
    sudo apt-get install zlib1g-dev -y
    sudo apt-get install libpcre3-dev -y
    sudo apt-get install libsqlite3-dev -y
    sudo apt-get install libexpat1-dev -y
    sudo echo ==================================
    sudo echo Please wait, installing Harbour...
    sudo echo ==================================
    cd /home/$nombre
    git clone https://github.com/harbour/core.git harbour-core
    export HB_BUILD_CONTRIBS
    HB_INSTALL_PREFIX=/$home/$nombre/harbour/tests/
    export HB_INSTALL_PREFIX
    HB_WITH_GPM=/usr/lib
    export HB_WITH_GPM
    PATH=$PATH:$HB_INSTALL_PREFIX/bin
    export PATH
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HB_INSTALL_PREFIX/bin
    export LD_LIBRARY_PATH
    mv harbour-core harbour
    cd /home/$nombre/harbour/lib
    ln -s libharbour.so.3.2.0 libharbour.so
    ln -s libharbour.so.3.2.0 libharbour.so.3.2
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt update -y
    cd /home/$nombre/harbour
    export HB_BUILD_CONTRIBS
    sudo make install
    sudo echo ==================================================================
    sudo echo Creating a '.deb' file for possible future installations with the
    sudo echo same configuration...
    sudo echo ==================================================================
    sudo fakeroot debian/rules binary
    cd /home/$nombre/
    sudo dpkg -i harbour_3.2.0-1_amd64.deb
    sudo echo ====================================
    sudo echo Harbour language has been installed.
    sudo echo ====================================
    harbour -build
    sudo echo =====================================
    sudo echo It is advisable to reboot the system.
    sudo echo =====================================
else
    echo "You have not written anything."
    exit  
fi
