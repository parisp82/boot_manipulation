CC = gcc

all:
	$(CC) -O3 -ffunction-sections -static -o bm main.c sha.c rsa.c sha256.c mkbootimg.c nbimg.c unmkbootimg.c mkbootfs.c

clean:
	rm -f ./*.o

.PHONY: clean