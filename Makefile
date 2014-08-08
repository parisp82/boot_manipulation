CC = gcc
STRIP = strip
AR = ar rcv
EXT = a
RELEASE=r120
# These flags are for lz4
LZ4FLAGS = -std=c99 -Wall -Wextra -Wundef -Wshadow -Wstrict-prototypes -DLZ4_VERSION=\"$(RELEASE)\"
CFLAGS = -ffunction-sections -fdata-sections -O3 -static
LDFLAGS = -Wl,--gc-sections
LIB = libmincrypt.$(EXT)
LIB_OBJS = libmincrypt/sha.o libmincrypt/rsa.o libmincrypt/sha256.o
LZ4DIR = lz4-r120
PROGRAMS = lz4-r120/programs
OBJ = main.o mkbootimg/mkbootimg.o mkbootimg/unmkbootimg.o mkbootimg/mkbootimg_mt65xx.o cpio/mkbootfs.o
BINARY = mkbootimg/mkbootimg mkbootimg/unmkbootimg mkbootimg/mkbootimg_mt65xx cpio/mkbootfs
LZ4 = $(LZ4DIR)/lz4.o $(LZ4DIR)/lz4hc.o $(PROGRAMS)/bench.o $(PROGRAMS)/xxhash.o $(PROGRAMS)/lz4io.o $(PROGRAMS)/lz4cli.o
DTTOOLS = dtb/dtbtool.o dtc/dtc.o dtc/flattree.o dtc/fstree.o dtc/data.o dtc/livetree.o dtc/treesource.o dtc/srcpos.o dtc/checks.o dtc/util.o dtc/dtc-lexer.lex.o dtc/dtc-parser.tab.o
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
	$(CC) $(CFLAGS) $(LDFLAGS) -s -o $(BINARY_NAME) $(LIB_OBJS) $(OBJ) $(LZ4) $(DTTOOLS)

# Passing --remove-section=.comment
# and --remove-section=.note to strip
# saved me 0.31% roughly by removing
# many copies of "GCC: (GNU) 4.x.x Y%M%D%"
# which is DEFINITELY unneeded.

	$(STRIP) --remove-section=.comment $(BINARY_NAME)
	$(STRIP) --remove-section=.note $(BINARY_NAME)

# Run 'make all' to compile all three binaries statically

# Deprecated
all: $(LIB_OBJS) $(OBJ) $(BINARY)

# The following three for sha.o, rsa.o & sha256.o
# were included due to lack of support with AR
# while compiling on my device. To use AR on a device
# properly then a compatible toolchain is required.

libmincrypt/sha.o: libmincrypt/sha.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) $(LDFLAGS) -c $^ $(INC)

libmincrypt/rsa.o: libmincrypt/rsa.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) $(LDFLAGS) -c $^ $(INC)

libmincrypt/sha256.o: libmincrypt/sha256.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) $(LDFLAGS) -c $^ $(INC)

# Commented out due to lack of support
# with AR while compiling from my phone
#$(LIB): $(LIB_OBJS)
#	 $(CROSS_COMPILE)$(AR) $@ $^

# Use -O3 optimizations when compiling .c source to .o
# This will significantly increase the final build size
# but will also significantly increase their performance.

main.o: main.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) $(LDFLAGS) -c $^

$(LZ4DIR)/lz4.o: $(LZ4DIR)/lz4.c
	$(CC) $(CFLAGS) $(LZ4FLAGS) $(LDFLAGS) -DDISABLE_LZ4C_LEGACY_OPTIONS  -o $@ -c $^

$(LZ4DIR)/lz4hc.o: $(LZ4DIR)/lz4hc.c
	$(CC) $(CFLAGS) $(LZ4FLAGS) $(LDFLAGS) -DDISABLE_LZ4C_LEGACY_OPTIONS  -o $@ -c $^

$(PROGRAMS)/bench.o: $(PROGRAMS)/bench.c
	$(CC) $(CFLAGS) $(LZ4FLAGS) $(LDFLAGS) -DDISABLE_LZ4C_LEGACY_OPTIONS  -o $@ -c $^

$(PROGRAMS)/xxhash.o: $(PROGRAMS)/xxhash.c
	$(CC) $(CFLAGS) $(LZ4FLAGS) $(LDFLAGS) -DDISABLE_LZ4C_LEGACY_OPTIONS  -o $@ -c $^

$(PROGRAMS)/lz4io.o: $(PROGRAMS)/lz4io.c
	$(CC) $(CFLAGS) $(LZ4FLAGS) $(LDFLAGS) -DDISABLE_LZ4C_LEGACY_OPTIONS  -o $@ -c $^

$(PROGRAMS)/lz4cli.o: $(PROGRAMS)/lz4cli.c
	$(CC) $(CFLAGS) $(LZ4FLAGS) $(LDFLAGS) -DDISABLE_LZ4C_LEGACY_OPTIONS  -o $@ -c $^

mkbootimg/mkbootimg.o: mkbootimg/mkbootimg.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) $(LDFLAGS) -c $^
	
mkbootimg/mkbootimg_mt65xx.o: mkbootimg/mkbootimg_mt65xx.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) $(LDFLAGS) -c $^

mkbootimg/unmkbootimg.o: mkbootimg/unmkbootimg.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) $(LDFLAGS) -c $^

cpio/mkbootfs.o: cpio/mkbootfs.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) $(LDFLAGS) -c $^

dtb/dtbtool.o: dtb/dtbtool.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) $(LDFLAGS) -c $^

dtc/dtc.o: dtc/dtc.c          
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) $(LDFLAGS) -c $^ -Idtc/libfdt

dtc/flattree.o: dtc/flattree.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) $(LDFLAGS) -c $^

dtc/fstree.o: dtc/fstree.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) $(LDFLAGS) -c $^

dtc/data.o: dtc/data.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) $(LDFLAGS) -c $^

dtc/livetree.o: dtc/livetree.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) $(LDFLAGS) -c $^

dtc/treesource.o: dtc/treesource.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) $(LDFLAGS) -c $^

dtc/srcpos.o: dtc/srcpos.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) $(LDFLAGS) -c $^

dtc/checks.o: dtc/checks.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) $(LDFLAGS) -c $^

dtc/util.o: dtc/util.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) $(LDFLAGS) -c $^

dtc/dtc-lexer.lex.o: dtc/dtc-lexer.lex.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) $(LDFLAGS) -c $^

dtc/dtc-parser.tab.o: dtc/dtc-parser.tab.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) $(LDFLAGS) -c $^

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
	
.PHONY: clean