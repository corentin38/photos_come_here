#! /bin/bash

# Photo importer to shotwell like library
# By default, photos are imported from /media/$USER/disk/DCIM/101MSDCF
# (That's my camera !!!)
# By default, photos are imported to $HOME/images/Photos/$YEAR/$MONTH/$DAY

# man import.sh
# USAGE:
# ./import.sh [-f DIR] [-t LIBRARY_ROOT]

FROM_OPTION="-f"
TO_OPTION="-t"

FROM_VALUE=
TO_VALUE=

for i in $(seq 1 1 $#)
do
    if [ ${!i} == $FROM_OPTION ]
    then
	next=$(($i + 1))
	FROM_VALUE=${!next}
	continue
    fi
    if [ ${!i} == $TO_OPTION ]
    then
	next=$(($i + 1))
	TO_VALUE=${!next}
	continue
    fi

    if [ $(($i % 2)) -eq 1 ]
    then
	echo "Unknown option: ${!i}"
	exit 1
    fi
done

if [ -z $FROM_VALUE ]
then
    FROM_VALUE="/media/$USER/disk/DCIM/101MSDCF"
fi

if [ -z $TO_VALUE ]
then
    TO_VALUE="$HOME/images/Photos"
fi

FROM_VALUE=$(readlink -f $FROM_VALUE)
TO_VALUE=$(readlink -f $TO_VALUE)

echo "======================================================"
echo "Importing from: $FROM_VALUE"
echo "To library: $TO_VALUE"
echo "======================================================"

if [ ! -d $FROM_VALUE ]
then
    echo "Cannot import from <$FROM_VALUE>: folder does not exist or is not a directory"
    exit 1
fi

if [ ! -d $TO_VALUE ]
then
    echo "Cannot import to <$TO_VALUE>: folder does not exist or is not a directory"
    exit 1
fi

for img in $(find $FROM_VALUE -maxdepth 1 -name "*.JPG")
do
    exif_raw=$(exiftool -CreateDate -d "%d/%m/%Y" $img)
    exif_date=$(echo  "$exif_raw" | cut -s -d: -f2 | tr -d ' ')
    year=$(echo  "$exif_date" | cut -d/ -f3)
    month=$(echo  "$exif_date" | cut -d/ -f2)
    day=$(echo  "$exif_date" | cut -d/ -f1)
    echo "Found image <$img> taken on: $day/$month/$year"

    dest="$TO_VALUE/$year/$month/$day"
    if [ ! -d $dest ]
    then
	mkdir -p $dest
    fi

    cp $img $dest
done
