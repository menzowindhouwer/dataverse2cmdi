<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:cmd="http://www.clarin.eu/cmd/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:js="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <xsl:variable name="rec" select="/"/>
    
    <xsl:param name="cr-uri" select="'https://catalog.clarin.eu/ds/ComponentRegistry/rest/registry'"/>
    <xsl:param name="cmd-1_1" select="'1.1'"/>
    <xsl:param name="cr-extension-xml" select="'/xml'"/>
    
    <!-- CR REST API -->
    <xsl:variable name="cr-profiles" select="concat($cr-uri,'/',$cmd-1_1,'/profiles')"/>
    
    
    <xsl:template match="text()"/>
    
    <xsl:template match="/">
        <xsl:variable name="profile" select="replace(//js:array[@key='https://dataverse.org/schema/cmdi/xsi:schemaLocation']//js:string[@key='@value'],'.*(clarin.eu:cr1:p_[0-9]+).*','$1')"/>
        
        <xsl:variable name="cr-profile-xml" select="concat($cr-profiles,'/',$profile,$cr-extension-xml)"/>
        <xsl:variable name="prof" select="doc($cr-profile-xml)"/>
        
        <xsl:message expand-text="yes">DBG: profile[{$profile}]</xsl:message>
        <CMD CMDVersion="1.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.clarin.eu/cmd/ http://catalog.clarin.eu/ds/ComponentRegistry/rest/registry/profiles/{$profile}/xsd" xmlns="http://www.clarin.eu/cmd/">
            <Header>
                <MdSelfLink></MdSelfLink>
            </Header>
            <Resources>
                <ResourceProxyList>
                </ResourceProxyList>
                <JournalFileProxyList/>
                <ResourceRelationList/>
            </Resources>
            <Components>
                <xsl:apply-templates select="$prof//CMD_ComponentSpec/CMD_Component"/>
            </Components>
        </CMD>
    </xsl:template>
    
    <xsl:template match="CMD_Component">
        <xsl:variable name="c" select="."/>
        <xsl:message expand-text="yes">DBG:BEGIN:component[{$c/@name}]</xsl:message>
        <xsl:variable name="elements" select="$rec//js:map[js:string[@key='@id']=concat('https://dataverse.org/schema/cmdi/',$c/@name)]"/>
        <xsl:variable name="components" select="$rec//js:array[@key=concat('https://dataverse.org/schema/cmdi/',$c/@name)]"/>
        <xsl:message expand-text="yes">DBG:BEGIN:elements[{exists($elements)}]</xsl:message>
        <xsl:message expand-text="yes">DBG:BEGIN:components[{exists($components)}]</xsl:message>
        <xsl:if test="exists($elements) or exists($components)">
            <xsl:element name="cmd:{$c/@name}">
                <xsl:apply-templates  select="CMD_Element">
                    <xsl:with-param name="elements" select="$elements" tunnel="yes"/>
                </xsl:apply-templates>
                <xsl:apply-templates  select="CMD_Component"/>
            </xsl:element>
        </xsl:if>
        <xsl:message expand-text="yes">DBG: END :component[{$c/@name}]</xsl:message>
    </xsl:template>

    <xsl:template match="CMD_Element">
        <xsl:param name="elements" select="()" tunnel="yes"/>
        <xsl:variable name="e" select="."/>
        <xsl:message expand-text="yes">DBG:BEGIN:element[{$e/@name}]</xsl:message>
        <xsl:for-each select="$elements/js:array[@key=concat('https://dataverse.org/schema/cmdi/',$e/@name)]">
            <xsl:variable name="val" select=".//js:string[@key='@value']"/>
            <xsl:element name="cmd:{$e/@name}">
                <xsl:value-of select="$val"/>
                <xsl:message expand-text="yes">DBG: END :element[{$e/@name}]</xsl:message>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
 
</xsl:stylesheet>