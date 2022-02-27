<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:cmd="http://www.clarin.eu/cmd/1"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:js="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs"
    version="3.0">  
    
    <xsl:template match="text()"/>
    
    <xsl:variable name="profs" as="node()*">
        <prof block="citation" id="clarin.eu:cr1:p_1639731773881"/>
    </xsl:variable>
    
    <xsl:template match="js:map[@key='metadataBlocks']">
        <xsl:variable name="block" select="js:map/@key"/>
        <!--<xsl:message expand-text="yes">block[{$block}]</xsl:message>-->
        <xsl:variable name="prof" select="$profs[@block=$block]/@id"/>
        <!--<xsl:message expand-text="yes">profile[{$prof}]</xsl:message>-->
        <xsl:variable name="ns" select="concat('http://www.clarin.eu/cmd/1/profiles/',$prof)"/>
        <cmd:CMD  xsi:schemaLocation="http://www.clarin.eu/cmd/1 https://catalog.clarin.eu/ds/ComponentRegistry/rest/registry/1.x/profiles/{$prof}/xsd" CMDVersion="1.2">
            <xsl:namespace name="cmdp" select="$ns"/>                    
            <cmd:Header>
                <cmd:MdProfile xsl:expand-text="yes">{$prof}</cmd:MdProfile>
            </cmd:Header>
            <cmd:Resources>
                <cmd:ResourceProxyList/>
                <cmd:JournalFileProxyList/>
                <cmd:ResourceRelationList/>
            </cmd:Resources>
            <cmd:Components>
                <xsl:element name="cmdp:{$block}" namespace="{$ns}">
                    <xsl:apply-templates select="js:map[@key=$block]/js:array[@key='fields']/*">
                        <xsl:with-param name="ns" select="$ns" tunnel="yes"></xsl:with-param>
                    </xsl:apply-templates>
                </xsl:element>
            </cmd:Components>
        </cmd:CMD>
    </xsl:template>
    
    <xsl:template match="js:map[exists(*[@key='value'])][exists(js:string[@key='typeName'])]">
        <xsl:param name="ns" tunnel="yes"/>
        <xsl:choose>
            <xsl:when test="exists(js:string[@key='value'])">
                <!--<xsl:message expand-text="yes">value[{js:string[@key='value']}]</xsl:message>-->
                <xsl:element name="cmdp:{./js:string[@key='typeName']}" namespace="{$ns}" expand-text="yes">{./js:string[@key='value']}</xsl:element>                
            </xsl:when>
            <xsl:when test="exists(js:array[@key='value'])">
                <xsl:element name="cmdp:{./js:string[@key='typeName']}" namespace="{$ns}">
                    <xsl:apply-templates select="js:array[@key='value']/*">
                        <xsl:with-param name="ns" select="$ns" tunnel="yes"></xsl:with-param>
                    </xsl:apply-templates>
                </xsl:element>                
  
            </xsl:when>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>