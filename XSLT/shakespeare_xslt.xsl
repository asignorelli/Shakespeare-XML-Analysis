<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    exclude-result-prefixes="xs map"
    version="3.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- Load the neologism list -->
    <xsl:variable name="neologism-map" as="map(xs:string, xs:string)">
        <xsl:map>
            <!-- Create a map entry for each pair in neologisms.xml -->
            <xsl:for-each select="document('neologisms.xml')//map-entry">
                <xsl:map-entry key="lower-case(@find)" select="@replace"/>
            </xsl:for-each>
        </xsl:map>
    </xsl:variable>
    
    <xsl:template match="/">
        <!-- Copy the play XML but modify <w> elements as needed -->
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- Identity transform: copy everything by default -->
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="w">
        <xsl:variable name="word" select="lower-case(normalize-space(.))"/>
        <xsl:choose>
            <xsl:when test="map:contains($neologism-map, $word)">
                <xsl:copy>
                    <xsl:attribute name="ana" select="map:get($neologism-map, $word)"/>
                    <xsl:value-of select="."/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
