# dataverse json2cmdi
 
[record.json](https://dataverse.nl/api/datasets/export?exporter=dataverse_json&persistentId=doi%3A10.34894/GGMA4T)

[citation.tsv](https://raw.githubusercontent.com/IQSS/dataverse/v4.3/scripts/api/data/metadatablocks/citation.tsv)

1. turn the record json into xml using [js2xml.xsl](./js2xml.xsl)
2. turn the citation block tsv into xml using [tsv2xml.xsl](./tsv2xml.xsl)
3. turn the record xml to CMDI using [json2cmdi.xsl](./json2cmdi.xsl)

see [do.sh](./do.sh)