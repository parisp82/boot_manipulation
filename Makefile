all: main.o sha.o rsa.o sha256.o mkbootimg.o nbimg.o unmkbootimg.o
	$(CC) -o multibinary main.o sha.o rsa.o sha256.o mkbootimg.o nbimg.o unmkbootimg.o


sha.o: sha.c
	$(CC) -o sha.o -c sha.c

rsa.o: rsa.c
	$(CC) -o rsa.o -c rsa.c

sha256.o: sha256.c
	$(CC) -o sha256.o -c sha256.c

nbimg.o: nbimg.c
	$(CC) -o nbimg.o -c nbimg.c

unmkbootimg.o: unmkbootimg.c
	$(CC) -o unmkbootimg.o -c unmkbootimg.c

mkbootimg.o: mkbootimg.c
	$(CC) -o mkbootimg.o -c mkbootimg.c

main.o: main.c
	$(CC) -o main.o -c main.c

clean:
	rm -f ./*.o

.PHONY: clean