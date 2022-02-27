<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <xsl:param name="name" select="'testProfile'"/>
    <xsl:param name="vocabs-uri" select="'file:/Users/menzowi/Documents/Projects/CLARIN/CMDI/dataverse2cmdi/json/citation-vocabs.xml'"/>
    <xsl:param name="vocabs-doc" select="doc($vocabs-uri)"/>
    
    <xsl:template name="cardinalities">
        <xsl:choose>
            <xsl:when test="upper-case(elem[normalize-space(@name)='required'])='TRUE'">
                <xsl:attribute name="CardinalityMin" select="'1'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="CardinalityMin" select="'0'"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="upper-case(elem[normalize-space(@name)='allowmultiples'])='TRUE'">
                <xsl:attribute name="CardinalityMax" select="'unbounded'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="CardinalityMax" select="'1'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="vocab">
        <xsl:variable name="field" select="elem[normalize-space(@name)='name']"/>
        <xsl:choose>
            <xsl:when test="upper-case(elem[normalize-space(@name)='allowControlledVocabulary'])='TRUE'">
                <xsl:variable name="vocab" select="$vocabs-doc/TSV/row[normalize-space(elem[normalize-space(@name)='DatasetField'])=$field][normalize-space(elem[normalize-space(@name)='Value'])!='']"/>
                <xsl:if test="exists($vocab)">
                    <ValueScheme>
                        <Vocabulary>
                            <enumeration>
                                <xsl:for-each select="$vocab">
                                    <item>
                                        <xsl:value-of select="normalize-space(elem[normalize-space(@name)='Value'])"/>
                                    </item>
                                </xsl:for-each>
                            </enumeration>
                        </Vocabulary>
                    </ValueScheme>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="ValueScheme" select="'string'"/>
            </xsl:otherwise>
        </xsl:choose>      
    </xsl:template>
    
    <xsl:template match="TSV">
        <xsl:variable name="tsv" select="."/>
        <ComponentSpec isProfile="true" CMDVersion="1.2" CMDOriginalVersion="1.2" xsi:noNamespaceSchemaLocation="https://infra.clarin.eu/CMDI/1.x/xsd/cmd-component.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <Header>
                <ID/>
                <Name xsl:expand-text="yes">{$name}</Name>
                <Description/>
                <Status>development</Status>
            </Header>
            <Component name="{$name}"  CardinalityMin="1" CardinalityMax="1">
                <xsl:for-each select="$tsv/row[normalize-space(elem[normalize-space(@name)='parent'])=''][normalize-space(elem[normalize-space(@name)='fieldType'])!='none']">
                    <Element name="{elem[normalize-space(@name)='name']}">
                        <xsl:call-template name="cardinalities"/>
                        <xsl:call-template name="vocab"/>
                    </Element>
                </xsl:for-each>
                <xsl:for-each select="$tsv/row[normalize-space(elem[normalize-space(@name)='parent'])=''][normalize-space(elem[normalize-space(@name)='fieldType'])='none']">
                    <xsl:variable name="name" select="elem[normalize-space(@name)='name']"/>
                    <Component name="{$name}">
                        <xsl:call-template name="cardinalities"/>
                        <xsl:for-each select="$tsv/row[normalize-space(elem[normalize-space(@name)='parent'])=$name][normalize-space(elem[normalize-space(@name)='fieldType'])!='none']">
                            <Element name="{elem[normalize-space(@name)='name']}" CardinalityMin="1" CardinalityMax="1">
                                <xsl:call-template name="cardinalities"/>
                                <xsl:call-template name="vocab"/>
                            </Element>
                        </xsl:for-each>
                    </Component>
                </xsl:for-each>
            </Component>
        </ComponentSpec>
    </xsl:template>
    
</xsl:stylesheet>