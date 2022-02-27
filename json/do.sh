#!/bin/sh

gcsplit -q -f citation.tsv. citation.tsv '/^#/' '{*}'
../bin/xsl.sh -it:main -xsl:tsv2xml.xsl TSV=citation.tsv.02 | xmllint --format - > citation.xml
../bin/xsl.sh -it:main -xsl:tsv2xml.xsl TSV=citation.tsv.03 | xmllint --format - > citation-vocabs.xml

../bin/xsl.sh -it:main -xsl:js2xml.xsl JS=record.json | xmllint --format - > record.xml
../bin/xsl.sh -xsl:json2cmdi.xsl -s:record.xml | xmllint --format - > record.cmdi

../bin/xsl.sh -xsl:xml2prof.xsl -s:citation.xml +vocab-doc=citation-vocabs.xml name=citationProfile | xmllint --format - > citationProfile.xml