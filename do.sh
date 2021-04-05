#!/bin/sh

gcsplit -q -f citation.tsv. citation.tsv '/^#/' '{*}'

xsl -it:main -xsl:js2xml.xsl JS=record.json | xmllint --format - > record.xml

xsl -it:main -xsl:tsv2xml.xsl TSV=citation.tsv.02 | xmllint --format - > citation.xml
