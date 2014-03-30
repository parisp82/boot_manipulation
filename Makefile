CFLAGS  += -Wall -Wextra -Wno-unused-parameter -pedantic -pipe
CFLAGS  += -std=c99 -D_GNU_SOURCE
CFLAGS  += -Iinclude

bin: rsa.o sha.o sha256.o mkbootimg.o unmkbootimg.o mkbootfs.o nbimg.o buildit.o
	gcc rsa.o sha.o sha256.o mkbootimg.o unmkbootimg.o nbimg.o main.o -o multibinary

rsa: rsa.c
	gcc -c rsa.c
	
sha: sha.c
	gcc -c sha.c
	
sha256: sha256.c
	gcc -c sha256.c

unmkbootimg: unmkbootimg.c
	gcc -c unmkbootimg.c

mkbootimg: mkbootimg.c
	gcc -c mkbootimg.c
	
mkbootfs: mkbootfs.c
	gcc -c mkbootfs.c
	
nbimg: nbimg.c
	gcc -c nbimg.c

main: main.c
	gcc -c main.c

clean:
	rm -f **/*.o

.PHONY: clean