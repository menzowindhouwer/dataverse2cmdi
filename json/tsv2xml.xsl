<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tsv="https://di.huc.knuw.nl/ns/tsv"
    exclude-result-prefixes="xs tsv" version="2.0">

    <xsl:param name="TSV"/>

    <xsl:function name="tsv:getTokens" as="xs:string+">
        <xsl:param name="str" as="xs:string"/>
        <xsl:analyze-string select="concat($str, '\t')" regex='(("[^"]*")+|[^\t]*)\t'>
            <xsl:matching-substring>
                <xsl:sequence select='replace(regex-group(1), "^""|""$|("")""", "$1")'/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:function>

    <xsl:template name="main">
        <xsl:choose>
            <xsl:when test="unparsed-text-available($TSV)">
                <xsl:variable name="tab" select="unparsed-text($TSV)"/>
                <xsl:variable name="lines" select="tokenize($tab, '(\r)?\n')" as="xs:string+"/>
                <xsl:variable name="elemNames" select="tsv:getTokens(replace($lines[1],'^#',''))" as="xs:string+"/>
                <TSV src="{$TSV}">
                    <xsl:for-each select="$lines[position() &gt; 1][normalize-space(.) != '']">
                        <row>
                            <xsl:variable name="lineItems" select="tsv:getTokens(.)" as="xs:string+"/>

                            <xsl:for-each select="$elemNames">
                                <xsl:variable name="pos" select="position()"/>
                                <elem name="{.}">
                                    <xsl:value-of select="$lineItems[$pos]"/>
                                </elem>
                            </xsl:for-each>
                        </row>
                    </xsl:for-each>
                </TSV>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">!ERR: TSV[<xsl:value-of select="$TSV"/>] can't be
                    loaded</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
