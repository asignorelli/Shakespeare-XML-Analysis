<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="3.0">
    
    <xsl:output method="html" indent="yes"/>
    <xsl:param name="play-folder" as="xs:string" 
        select="'../shakespeare-neo-and-newDef'"/>
    
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
                    }
                </style>
                
            </head>
            
            <body>
                
                <div class="subpage-labels">
                    <a href="about.html">ABOUT</a>
                    <a href="words.html">WORDS</a>
                    <a href="play-index.html">CORPUS</a>
                    <a href="analysis.html">ANALYSIS</a>
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
                        
                        <!-- Date -->
                        <xsl:variable name="date"
                            select="lower-case(.//tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listWit/tei:witness/tei:biblStruct/tei:monogr/tei:imprint/tei:time)"/>
                        <!-- Genre -->
                        <xsl:variable name="genre"
                            select=".//tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listWit/tei:desc"/>
                        
                        <div class="box"
                            data-title="{$title}"
                            data-genre="{$genre}">
                            <a href="{concat('../HTML/plays/', $filename, '.html')}">
                                <xsl:value-of select="$title"/>
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
                                </head>
                                <body>
                                    <div class="subpage-labels">
                                        <a href="../about.html">ABOUT</a>
                                        <a href="../words.html">WORDS</a>
                                        <a href="../play-index.html">CORPUS</a>
                                        <a href="../analysis.html">ANALYSIS</a>
                                    </div>
                                    <header class="play-header">
                                        <h1 class="play-title">
                                            <xsl:value-of select="$title"/>
                                        </h1>
                                    </header>
                                    
                                    <!-- Count neologisms example -->
                                    <section class="play-meta">
                                        
                                        <!-- Short Description (placeholder for you to fill manually later) -->
                                        <p class="play-description">
                                            <i>No description has been added for this play yet.</i>
                                        </p>
                                        
                                        <p class="play-genre">
                                            <strong>Genre: </strong>
                                            <span><xsl:value-of select="$genre"/></span>
                                        </p>
                                        
                                        <p class="play-date">
                                            <strong>Approx. Date: </strong>
                                            <span><xsl:value-of select="$date"/></span>
                                        </p>
                                    </section>
                                </body>
                            </html>
                        </xsl:result-document>
                        
                    </xsl:for-each>
                </div>
                
                <script>
                    
                        function filterPlays() { let input = document.getElementById('searchbar').value.toLowerCase(); let items = document.querySelectorAll('#playGrid .box'); items.forEach(box => { let title = box.dataset.title.toLowerCase(); box.style.display = title.includes(input) ? 'block' : 'none'; }); } function filterCategory(cat) { let items = document.querySelectorAll('#playGrid .box'); items.forEach(box => { let g = box.dataset.genre || ""; if (cat === "all") { box.style.display = "block"; } else { box.style.display = g.includes(cat) ? "block" : "none"; } }); }
    function filterPlays() {
        let input = document.getElementById('searchbar').value.toLowerCase();

        let com = document.getElementById("comedyCheck").checked;
        let tra = document.getElementById("tragedyCheck").checked;
        let his = document.getElementById("historyCheck").checked;

        let boxes = document.querySelectorAll(".box");

        boxes.forEach(box => {
            let title = box.dataset.title.toLowerCase();
            let genre = box.dataset.genre.toLowerCase();

            let textMatch = title.includes(input);

            let genreMatch =
            (!com &amp;&amp; !tra &amp;&amp; !his) ||
            (com &amp;&amp; genre.includes("comedy")) ||
            (tra &amp;&amp; genre.includes("tragedy")) ||
            (his &amp;&amp; genre.includes("history"));

box.style.display = (textMatch &amp;&amp; genreMatch) ? "block" : "none";
        });
    }
                    
                </script>
                
                <script src="../../JavaScript/script.js"></script>
                
            </body>
        </html>
    </xsl:template>
    
</xsl:stylesheet>
