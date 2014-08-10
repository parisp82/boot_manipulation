CC = gcc
STRIP = strip
AR = ar rcv
EXT = a
RELEASE=r120

CFLAGS = -O3 -static
LDFLAGS = -ffunction-sections -fdata-sections -Wl,--gc-sections

# These flags are for lz4
LZ4FLAGS = -std=c99 -Wall -Wextra -Wundef -Wshadow -Wstrict-prototypes -DLZ4_VERSION=\"$(RELEASE)\"

LZ4DIR = lz4-r120

PROGRAMS = lz4-r120/programs

LIB_OBJS = libmincrypt/sha.o libmincrypt/rsa.o libmincrypt/sha256.o libmincrypt/dsa_sig.o libmincrypt/p256.o libmincrypt/p256_ec.o libmincrypt/p256_ecdsa.o

OBJ = main.o mkbootimg/mkbootimg.o mkbootimg/unmkbootimg.o mkbootimg/mkbootimg_mt65xx.o cpio/mkbootfs.o mkbootimg/bootimg-info.o

LZ4 = $(LZ4DIR)/lz4.o $(LZ4DIR)/lz4hc.o $(PROGRAMS)/bench.o $(PROGRAMS)/xxhash.o $(PROGRAMS)/lz4io.o $(PROGRAMS)/lz4cli.o

DTTOOLS = dtb/dtbtool.o dtc/dtc.o dtc/flattree.o dtc/fstree.o dtc/data.o dtc/livetree.o dtc/treesource.o dtc/srcpos.o dtc/checks.o dtc/util.o dtc/dtc-lexer.lex.o dtc/dtc-parser.tab.o

# A generic script compiler
SHC = shc-3.8.9/shc-3.8.9.o

INC = -I..
RM = rm -f
BINARY_NAME = bm

# Binaries such as these must be
# compiled statically if you wish
# to use them via TWRP through scripts
# such as Anykernel, SickleSwap,
# MyMinds_Kernel_Swap, etc, etc.


# Run "make multi" to build a multi call binary

multi:
	 make $(LIB_OBJS)
	 make $(OBJ)
	 make $(LZ4)
	 make $(DTTOOLS)
	 make $(SHC)
	$(CC) $(CFLAGS) $(LDFLAGS) -s -o $(BINARY_NAME) $(LIB_OBJS) $(OBJ) $(LZ4) $(DTTOOLS) $(SHC)

# Passing --remove-section=.comment
# and --remove-section=.note to strip
# saved me 0.31% roughly by removing
# many copies of "GCC: (GNU) 4.x.x Y%M%D%"
# which is DEFINITELY unneeded.

	$(STRIP) --remove-section=.comment $(BINARY_NAME)
	$(STRIP) --remove-section=.note $(BINARY_NAME)

# This is here to stop the makefile - ignore the error it reports.
	 exit 0



libmincrypt/sha.o: libmincrypt/sha.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^ $(INC)

libmincrypt/rsa.o: libmincrypt/rsa.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^ $(INC)

libmincrypt/sha256.o: libmincrypt/sha256.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^ $(INC)

libmincrypt/dsa_sig.o: libmincrypt/dsa_sig.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^ $(INC)

libmincrypt/p256.o: libmincrypt/p256.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^ $(INC)

libmincrypt/p256_ec.o: libmincrypt/p256_ec.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^ $(INC)

libmincrypt/p256_ecdsa.o: libmincrypt/p256_ecdsa.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^ $(INC)

# Use -O3 optimizations when compiling .c source to .o
# This will significantly increase the final build size
# but will also significantly increase their performance.

main.o: main.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^

$(LZ4DIR)/lz4.o: $(LZ4DIR)/lz4.c
	$(CC) $(CFLAGS) $(LZ4FLAGS) -DDISABLE_LZ4C_LEGACY_OPTIONS  -o $@ -c $^

$(LZ4DIR)/lz4hc.o: $(LZ4DIR)/lz4hc.c
	$(CC) $(CFLAGS) $(LZ4FLAGS) -DDISABLE_LZ4C_LEGACY_OPTIONS  -o $@ -c $^

$(PROGRAMS)/bench.o: $(PROGRAMS)/bench.c
	$(CC) $(CFLAGS) $(LZ4FLAGS) -DDISABLE_LZ4C_LEGACY_OPTIONS  -o $@ -c $^

$(PROGRAMS)/xxhash.o: $(PROGRAMS)/xxhash.c
	$(CC) $(CFLAGS) $(LZ4FLAGS) -DDISABLE_LZ4C_LEGACY_OPTIONS  -o $@ -c $^

$(PROGRAMS)/lz4io.o: $(PROGRAMS)/lz4io.c
	$(CC) $(CFLAGS) $(LZ4FLAGS) -DDISABLE_LZ4C_LEGACY_OPTIONS  -o $@ -c $^

$(PROGRAMS)/lz4cli.o: $(PROGRAMS)/lz4cli.c
	$(CC) $(CFLAGS) $(LZ4FLAGS) -DDISABLE_LZ4C_LEGACY_OPTIONS  -o $@ -c $^

mkbootimg/bootimg-info.o: mkbootimg/bootimg-info.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^

mkbootimg/mkbootimg.o: mkbootimg/mkbootimg.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^
	
mkbootimg/mkbootimg_mt65xx.o: mkbootimg/mkbootimg_mt65xx.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^

mkbootimg/unmkbootimg.o: mkbootimg/unmkbootimg.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^

cpio/mkbootfs.o: cpio/mkbootfs.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^

dtb/dtbtool.o: dtb/dtbtool.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^

dtc/dtc.o: dtc/dtc.c          
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^ -Idtc/libfdt

dtc/flattree.o: dtc/flattree.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^

dtc/fstree.o: dtc/fstree.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^

dtc/data.o: dtc/data.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^

dtc/livetree.o: dtc/livetree.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^

dtc/treesource.o: dtc/treesource.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^

dtc/srcpos.o: dtc/srcpos.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^

dtc/checks.o: dtc/checks.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^

dtc/util.o: dtc/util.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^

dtc/dtc-lexer.lex.o: dtc/dtc-lexer.lex.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^

dtc/dtc-parser.tab.o: dtc/dtc-parser.tab.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^

shc-3.8.9/shc-3.8.9.o: shc-3.8.9/shc-3.8.9.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $^

# You should always run strip --strip-all
# or you can apply '-s' as seen above
# on the final executable (assuming that
# you don't care about symbol
# informations): this alone usually gives a
# 20-30% improvement on final build size.


# Run 'make clean' to clear directories
# of your previous builds

clean:
	$(RM) $(OBJ)
	$(RM) $(BINARY)
	$(RM) libmincrypt.a
	$(RM) $(LIB_OBJS)
	$(RM) $(BINARY_NAME)
	$(RM) $(LZ4)
	$(RM) $(DTTOOLS)
	$(RM) $(SHC)
	
.PHONY: clean