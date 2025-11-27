<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="3.0">
    
    <xsl:output method="html" indent="yes"/>
    <xsl:param name="play-folder" as="xs:string" 
        select="'../shakespeare-neo-and-newDef'"/>
    <xsl:variable name="play-descriptions" 
        select="doc('../Data/Original/shakespeare_playsXML.xml')"/>
    <xsl:template match="/">
        <html>
            <head>
                <meta charset="utf-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1"/>
                <title>Shakespeare’s Neologisms</title>
                
                <link rel="icon" type="image/x-icon" href="images/favicon.ico"/>
                <link rel="stylesheet" href="../CSS/styles.css"/>
                
                <style>
                    body {
                    margin: 0;
                    padding: 0 7rem;
                    padding-top: 80px;/* left/right margin */
                    }
                    #searchbar {
                    width: 100%;
                    position:relative;                  
                    font-size: 1.2rem;
                    padding: 10px;
                    margin: 1.5rem 0;
                    border-radius: 8px;
                    border: 2px solid #555;
                    }
                    #filters {
                    margin-bottom: 1rem;
                    }
                    .grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
                    grid-gap: 1.2rem;
                    }
                    .box {
                    border: 2px solid #444;
                    padding: 20px;
                    background: #f5f5f5;
                    border-radius: 8px;
                    text-align: center;
                    font-size: 1.2rem;
                    cursor: pointer;
                    font-family: Verdana, Arial;
                    
                    }
                    a.play {
                    color:black;
                    text-decoration:none;
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
                <input id="searchbar" type="text" placeholder="Search for a play…" onkeyup="filterPlays()"/>
                
                <div id="filters">
                    <label><input type="checkbox" class="genreFilter" value="Comedy"> Comedy </input></label>
                    <label><input type="checkbox" class="genreFilter" value="Tragedy"> Tragedy</input></label>
                    <label><input type="checkbox" class="genreFilter" value="History"> History</input></label>
                </div>
                
                <div class="grid" id="playGrid">
                    <xsl:for-each select="collection(concat($play-folder, '/?select=*.xml'))">
                        
                        <!-- Normalize for Windows paths -->
                        <xsl:variable name="normalized-uri"
                            select="replace(base-uri(.), '\\\\', '/')"/>
                        
                        <!-- Extract filename without .xml -->
                        <xsl:variable name="filename"
                            select="replace(tokenize($normalized-uri, '/')[last()], '\.xml$', '')"/>
                        
                        <!-- Play title -->
                        <xsl:variable name="title" 
                            select=".//tei:titleStmt/tei:title/text()"/>
                        <!-- Safe version of the title for filenames -->
                        <xsl:variable name="safe-title"
                            select="replace(translate(normalize-space($title),
                            '’‘”“', ''''''''),
                            ' ', '_')"/>
                        <!-- Date -->
                        <xsl:variable name="date"
                            select="lower-case(.//tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listWit/tei:witness/tei:biblStruct/tei:monogr/tei:imprint/tei:time)"/>
                        <!-- Genre -->
                        <xsl:variable name="genre"
                            select=".//tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listWit/tei:desc"/>
                        
                        <div class="box"
                            data-title="{$title}"
                            data-genre="{$genre}">
                            <a class ="play" href="{concat('../HTML/plays/', $filename, '.html')}">
                                <xsl:value-of select="$title"/>
                                <p/>
                                <xsl:value-of select="$date"/>
                            </a>
                        </div>
                        
                        <!-- GENERATE INDIVIDUAL PLAY PAGE -->
                        <xsl:result-document
                        href="file:///C:/Users/77zap/GitHub/Shakespeare-XML-Analysis/HTML/plays/{concat($filename, '.html')}"
                        method="html">
                            
                            <html>
                                <head>
                                    <meta charset="utf-8" />
                                    <meta name="viewport" content="width=device-width,initial-scale=1" />
                                    <title>Shakespeare's Neologisms</title>
                                    
                                    <!-- add tab icon -->
                                    <link rel="icon" type="image/x-icon" href="images/favicon.ico"/>
                                        <link rel="stylesheet" href="../../CSS/styles.css"/>
                                    <style>
                                        /* ===== CENTER and SCALE SVG CHART ===== */
                                        .chart-container {
                                        display: flex;
                                        justify-content: center;
                                        align-items: center;
                                        margin-top: 3rem;
                                        width: 100%; 
                                        }
                                        
                                        /* Make the SVG large and readable */
                                        .chart-container svg {
                                        width: 80vw;      /* responsive width */
                                        max-width: 1600px;
                                        height: 600px;    /* fixed readable height */
                                        }
                                        
                                        /* Make all text inside the SVG white */
                                        .chart-container svg text {
                                        fill: white;
                                        font-family: Arial, sans-serif;
                                        font-size: 22px;
                                        }
                                        
                                        /* Bar color override (the steelblue default is too dark on black) */
                                        .chart-container svg rect {
                                        fill: #4db8ff;   /* bright readable blue */
                                        stroke: white;
                                        stroke-width: 1;
                                        }
                                        
                                    </style>
                                </head>
                                <body>
                                    <div class="subpage-labels">
                                        <a href="../index.html">HOME</a>
                                        <a href="../about.html">ABOUT</a>
                                        <a href="../play-index.html">CORPUS</a>
                                        <div class="dropdown">
                                            <button onclick="myFunction()" class="dropbtn">ANALYSIS</button>
                                            <div id="myDropdown" class="dropdown-content">
                                                <a href="../newDef.html">New Definitions</a>
                                                <a href="../words.html">Frequency</a>
                                            </div>
                                        </div>
                                    </div>
                                    <header class="play-header">
                                        <h1 class="play-title">
                                            <xsl:value-of select="$title"/>
                                        </h1>
                                    </header>
                                    
                                    <section class="play-meta">                                        
                                            
                                            <!-- Lookup the short description from your description XML -->
                                            <xsl:variable name="desc"
                                                select="$play-descriptions/shakespeare_plays/play[@title = $title]/description"/>
                                            
                                            <p class="play-description">
                                                <xsl:choose>
                                                    <xsl:when test="$desc">
                                                        <xsl:value-of select="$desc"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <i>No description available.</i>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </p>
                                        
                                        <p class="play-genre">
                                            <strong>Genre: </strong>
                                            <span><xsl:value-of select="$genre"/></span>
                                        </p>
                                        
                                        <p class="play-date">
                                            <strong>Approx. Date Written: </strong>
                                            <span><xsl:value-of select="$date"/></span>
                                        </p>
                                        <!-- Chart of Neologisms and their frequency -->
                                        <!-- LOAD THE FREQUENCY XML FOR THIS PLAY -->
                                        <!-- =============================== -->
                                        <xsl:variable name="freq-file"
                                            select="concat(
                                            'file:///Users/77zap/Github/Shakespeare-XML-Analysis/Data/Analysis/individual_plays/',
                                            replace($safe-title, '\s+', '_'),
                                            '.xml'
                                            )"/>
                                        
                                        <xsl:variable name="freq" select="doc($freq-file)"/>
                                        
                                        <!-- =============================== -->
                                        <!-- NEOLGISM FREQUENCY BAR CHART -->
                                        <!-- =============================== -->
                                        <div class="chart-container">
                                           
                                            <svg xmlns="http://www.w3.org/2000/svg">
                                            
                                            <!-- Chart parameters -->
                                            <xsl:variable name="bar-width" select="40"/>
                                            <xsl:variable name="spacing" select="$bar-width div 4"/>
                                            <xsl:variable name="max-height" select="100"/>
                                            <xsl:variable name="y-scale" select="4"/>
                                            <xsl:variable name="count-words" select="count($freq/play/w)"/>
                                            
                                            <xsl:variable name="x-axis-length"
                                                select="$spacing + (($bar-width + $spacing) * $count-words)"/>
                                            <xsl:variable name="y-axis-length" select="$max-height * $y-scale"/>
                                            
                                            <svg viewBox="0 -{$y-axis-length} {$x-axis-length+200} {$y-axis-length+100}">
                                                
                                                <!-- X-axis -->
                                                <line x1="80" y1="0" x2="{80 + $x-axis-length}" y2="0"
                                                    stroke="white"/>
                                                <!-- Y-axis -->
                                                <line x1="80" y1="0" x2="80" y2="-{$y-axis-length}"
                                                    stroke="white"/>
                                                <!-- Y-axis label -->
                                                <text x="60" y="-{$y-axis-length div 2}"
                                                    text-anchor="middle" font-size="40" transform="rotate(-90, 60, -{$y-axis-length div 2})">
                                                    Frequency
                                                </text>    
                                                    
                                                <!-- Title -->
                                                <text x="{($x-axis-length+200) div 2}" y="-{$y-axis-length - 20}"
                                                    text-anchor="middle" font-size="40">
                                                    Neologisms in <xsl:value-of select="$title"/>
                                                </text>
                                                
                                                <!-- Draw bars -->
                                                <xsl:for-each select="$freq/play/w">
                                                    <xsl:sort select="@n" data-type="number" order="descending"/>
                                                    
                                                    <xsl:variable name="height" select="@n * $y-scale * 4"/>
                                                    <xsl:variable name="x-pos"
                                                        select="$bar-width + (position() * ($spacing + $bar-width))"/>
                                                    
                                                    <rect x="{$x-pos}" y="-{$height}" width="{$bar-width}"
                                                        height="{$height}" fill="steelblue"/>
                                                    
                                                    <!-- word text -->
                                                    <text x="{$x-pos + ($bar-width div 2) + $spacing}" y="30"
                                                        font-size="20" text-anchor="end"
                                                        transform="rotate(-90,{$x-pos + ($bar-width div 2)}, 30 )">
                                                        <a href="{concat('../neologisms/', ., '.html')}"><xsl:value-of select="."/></a>
                                                    </text>
                                                    
                                                    <!-- frequency text -->
                                                    <text x="{$x-pos + ($bar-width div 2)}" y="-{$height}"
                                                        font-size="18" text-anchor="middle">
                                                        <xsl:value-of select="@n"/>
                                                    </text>
                                                </xsl:for-each>
                                                
                                            </svg>
                                            
                                        </svg>
                                        </div>
                                    </section>
                                    <script>
                                        
                                        function filterPlays() {
                                        let input = document.getElementById('searchbar').value.toLowerCase();
                                        let items = document.querySelectorAll('#playGrid .box');
                                        
                                        items.forEach(box => {
                                        let title = box.dataset.title.toLowerCase();
                                        box.style.display = title.includes(input) ? 'block' : 'none';
                                        });
                                        }
                                        
                                        function filterCategory(cat) {
                                        let items = document.querySelectorAll('#playGrid .box');
                                        
                                        items.forEach(box => {
                                        let g = box.dataset.genre || "";
                                        if (cat === "all") {
                                        box.style.display = "block";
                                        } else {
                                        box.style.display = g.includes(cat) ? "block" : "none";
                                        }
                                        });
                                        }
                                        
                                    </script>
                                    
                                    <script src="../../JavaScript/script.js"></script>
                                </body>
                            </html>
                        </xsl:result-document>
                        
                    </xsl:for-each>
                </div>
                
                <script>
                    
                    function filterPlays() {
                    let input = document.getElementById('searchbar').value.toLowerCase();
                    let items = document.querySelectorAll('#playGrid .box');
                    
                    items.forEach(box => {
                    let title = box.dataset.title.toLowerCase();
                    box.style.display = title.includes(input) ? 'block' : 'none';
                    });
                    }
                    
                    function filterCategory(cat) {
                    let items = document.querySelectorAll('#playGrid .box');
                    
                    items.forEach(box => {
                    let g = box.dataset.genre || "";
                    if (cat === "all") {
                    box.style.display = "block";
                    } else {
                    box.style.display = g.includes(cat) ? "block" : "none";
                    }
                    });
                    }
                    
                </script>
                
                <script src="../JavaScript/script.js"></script>
                
            </body>
        </html>
    </xsl:template>
    
</xsl:stylesheet>
