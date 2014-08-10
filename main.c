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



#define _GNU_SOURCE
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <libgen.h>



 int mkbootimg_main(int argc, char **argv[]);
 int unmkbootimg_main(int argc, char **argv[]);
 int mkbootfs_main(int argc, char **argv[]);
 int mkbootimg_mt65xx_main(int argc, char **argv[]);
 int lz4_main(int argc, char **argv[]);
 int dtbtool_main(int argc, char **argv[]);
 int dtc_main(int argc, char **argv[]);
 int bootimg_info_main(int argc, char **argv[]);
 int shc_main(int argc, char **argv[]);
 int main(int argc, char **argv[]) {
    int arg_multicall = 0;
    char *callname;
    goto parse_callname;

parse_callname:
callname = basename(argv[0]);


    if (strcmp(callname, "mkbootimg") == 0) {
        return mkbootimg_main(argc, argv);
    } else if (strcmp(callname, "unmkbootimg") == 0) {
        return unmkbootimg_main(argc, argv);
    } else if (strcmp(callname, "lz4") == 0) {
        return lz4_main(argc, argv);
    } else if (strcmp(callname, "mkbootimg_mt65xx") == 0) {
        return mkbootimg_mt65xx_main(argc, argv);
    } else if (strcmp(callname, "mkbootfs") == 0) {
        return mkbootfs_main(argc, argv);
    } else if (strcmp(callname, "dtbtool") == 0) {
        return dtbtool_main(argc, argv);
    } else if (strcmp(callname, "dtc") == 0) {
        return dtc_main(argc, argv);
    } else if (strcmp(callname, "bootimg-info") == 0) {
        return bootimg_info_main(argc, argv);
    } else if (strcmp(callname, "shc") == 0) {
        return shc_main(argc, argv);
    } else {
        if (argc < 2 || arg_multicall) {
            printf("\nInfo: Multicall binary for:\n"
                   "* shc\n"
                   "* bootimg-info\n"
                   "* mkbootimg\n"
                   "* unmkbootimg\n"
                   "* mkbootimg_mt65xx\n"
                   "* dtbtool\n"
                   "* dtc (Use with -h option)\n"
                   "* lz4\n"
                   "* mkbootfs\n\n");
            return -1;
        }

        argv = &argv[1];
        argc--;
        arg_multicall = 1;
        goto parse_callname;
    }

    return -1;
}