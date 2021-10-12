#!/bin/sh

../bin/xsl.sh -it:main -xsl:../json/js2xml.xsl JS=$PWD/record.jsonld | xmllint --format - > record.xml
../bin/xsl.sh -xsl:jsonld2cmdi.xsl -s:record.xml | xmllint --format - > record.cmdi

