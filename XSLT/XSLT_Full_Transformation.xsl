<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="3.0">
    
    <!-- Output formatting -->
    <xsl:output method="xml" indent="yes"/>
    
    <!-- 1. Load all Shakespeare XML files -->
    <xsl:variable name="docs"
        select="collection('file:///Users/77zap/Github/Shakespeare-XML-Analysis/shakespeare-xml-only?select=*.xml')"/>
    
    <!-- 2. Load the neologism word list -->
    <xsl:variable name="word-list"
        select="doc('file:///Users/77zap/Github/Shakespeare-XML-Analysis/Data/Original/wordListXML.xml')//w/string()"/>
    
    <!-- 3. Create a single regex alternation pattern -->
    <xsl:variable name="neologism-pattern"
        select="concat('(^|\\b)(', string-join($word-list, '|'), ')(\\b|$)')"/>
    
    <!-- 4. Root template: iterate over each document in the collection -->
    <xsl:template match="/">
        <xsl:for-each select="$docs">
            <!-- Make a unique output filename -->
            <xsl:variable name="relative-path"
                select="replace(base-uri(.), '^.*/shakespeare-xml-only/', '')"/>
            <xsl:variable name="safe-filename"
                select="replace($relative-path, '/', '_')" />
            
            <!-- Write a full transformed copy to the output directory -->
            <xsl:result-document
                href="file:///Users/77zap/Github/Shakespeare-XML-Analysis/shakespeare-marked-up/{$safe-filename}">
                <xsl:apply-templates/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 5. When matching TEI words, mark neologisms -->
    <xsl:template match="tei:w">
        <xsl:variable name="word" select="normalize-space(.)"/>
        <xsl:choose>
            <xsl:when test="matches($word, $neologism-pattern, 'i')">
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
                    <xsl:attribute name="ana">neologism</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- 6. Identity template for all other elements -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
