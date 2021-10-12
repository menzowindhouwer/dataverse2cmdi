# dataverse json-ld2cmdi

1. turn record json-ld to xml using [js2xml.xsl](../json/js2xml.xsl)]
2. turn the record xml to CMDI using [jsonld2cmdi.xsl](./jsonld2cmdi.xsl)

see [do.sh](./do.sh)

##Issues:

1. In the input there are two Actors, each with their own Age. In the JSON-LD Ages become:

```json
"@id": "https://dataverse.org/schema/cmdi/Actor",
  "https://dataverse.org/schema/cmdi/Age": [
   {
    "@value": "65"
   },
   {
    "@value": "32"
   }
  ]
```

There is currently no way to know which Age belonged to wich Actor.