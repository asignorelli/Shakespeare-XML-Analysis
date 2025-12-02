<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0"
    exclude-result-prefixes="tei">
    
    <!-- ====================================================== -->
    <!-- PARAMETER: folder containing the TEI corpus             -->
    <!-- ====================================================== -->
    <xsl:param name="play-folder"
        select="'../shakespeare-neo-and-newDef'"/>
    <xsl:param name="pos-file" select="'../Data/Analysis/neologism_definitions.xml'"/>
    
    <!-- Load entire corpus -->
    <xsl:variable name="all-plays"
        select="collection(concat($play-folder,'?select=*.xml'))"/>
    
    <!-- ====================================================== -->
    <!-- BUILD period → neologism-count                        -->
    <!-- ====================================================== -->
    <xsl:variable name="freq">
        <xsl:variable name="raw">
            <xsl:for-each select="$all-plays/tei:TEI">
                
                <!-- Extract the time -->
                <xsl:variable name="time"
                    select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/
                    tei:listWit/tei:witness/tei:biblStruct/
                    tei:monogr/tei:imprint/tei:time"/>
                
                <!-- Count neologisms -->
                <xsl:variable name="neo-count"
                    select="count(.//tei:w[@ana='neologism'])"/>
                
                <period when="{$time}" count="{$neo-count}"/>
            </xsl:for-each>
        </xsl:variable>
        
        <!-- GROUP BY YEAR -->
        <xsl:for-each-group select="$raw/period" group-by="@when">
            <period 
                when="{current-grouping-key()}"
                count="{sum(current-group()/@count)}"/>
        </xsl:for-each-group>
    </xsl:variable>
    
    
    <!-- ====================================================== -->
    <!-- NEW: POS FREQUENCY GROUPING                            -->
    <!-- ============================================= -->
    <!-- LOAD POS DEFINITIONS                          -->
    <!-- ============================================= -->
    <xsl:variable name="defs" select="doc($pos-file)/definitions/entry"/>
    
    <xsl:variable name="pos-groups">
        <xsl:for-each-group select="$defs" group-by="pos">
            <xsl:sort select="count(current-group())" data-type="number" order="descending"/>
            <group pos="{current-grouping-key()}" count="{count(current-group())}"/>
        </xsl:for-each-group>
    </xsl:variable>
    
    <!-- ====================================================== -->
    <!-- MAIN OUTPUT HTML                                       -->
    <!-- ====================================================== -->
    <xsl:output method="html" indent="yes" />
    
    <xsl:template match="/">
        <html lang="en">
            <head>
                <meta charset="utf-8"/>
                <meta name="viewport" content="width=device-width,initial-scale=1"/>
                <title>Shakespeare's Neologisms</title>
                
                <link rel="icon" type="image/x-icon" href="images/favicon.ico"/>
                <link rel="stylesheet" href="../CSS/styles.css"/>
                <style>
                    /* ===== CENTER and SCALE SVG CHART ===== */
                    .chart {
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    width: 100%; 
                    }
                    
                    /* Make the SVG large and readable */
                    .chart svg {
                    width: 85vw;     /* Fill nearly full screen */
                    max-width: 2000px;
                    height: 600px;   /* Taller */
                    }
                    
                    /* Make all text inside the SVG white */
                    .chart svg text {
                    fill: white;
                    font-family: Arial, sans-serif;
                    }
                    
                    /* Bar color override  */
                    .chart svg rect {
                    fill: #4db8ff;
                    stroke: white;
                    stroke-width: 1;
                    }
                    .chart2 {
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    width: 100%; 
                    }
                    /* Make the SVG large and readable */
                    .chart2 svg {
                    width: 95vw;     /* Fill nearly full screen */
                    max-width: 2000px;
                    height: 1100px;   /* Taller */
                    }
                    
                    /* Make all text inside the SVG white */
                    .chart2 svg text {
                    fill: white;
                    font-family: Arial, sans-serif;
                    }
                    
                    /* Bar color override  */
                    .chart2 svg rect {
                    fill: #4db8ff;
                    stroke: white;
                    stroke-width: 1;
                    }
                    .container h2 {
                    margin-left: 5%;
                    font-size: 50px;
                    text-decoration:underline;
                    margin-bottom: 20px;}
                    .container p {
                    font-family: Verdana, Arial;
                    margin-left: 5%;
                    width: 75%;
                    height:auto;
                    }
                    .container p a, .container p a:visited {
                    fill: white;
                    }
                    
                </style>
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
                                <a href="words.html">Frequency</a>
                            </div>
                        </div>
                    </div>
                    
                
                <section class="about" >
                    <div class="container">
                        <h2>General Trends Across these Neologisms</h2>
                    </div>
                </section>
                
                <!-- ===================================================== -->
                <!-- FIRST CHART (unchanged)                               -->
                <!-- ===================================================== -->
                <section class="chart-section">
                    <div class="container">
                        <h2 style="margin-top:0;">Neologisms By Time Period</h2>
                        <p>Depicted below is a comparison of the amount of neologisms arranged in a chronological manner. For each play, these years are estimates. The chronology of Shakespeare's plays is obtained from <a href="https://en.wikipedia.org/wiki/Chronology_of_Shakespeare%27s_plays">E.K Chambers</a>, who spent his life doing an extensive examination of Shakespeare's works. </p>
                        <xsl:call-template name="chart"/>
                    </div>
                </section>
                
                <!-- ===================================================== -->
                <!-- NEW: POS CHART                                         -->
                <!-- ===================================================== -->
                <section class="chart-section">
                    <div class="container">
                        <h2>Neologisms By Part of Speech</h2>
                        <p>This chart below examines the distribution of part of speech across all of Shakespeare's neologisms. The part of speech data was obtained from the Oxford English Dictionary. </p>
                        <xsl:call-template name="pos-chart"/>
                    </div>
                </section>
                
                <script src="../JavaScript/script.js" defer="defer"></script>
                
            </body>
        </html>
    </xsl:template>
    
    
    <!-- ====================================================== -->
    <!-- FIRST CHART (LEAVE EXACTLY AS YOU GAVE IT)             -->
    <!-- ====================================================== -->
    <xsl:template name="chart">
        <!-- UNCHANGED CONTENT -->
        <div class="chart">
            <svg xmlns="http://www.w3.org/2000/svg">
                <xsl:variable name="bar-width" select="40"/>
                <xsl:variable name="spacing" select="$bar-width div 4"/>
                <xsl:variable name="max-height" select="100"/>
                <xsl:variable name="y-scale" select="4"/>
                <xsl:variable name="count-periods" select="count($freq/period)"/>
                
                <xsl:variable name="x-axis-length"
                    select="$spacing + (($bar-width + $spacing) * $count-periods)"/>
                
                <xsl:variable name="y-axis-length"
                    select="$max-height * $y-scale"/>
                
                <svg width="100%" height="auto" viewBox="0 -{$y-axis-length} {$x-axis-length+200} {$y-axis-length+100}">
                    
                    <line x1="80" y1="0" x2="{80 + $x-axis-length}" y2="0" stroke="white"/>
                    <line x1="80" y1="0" x2="80" y2="-{$y-axis-length}" stroke="white"/>
                    
                    <text x="60" y="-{$y-axis-length div 2}" 
                        text-anchor="middle" font-size="40"
                        transform="rotate(-90,60,-{$y-axis-length div 2})">
                        Frequency
                    </text>
                    
                    <text x="{($x-axis-length+200) div 2}" 
                        y="-{$y-axis-length - 20}" 
                        text-anchor="middle" font-size="40">
                        Neologisms by Time Period
                    </text>
                    
                    <xsl:for-each select="$freq/period">
                        <xsl:sort select="@when" data-type="number"/>
                        
                        <xsl:variable name="height" select="@count * $y-scale"/>
                        <xsl:variable name="x-pos"
                            select="$bar-width + (position() * ($spacing + $bar-width))"/>
                        
                        <rect x="{$x-pos}" y="-{$height}" 
                            width="{$bar-width}" height="{$height}"
                            fill="steelblue"/>
                        
                        <text x="{$x-pos + ($bar-width div 2) + $spacing}" y="30"
                            font-size="20" text-anchor="end"
                            transform="rotate(-90,{$x-pos + ($bar-width div 2)},30)">
                            <xsl:value-of select="@when"/>
                        </text>
                        
                        <text x="{$x-pos + ($bar-width div 2)}" 
                            y="-{$height}" font-size="18" text-anchor="middle">
                            <xsl:value-of select="@count"/>
                        </text>
                        
                    </xsl:for-each>
                    
                </svg>
                
            </svg>
        </div>
    </xsl:template>
    
    
    <!-- ====================================================== -->
    <!-- NEW TEMPLATE: POS CHART                               -->
    <!-- ====================================================== -->
    <xsl:template name="pos-chart">
        <div class="chart2">
            <svg xmlns="http://www.w3.org/2000/svg" >
                
                <xsl:variable name="bar-width" select="50"/>
                <xsl:variable name="spacing" select="25"/>
                <xsl:variable name="y-scale" select="10"/>
                
                <xsl:variable name="max-height"
                    select="max($pos-groups/group/@count ! number())"/>
                
                <xsl:variable name="y-axis-length" select="($max-height * $y-scale) + 40"/>
                <xsl:variable name="count-items" select="count($pos-groups/group)"/>
                <xsl:variable name="x-axis-length"
                    select="$spacing + (($bar-width + $spacing) * $count-items)"/>
                
                <xsl:variable name="padding" select="250"/>
                
                <svg viewBox="
                    0 -{$y-axis-length +$padding}
                    {$x-axis-length}
                    {$y-axis-length+(2*$padding)}
                    "
                    style="transform: rotate(90deg); transform-origin: center;">
                    
                    <!-- axes -->
                    <line x1="80" y1="0" x2="{80 + $x-axis-length}" y2="0" stroke="white"/>
                    <line x1="80" y1="0" x2="80" y2="-{$y-axis-length}" stroke="white"/>
                    
                    <text x="60" y="-{$y-axis-length div 2}"
                        text-anchor="middle" font-size="40"
                        transform="rotate(-90,60,-{$y-axis-length div 2})">
                        Frequency
                    </text>
                    
                    <xsl:for-each select="$pos-groups/group">
                        <xsl:variable name="height" select="@count * $y-scale"/>
                        <xsl:variable name="x" select="$bar-width + (position() * ($spacing + $bar-width))"/>
                        
                        <rect x="{$x}" y="-{$height}" 
                            width="{$bar-width}" height="{$height}"
                            fill="darkorange"/>
                        
                        <text x="{$x + ($bar-width div 2)+10}" 
                            y="-{$height + 20}" 
                            font-size="30"
                            text-anchor="middle"
                             transform="rotate(-90, {$x+($bar-width div 2)+10}, -{$height +20})">
                            <xsl:value-of select="@count"/>
                        </text>
                        
                        <text x="{$x + ($bar-width div 2)+10}"
                            y="40"
                            font-size="25"
                            text-anchor="end"
                            transform="rotate(-90,{$x + ($bar-width div 2)},40)">
                            <xsl:value-of select="@pos"/>
                        </text>
                        
                    </xsl:for-each>
                    
                </svg>
            </svg>
        </div>
    </xsl:template>
    
</xsl:stylesheet>
