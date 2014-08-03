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




#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <libgen.h>



 int mkbootimg_main(int argc, char **argv[]);
 int unmkbootimg_main(int argc, char **argv[]);
 int mkbootfs_main(int argc, char **argv[]);
 int mkbootimg_mt65xx_main(int argc, char **argv[]);
 int main(int argc, char* argv[]) {
    int arg_multicall = 0;
    char *callname;
    goto parse_callname;

parse_callname:
callname = basename(argv[0]);


    if (strcmp(callname, "mkbootimg") == 0) {
        return mkbootimg_main(argc, argv);
    } else if (strcmp(callname, "unmkbootimg") == 0) {
        return unmkbootimg_main(argc, argv);
    } else if (strcmp(callname, "mkbootimg_mt65xx") == 0) {
        return mkbootimg_mt65xx_main(argc, argv);
    } else if (strcmp(callname, "mkbootfs") == 0) {
        return mkbootfs_main(argc, argv);
    } else {
        if (argc < 2 || arg_multicall) {
            printf("Info: Multicall binary for:\n"
                   "* mkbootimg\n"
                   "* unmkbootimg\n"
                   "* mkbootimg_mt65xx\n"
                   "* mkbootfs\n");
            return -1;
        }

        argv = &argv[1];
        argc--;
        arg_multicall = 1;
        goto parse_callname;
    }

    return -1;
}