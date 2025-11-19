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
                    <a>WORDS</a>
                    <a href="corpus.html">CORPUS</a>
                    <a>ANALYSIS</a>
                </div>
                
                <input id="searchbar" type="text" placeholder="Search for a play…" onkeyup="filterPlays()"/>
                
                <div id="filters">
                    <button onclick="filterCategory('all')">All</button>
                    <button onclick="filterCategory('comedy')">Comedies</button>
                    <button onclick="filterCategory('tragedy')">Tragedies</button>
                    <button onclick="filterCategory('history')">Histories</button>
                </div>
                
                <div class="grid" id="playGrid">
                    <xsl:for-each select="collection(concat($play-folder, '/?select=*.xml'))">
                        
                        <!-- Extract clean filename -->
                        <xsl:variable name="filename" 
                            select="replace(tokenize(document-uri(.), '/')[last()], '\.xml$', '')"/>
                        
                        <!-- Extract play title -->
                        <xsl:variable name="title" select=".//tei:titleStmt/tei:title"/>
                        
                        <!-- Extract genre from keywords, if TEI provides it -->
                        <xsl:variable name="genre" 
                            select="lower-case(.//tei:keywords/tei:term[1])"/>
                        
                        <div class="box"
                            data-title="{$title}"
                            data-genre="{$genre}">
                            <a href="{concat($filename, '.html')}">
                                <xsl:value-of select="$title"/>
                            </a>
                        </div>
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
