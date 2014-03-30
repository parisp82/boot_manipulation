/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */



#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <stdlib.h>
#include <unistd.h>
#include <ctype.h>
#include <dirent.h>
#include <stdarg.h>
#include <fcntl.h>
#include <getopt.h>
#include "rsa.h"
#include "sha.h"
#include "sha256.h"
#include "bootimg.h"
#include <inttypes.h>
#include "hash-internal.h"





 int mkbootimg(int argc, char *argv[]);
 int unmkbootimg(int argc, char *argv[]);
 int mkbootfs(int argc, char *argv[]);
 int nbimg(int argc, char *argv[]); {
    int arg_multicall = 0;
    char *callname;
    goto parse_callname;

parse_callname:
	callname = basename(argv[0]);

    if (strcmp(callname, "bm_mkbootimg") == 0) {
        return mkbootimg(argc, argv);
    } else if (strcmp(callname, "bm_unmkbootimg") == 0) {
        return unmkbootimg(argc, argv);
    } else if (strcmp(callname, "bm_mkbootfs") == 0) {
        return mkbootfs(argc, argv);
    } else if (strcmp(callname, "bm_nbimg") == 0) {
        return nbimg(argc, argv);
    } else {
        if (argc < 2 || arg_multicall) {
            printf("Info: Multicall binary for:\n"
                   "* bm_mkbootimg\n"
                   "* bm_unmkbootimg\n"
                   "* bm_mkbootfs\n"
                   "* bm_nbimg\n");
            return -1;
        }

        argv = &argv[1];
        argc--;
        arg_multicall = 1;
        goto parse_callname;
    }

    return -1;
}
