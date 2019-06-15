#!/bin/sh

# Insert your appname here:
MYAPPNAME="APPNAME"

find APPNAME -type f -exec sed -i "s/APPNAME/$MYAPPNAME/g" {} \;
find APPNAME/ -depth -name "*APPNAME*" -exec rename -v APPNAME $MYAPPNAME {} \;
mv APPNAME $MYAPPNAME
