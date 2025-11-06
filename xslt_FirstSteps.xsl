<?xml version="1.0" encoding="UTF-8"?>
<!-- This is just a start into how we can use XSLT to make an html document. This finds all of the speeches that have neologisms and displays them. It's simple and doens't have much significance, but it works for our project check in.  -->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="html" html-version="5" omit-xml-declaration="yes"
        include-content-type="no" indent="yes"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <meta charset="utf-8"/>
                <meta name="viewport" content="width=device-width,initial-scale=1"/>
                <link rel="icon" type="image/x-icon" href="images/favicon.ico"/>
                <link rel="stylesheet" href="../CSS/styles.css"/>
                <title>Shakespeare's Neologisms</title>
            </head>
            <body>
                <header style="min-height:unset;width:100%;height:10vh;" class="hero">
                    <div class="subpage-labels">
                        <a href="index.html">HOME</a>
                        <a>ABOUT</a>
                        <a>WORDS</a>
                        <a href="xslt_html.xhtml">CORPUS</a>
                    </div>
                </header>
                <h1>A Midsummer Night’s Dream Passages with Neologisms</h1>
                <xsl:apply-templates select="//sp[descendant::w[@ana='neologism']]"/>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="sp[descendant::w[@ana='neologism']]">
        <p><xsl:apply-templates/></p><br/>
    </xsl:template>
    
    <xsl:template match="w[@ana='neologism']">
        <span style="color:blue;font-weight:bold;"><xsl:apply-templates/></span>
    </xsl:template>
    
    <xsl:template match="speaker[following-sibling::ab[descendant::w[@ana='neologism']]]">
        <h2><xsl:apply-templates/>:</h2>
    </xsl:template>
    
</xsl:stylesheet>