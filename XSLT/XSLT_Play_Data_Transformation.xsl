<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="3.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- Load all marked-up plays -->
    <xsl:variable name="docs"
        select="collection('file:///Users/77zap/Github/Shakespeare-XML-Analysis/shakespeare-neo-and-newDef?select=*.xml')"/>
    
    <!-- Main template -->
    <xsl:template match="/">
        <xsl:for-each select="$docs">
            
            <xsl:variable name="raw-title" select="//tei:titleStmt/tei:title"/>
            <xsl:variable name="safe-title"
                select="
                replace(
                replace(
                replace(normalize-space($raw-title), '’', ''''),
                '‘', ''''),
                ' ', '_')
                "/>
            
            <!-- Then use your new safe title here -->
            <xsl:variable name="output-filename"
                select="concat('/Users/77zap/Github/Shakespeare-XML-Analysis/Data/Analysis/individual_plays/', $safe-title, '.xml')"/>
            
            <!-- Collect all neologisms from this play -->
            <xsl:variable name="neos"
                select="for $w in .//tei:w[@ana='neologism']
                return lower-case(normalize-space(string($w)))"/>thi
            
            <!-- Output file for this play -->
            <xsl:result-document
                href="{$output-filename}">
                
                <play name="{$safe-title}">
                    <xsl:for-each select="distinct-values($neos)">
                        <xsl:sort select="count($neos[. = current()])"
                            data-type="number" order="descending"/>
                        <w n="{count($neos[. = current()])}">
                            <xsl:value-of select="."/>
                        </w>
                    </xsl:for-each>
                </play>
                
            </xsl:result-document>
            
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
