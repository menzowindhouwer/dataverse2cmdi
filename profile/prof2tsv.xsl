<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:dv="https://dataverse.org/"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <xsl:output method="text" encoding="UTF-8"/>
    
    <xsl:variable name="REC" select="system-property('line.separator')"/>
    <xsl:variable name="FLD" select="'&#x09;'"/>
    
    <xsl:function name="dv:fieldType" as="xs:string">
        <xsl:param name="type" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="$type='string'">
                <xsl:sequence select="'text'"/>
            </xsl:when>
            <xsl:when test="$type='anyURI'">
                <xsl:sequence select="'uri'"/>
            </xsl:when>
            <xsl:when test="$type='date'">
                <xsl:sequence select="'date'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="'text'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:template match="text()"/>
    
    <xsl:template match="ComponentSpec">
        <!-- header -->
        <xsl:text expand-text="yes">#metadataBlock{$FLD}name{$FLD}dataverseAlias{$FLD}displayName{$FLD}CMDIProfile{$REC}</xsl:text>												
        <xsl:text expand-text="yes">{$FLD}{Header/Name}{$FLD}{$FLD}{Header/Name}Metadata{$FLD}{Header/ID}{$REC}</xsl:text>
        <!-- profile -->
        <xsl:text expand-text="yes">#datasetField{$FLD}name{$FLD}title{$FLD}description{$FLD}watermark{$FLD}fieldType{$FLD}displayOrder{$FLD}displayFormat{$FLD}advancedSearchField{$FLD}allowControlledVocabulary{$FLD}allowmultiples{$FLD}facetable{$FLD}showabovefold{$FLD}required{$FLD}parent{$FLD}metadatablock_id{$FLD}conceptURI{$REC}</xsl:text>
        <xsl:apply-templates select="Component/*"/>
        <!-- vocabs -->
        <xsl:text expand-text="yes">#controlledVocabulary{$FLD}DatasetField{$FLD}Value{$FLD}identifier{$FLD}displayOrder{$FLD}conceptURI{$REC}</xsl:text>
        <xsl:apply-templates select=".//Vocabulary"/>
    </xsl:template>
    
    <xsl:template match="Component">
        <xsl:text expand-text="yes"><!--#datasetField-->{$FLD}<!--name-->{@name}{$FLD}<!--title-->{@name}{$FLD}<!--description-->{$FLD}<!--watermark-->{$FLD}<!--fieldType-->none{$FLD}<!--displayOrder-->{count(preceding-sibling::*) + 1}{$FLD}<!--displayFormat-->{$FLD}<!--advancedSearchField-->FALSE{$FLD}<!--allowControlledVocabulary-->FALSE{$FLD}<!--allowmultiples-->{if (number(@CardinalityMax) gt 1) then ('TRUE') else ('FALSE')}{$FLD}<!--facetable-->FALSE{$FLD}<!--showabovefold-->FALSE{$FLD}<!--required-->{if (number(@CardinalityMin) ge 1) then ('TRUE') else ('FALSE')}{$FLD}<!--parent-->{parent::Component[empty(parent::ComponentSpec)]/@name}{$FLD}<!--metadatablock_id-->{/ComponentSpec/Header/Name}{$FLD}<!--conceptURI-->{@ConceptLink}{$REC}</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="Element">
        <xsl:text expand-text="yes"><!--#datasetField-->{$FLD}<!--name-->{@name}{$FLD}<!--title-->{@name}{$FLD}<!--description-->{$FLD}<!--watermark-->{$FLD}<!--fieldType-->{dv:fieldType((ValueScheme,'string')[1])}{$FLD}<!--displayOrder-->{count(preceding-sibling::*) + 1}{$FLD}<!--displayFormat-->{$FLD}<!--advancedSearchField-->FALSE{$FLD}<!--allowControlledVocabulary-->{if (exists(ValueScheme/Vocabulary)) then ('TRUE') else('FALSE')}{$FLD}<!--allowmultiples-->{if (number(@CardinalityMax) gt 1) then ('TRUE') else ('FALSE')}{$FLD}<!--facetable-->FALSE{$FLD}<!--showabovefold-->FALSE{$FLD}<!--required-->{if (number(@CardinalityMin) ge 1) then ('TRUE') else ('FALSE')}{$FLD}<!--parent-->{parent::Component[empty(parent::ComponentSpec)]/@name}{$FLD}<!--metadatablock_id-->{/ComponentSpec/Header/Name}{$FLD}<!--conceptURI-->{@ConceptLink}{$REC}</xsl:text>
    </xsl:template>
    
    <xsl:template match="Vocabulary">
        <xsl:for-each select="enumeration/item">
            <xsl:text expand-text="yes"><!--#controlledVocabulary-->{$FLD}<!--DatasetField-->{ancestor::Element/@name}{$FLD}<!--Value-->{(@AppInfo,.)[1]}{$FLD}<!--identifier-->{.}{$FLD}<!--displayOrder-->{position()}{$FLD}<!--conceptURI-->{@ConceptLink}{$REC}</xsl:text>    
        </xsl:for-each>    
    </xsl:template>
    
</xsl:stylesheet>