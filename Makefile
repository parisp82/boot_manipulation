CFLAGS  += -Iinclude
CC = gcc
AR = ar rcv
EXT = a
LIB = libmincrypt.$(EXT)
LIB_OBJS = libmincrypt/sha.o libmincrypt/rsa.o libmincrypt/sha256.o
INC = -I..
RM = rm -f

all: $(LIB) mkbootimg/mkbootimg mkbootimg/unmkbootimg cpio/mkbootfs

$(LIB):$(LIB_OBJS)
	$(AR) $@ $^

%.o:%.c
	$(CC) -o $@ -c $^ $(INC)

mkbootimg/mkbootimg: mkbootimg/mkbootimg.o
	$(CC) -o $@ $^ -L. -lmincrypt -static

mkbootimg/unmkbootimg: mkbootimg/unmkbootimg.o
	$(CC) -o $@ $^ -static

cpio/mkbootfs: cpio/mkbootfs.o
	$(CC) -o $@ $^ -static

clean:
	$(RM) mkbootimg/mkbootimg.o mkbootimg/unmkbootimg.o cpio/mkbootfs.o mkbootimg/mkbootimg mkbootimg/unmkbootimg cpio/mkbootfs
	$(RM) libmincrypt.a
	$(RM) $(LIB_OBJS)
	
.PHONY: clean
