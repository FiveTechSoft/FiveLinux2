# ./build.sh

clear

if [ $# = 0 ]; then
   echo syntax: ./build.sh file [options...]
   exit
fi

echo compiling...
./../../harbour/bin/linux/gcc/harbour $1 -n -I./../include -I./../../harbour/include $2

echo compiling C module...
gcc $1.c -c -I./../include -I./../../harbour/include `pkg-config --cflags gtk+-2.0`

echo linking...
gcc $1.o -o$1 -L./../lib -L./../../harbour/lib/linux/gcc `pkg-config --libs libgnomeprintui-2.2` -Wl,--start-group -lfive -lfivec -lhbcommon -lhbvm -lhbrtl -lhbrdd -lhbmacro -lhblang -lhbcpage -lhbpp -lhbcplr -lrddntx -lrddcdx -lrddfpt -lhbsix -lhbusrrdd -lhbct -lgttrm -lhbdebug -lm -lncurses `pkg-config --libs gtk+-2.0` `pkg-config --libs libglade-2.0` -Wl,--end-group

rm $1.c
rm $1.o

echo done!
./$1
