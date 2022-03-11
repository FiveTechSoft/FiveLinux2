cd ~
sudo apt update -y
sudo apt upgrade -y
sudo apt install gpm -y
sudo apt install gcc -y
sudo apt install git -y
git clone https://github.com/harbour/core.git harbour-core
sudo apt update -y
sudo apt-get install bash git gcc binutils fakeroot debhelper valgrind upx uncrustify -y
sudo apt install libc6-dev -y
sudo apt-get install libncurses-dev -y
sudo apt-get install libslang2-dev -y
sudo apt-get install libx11-dev -y
sudo apt-get install libgpm-dev -y
sudo apt-get install libgpmg1-dev -y
sudo apt-get install liballegro4.2-dev -y
sudo apt-get install libcairo2-dev y
sudo apt-get install libcups2-dev -y
sudo apt-get install libcurl4-openssl-dev -y
sudo apt-get install libcurl4-gnutls-dev -y
sudo apt-get install firebird-dev -y
sudo apt-get install libfreeimage-dev -y
sudo apt-get install libgs-dev -y
sudo apt-get install libmagic-dev -y
sudo apt-get install unixodbc-dev -y
sudo apt-get install libpq-dev -y
sudo apt update -y
sudo apt-get install libbz2-dev -y
sudo apt-get install zlib1g-dev -y
sudo apt-get install libpcre3-dev -y
sudo apt-get install libsqlite3-dev -y
sudo apt-get install libexpat1-dev -y
HB_INSTALL_PREFIX=/home/userName/harbour/tests/
export HB_INSTALL_PREFIX
HB_WITH_GPM=/usr/lib
export HB_WITH_GPM
PATH=$PATH:$HB_INSTALL_PREFIX/bin
export PATH
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HB_INSTALL_PREFIX/bin
export LD_LIBRARY_PATH
mv harbour-core harbour
cd harbour/lib
ln -s libharbour.so.3.2.0 libharbour.so
ln -s libharbour.so.3.2.0 libharbour.so.3.2
cd ..
sudo apt update
sudo make install
sudo reboot

