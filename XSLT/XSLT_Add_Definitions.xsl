<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="html"
    version="3.0">
    
    <!-- Path to the definitions XML -->
    <xsl:param name="defs" select="doc('file:///C:/Users/77zap/GitHub/Shakespeare-XML-Analysis/Data/Analysis/neologism_definitions.xml')" />
    
    <!-- Path to folder containing XHTML files -->
    <xsl:param name="html-folder" select="'file:///C:/Users/77zap/GitHub/Shakespeare-XML-Analysis/HTML/output'"/>
    
    <!-- Process every XHTML file in the folder -->
    <xsl:template match="/">
        <xsl:for-each select="collection(concat($html-folder, '?select=*.xhtml'))">
            <!-- Extract the h1 text (the neologism) -->
            <xsl:variable name="word" select="normalize-space(html:h1[1])"/>
            
            <!-- Lookup definition and part of speech (case-insensitive) -->
            <xsl:variable name="def" select="$defs/definitions/entry[word = lower-case($word)]/definition"/>
            <xsl:variable name="pos" select="$defs/definitions/entry[word = lower-case($word)]/pos"/>
            <xsl:message>
                Word in XHTML: <xsl:value-of select="$word"/>
                Definition found: <xsl:value-of select="$def"/>
                Part of Speech: <xsl:value-of select="$pos"/>
            </xsl:message>
            <!-- Write back the updated XHTML file -->
            <xsl:result-document href="{base-uri(.)}" method="xml" indent="yes">
                <xsl:apply-templates select="." mode="copy">
                    <xsl:with-param name="definition" select="$def"/>
                    <xsl:with-param name="pos" select="$pos"/>
                </xsl:apply-templates>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <!-- Identity transform with parameter passing -->
    <xsl:template match="@*|node()" mode="copy">
        <xsl:param name="definition"/>
        <xsl:param name="pos"/>
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="copy">
                <xsl:with-param name="definition" select="$definition"/>
                <xsl:with-param name="pos" select="$pos"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <!-- Replace only the definition paragraph -->
    <xsl:template match="html:p[@class='definition']" mode="copy">
        <xsl:param name="definition"/>
        <xsl:param name="pos"/>
        <html:p class="definition">
            <strong><xsl:value-of select="$pos"/></strong>
            <xsl:text> — </xsl:text>
            <xsl:value-of select="$definition"/>
            <br/>
            <span class="oed-citation">
                The full definition can be viewed here if you search for the word:
                <a href="https://www.oed.com" target="_blank">Oxford English Dictionary</a>
            </span>
        </html:p>
    </xsl:template>
    
</xsl:stylesheet>
