boot_manipulation
=================

The ability to unpack, edit, and repack your daily boot.img and recovery.img straight from your device.

Based on the original Android bootimg tools which can be found from:
  https://android.googlesource.com/platform/system/core
  
Development
===========

The purpose for this branch is to successfully take multiple sources and compile them all in to one binary (I was successful AS of July 3, 2014). 

Simply put, main.c is merely used to compare strings and if they are a match then to redirect itself by returning to a specified "main" definition of that given source.

An example would be with unmkbootimg.c and main.c:

Inside unmkbootimg.c I changed "int main()" to "unmkbootimg_main()", preventing clashes with "multiple main definitions" while compiling, then hardcoded a string inside main.c in order for "unmmkbootimg_main()"to be successfully called. This string in this case would be, "unmkbootimg". If any other string was to be read then it would simply print off to the screen some helpful information.

This is a very basic concept and it is a method you see with busybox (only more complex). With more playing around you could create your very own multi call binary with tools of your choosing.

With That Said
==============

This branch really serves no other purpose other than to demonstrate how it is done by simply reviewing what is on here.