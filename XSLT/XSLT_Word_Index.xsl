<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="3.0">
    <!-- Output settings for main index -->
    <xsl:output method="html" indent="yes" />
    <xsl:param name="play-folder" as="xs:string" 
        select="'../shakespeare-neo-and-newDef'"/>
   
    <!-- MAIN TEMPLATE: produces wordIndex.html -->
    <xsl:template match="/frequency">
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                    <meta name="viewport" content="width=device-width,initial-scale=1"/>
                        <title>Shakespeare's Neologisms</title>
                        <link rel="icon" type="image/x-icon" href="images/favicon.ico"/>
                            <link rel="stylesheet" href="../CSS/styles.css"/>
                <script src="https://d3js.org/d3.v7.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/d3-cloud/1.2.7/d3.cloud.min.js"></script>
                
            </head>
            <body>
                <div class="subpage-labels">
                    <a href="index.html">HOME</a>
                    <a href="about.html">ABOUT</a>
                    <a href="play-index.html">CORPUS</a>
                    <div class="dropdown">
                        <button onclick="myFunction()" class="dropbtn">ANALYSIS</button>
                        <div id="myDropdown" class="dropdown-content">
                            <a href="newDef.html">New Definitions</a>
                            <a href="words.html">Frequency</a></div>
                    </div>
                </div>
                
                <section class="about" style="padding-top: 100px; padding-bottom: 0;">
                    <div class="container">
                        <h2 class="word-title">NEOLOGISMS</h2>
                        <p class="word-description-big">
                            So which neologisms are used most prevalently throughout Shakespeare's works? 
                        </p>
                        <p class="word-description">
                            Below is a word cloud visualization representing the frequency of Shakespeare's neologisms across his entire corpus. 
                            The size of each word corresponds to how often it appears in his plays and sonnets.
                        </p>
                    </div>
                </section>
                
                <div id="word-cloud"></div>
                <p class="word-description">
                    Here is the full list of all of the neologisms. Click on each one to learn more. 
                </p>
                <div class="word-search">
                    <ul>
                    <xsl:for-each select="w">
                        
                        <xsl:sort select="@n" order="descending" data-type="number"/>
                        
                        <xsl:variable name="word" select="."/>
                            
                                <li><a href="{concat('neologisms/', $word, '.html')}"><xsl:value-of select="$word"/></a></li>
                        
                        <!-- Generate individual HTML page for each word -->
                        <xsl:result-document href="file:///C:/Users/77zap/GitHub/Shakespeare-XML-Analysis/HTML/neologisms/{concat($word,'.html')}" method="html">
                            <html>
                                <head>
                                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                                    <meta name="viewport" content="width=device-width,initial-scale=1"/>
                                    <title>Shakespeare's Neologisms</title>
                                    <link rel="icon" type="image/x-icon" href="images/favicon.ico"/>
                                    <link rel="stylesheet" href="../../CSS/styles.css"/>
                                </head>
                                <body>
                                    
                                    <div class="subpage-labels"><a href="../index.html">HOME</a><a href="../about.html">ABOUT</a><a href="../play-index.html">CORPUS</a><div class="dropdown"><button onclick="myFunction()" class="dropbtn">ANALYSIS</button><div id="myDropdown" class="dropdown-content"><a href="../newDef.html">New Definitions</a><a href="../words.html">Frequency</a></div>
                                    </div>
                                    </div>
                                    <div class="word-info">
                                        <h1><xsl:value-of select="$word"/></h1>
                                    <h2>Shakespearean Definition: </h2>
                                    <!-- Placeholder to be filled by LLM -->
                                    <p class="definition">[Definition will go here]</p>
                                    <p>Frequency:
                                            <xsl:value-of select="@n"/>
                                    </p>
                                    <p>Here are all of the speeches where <xsl:value-of select="$word"/> shows up across the corpus:</p>
                                    </div>
                                    <script src="../../JavaScript/script.js"></script>
                                    <xsl:for-each select="collection(concat($play-folder, '/?select=*.xml'))">
                                        <xsl:variable name="speech" select=".//tei:sp[descendant::tei:w[lower-case(.) = lower-case($word)]]
                                            "/>
                                        <xsl:apply-templates select="$speech"/>
                                    </xsl:for-each>
                                    
                                </body>
                            </html>
                        </xsl:result-document>
                        
                    </xsl:for-each>
                    </ul>
                </div>
                <script src="../JavaScript/script.js"></script>
            </body>
        </html>
    </xsl:template>
    <xsl:template match ="tei:sp">
        <xsl:variable name="title"
            select="ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
        <xsl:variable name="safe-title" select="replace($title, '[^A-Za-z0-9]+', '_') " />
        <xsl:variable name="filename" select="concat('../plays/', $safe-title, '.html')"/>
        <div class="speech">
            <h2 class="title">
                <a href="{$filename}"><xsl:value-of select="$title"/></a>
            </h2>
            <div class="speech-block">
                <p class="speech-text">
                    <xsl:apply-templates select="node()[not(self::tei:speaker)]"/>
                </p>
            </div>
        </div>
    </xsl:template>
    <!-- Words -->
    <xsl:template match="tei:w">
        <xsl:value-of select="."/>
    </xsl:template>
    <xsl:template match="tei:w[@ana='neologism']">
        <span class="neologism"><xsl:value-of select="."/></span>
    </xsl:template>
    
    <!-- Space tokens -->
    <xsl:template match="tei:c">
        <xsl:value-of select="."/>
    </xsl:template>
    
    <!-- Punctuation -->
    <xsl:template match="tei:pc">
        <xsl:value-of select="."/>
    </xsl:template>
    
    <!-- Line breaks -->
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    <xsl:template match ="tei:milestone"/>
    <xsl:template match ="tei:fw"/>
    <xsl:template match ="tei:stage"/>
        
    
    
</xsl:stylesheet>