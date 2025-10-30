<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    exclude-result-prefixes="xs map"
    version="3.0">

    <xsl:output method="html" indent="yes"/>

    <!-- Load the neologism list -->
    <xsl:variable name="neologism-map" as="map(xs:string, xs:string)">
        <xsl:map>
            <xsl:for-each select="document('neologisms.xml')//map-entry">
                <xsl:map-entry key="lower-case(@find)" select="@replace"/>
            </xsl:for-each>
        </xsl:map>
    </xsl:variable>

    <!-- Match the root TEI element -->
    <xsl:template match="/tei:TEI">
        <html>
            <head>
                <title>
                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
                </title>
            </head>
            <body>
                <h1>
                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
                </h1>
                <p>
                    Author: <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author"/>
                </p>
                <p>
                    Editors: 
                    <xsl:for-each select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor">
                        <xsl:value-of select="."/>
                        <xsl:if test="position() != last()">, </xsl:if>
                    </xsl:for-each>
                </p>

                <!-- Transform words -->
                <div>
                    <xsl:apply-templates select="//tei:w"/>
                </div>
            </body>
        </html>
    </xsl:template>

    <!-- Transform <w> elements with neologism map -->
    <xsl:template match="tei:w">
        <xsl:variable name="word" select="lower-case(normalize-space(.))"/>
        <span>
            <xsl:choose>
                <xsl:when test="map:contains($neologism-map, $word)">
                    <xsl:attribute name="ana" select="map:get($neologism-map, $word)"/>
                    <xsl:value-of select="."/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text> </xsl:text> <!-- add space between words -->
        </span>
    </xsl:template>

</xsl:stylesheet>
