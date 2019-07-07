#!/bin/sh

# Insert your appname here:
MYAPPNAME="APPNAME"


find APPNAME -type f -exec perl -i -lpE "s/APPNAME/$MYAPPNAME/g" {} \;
find APPNAME/* -depth -name "*APPNAME*" -exec perl -E '($s,$re)=@ARGV;$_=$s;if(s{APPNAME(?=[^/]*$)}{$re}s){ rename $s,$_ or die "$s => $_: $!" }' {} $MYAPPNAME \;
mv APPNAME $MYAPPNAME
