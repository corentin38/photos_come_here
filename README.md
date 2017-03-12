# Hello !

Import.sh is a basic script to import photos from a directory (usually
a camera sdcard) to another, containing photos in subdirectories
representing their creation date.

    /home/user/photo
    +-- 2017
        +-- 02
            +-- 02
                +-- DSC02959.JPG
        +-- 03
            +-- 11
                +-- DSC02986.JPG

# Get started

Test the program with

     $ ./import.sh -f . -t photos

# Problems

Default values for import and library directories might not be
suitable for your case.