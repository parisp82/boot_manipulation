CC = gcc
AR = ar rcv
EXT = a
LIB = libmincrypt.$(EXT)
LIB_OBJS = libmincrypt/sha.o libmincrypt/rsa.o libmincrypt/sha256.o
INC = -I..
RM = rm -f

# Binaries such as these must be
# compiled statically if you wish
# to use them via TWRP through scripts
# such as Anykernel, SickleSwap,
# MyMinds_Kernel_Swap, etc, etc.

# All three binaries will be found in:
# ./mkbootimg/mkbootimg
# ./mkbootimg/unmkbootimg
# ./cpio/mkbootfs


# Run 'make all' to compile all three binaries statically

all: $(LIB_OBJS) mkbootimg/mkbootimg mkbootimg/unmkbootimg cpio/mkbootfs

# The following three for sha.o, rsa.o & sha256.o
# were included due to lack of support with AR
# while compiling on my device. To use AR on a device
# properly then a compatible toolchain is required.

libmincrypt/sha.o: libmincrypt/sha.c
	$(CROSS_COMPILE)$(CC) -o $@ -O3 -c $^ $(INC)

libmincrypt/rsa.o: libmincrypt/rsa.c
	$(CROSS_COMPILE)$(CC) -o $@ -O3 -c $^ $(INC)

libmincrypt/sha256.o: libmincrypt/sha256.c
	$(CROSS_COMPILE)$(CC) -o $@ -O3 -c $^ $(INC)

# Commented out due to lack of support
# with AR while compiling from my phone
#$(LIB): $(LIB_OBJS)
#	 $(CROSS_COMPILE)$(AR) $@ $^

# Use -O3 optimizations when compiling .c source to .o
# This will significantly increase the final build size
# but will also significantly increase their performance.

mkbootimg/mkbootimg.o: mkbootimg/mkbootimg.c
	$(CROSS_COMPILE)$(CC) -o $@ -O3 -c $^

mkbootimg/unmkbootimg.o: mkbootimg/unmkbootimg.c
	$(CROSS_COMPILE)$(CC) -o $@ -O3 -c $^

cpio/mkbootfs.o: cpio/mkbootfs.c
	$(CROSS_COMPILE)$(CC) -o $@ -O3 -c $^

mkbootimg/mkbootimg: mkbootimg/mkbootimg.o
	 $(CROSS_COMPILE)$(CC) -o $@ $^ $(LIB_OBJS) -static

mkbootimg/unmkbootimg: mkbootimg/unmkbootimg.o
	 $(CROSS_COMPILE)$(CC) -o $@ $^ -static

cpio/mkbootfs: cpio/mkbootfs.o
	 $(CROSS_COMPILE)$(CC) -o $@ $^ -I../include -static

# Run 'make clean' to clear directories
# of your previous builds

clean:
	$(RM) mkbootimg/mkbootimg.o mkbootimg/unmkbootimg.o cpio/mkbootfs.o mkbootimg/mkbootimg mkbootimg/unmkbootimg cpio/mkbootfs
	$(RM) libmincrypt.a
	$(RM) $(LIB_OBJS)
	
.PHONY: clean
