# ./buildx.sh

clear

if [ $# = 0 ]; then
   echo syntax: ./buildx.sh file [options...]
   exit
fi

echo compiling...
./../../xharbour/bin/harbour $1 -n -I./../include -I./../../xharbour/include $2

echo compiling C module...
gcc $1.c -c -I./../include -I./../../xharbour/include `pkg-config --cflags gtk+-2.0`

echo linking...
gcc $1.o -o$1 -L./../lib -L./../../xharbour/lib `pkg-config --libs gtk+-2.0` `pkg-config --libs libglade-2.0` `pkg-config --libs libgnomeprintui-2.2` -Wl,--start-group -lfivex -lfivec -lcommon -lvm -lrtl -lrdd -lmacro -llang -lcodepage -lpp -ldbfntx -ldbfcdx -ldbffpt -lhbsix -lhsx -lpcrepos -lusrrdd -ltip -lct -lcgi -lgtnul -lgtstd -lgtcgi -lgtcrs -lhbodbc -ldebug -lm -lgpm -lncurses -Wl,--end-group

rm $1.c
rm $1.o

echo done!
./$1
