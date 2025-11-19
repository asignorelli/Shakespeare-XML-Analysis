//ensure it runs only after everthing loaded
document.addEventListener("DOMContentLoaded", () => {

    const spans = Array.from(document.querySelectorAll(".bg-words span"));

    //stop if all the words are already visible
    if (!spans.length)
        return;

    // shuffle array
    for (let i = spans.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [spans[i], spans[j]] = [spans[j], spans[i]];
    }

    // reveal them one at a time
    const delayBetween = 90; //how much time between each reveal
    spans.forEach((span, i) => {
        setTimeout(() => {
            span.classList.add("visible");
        },
            i * delayBetween);
    });
});

// GLOBAL FADE-IN
document.addEventListener("DOMContentLoaded", () => {
    document.body.classList.add("page-loaded");
});

// WORD PAGE
//adapted on this tutorial: https://www.tutorialpedia.org/blog/word-cloud-html-css/
//and then edited by Alyssa
//------------------------------
// ---- LOAD XML FILE ----
fetch("../Data/Analysis/neologismFrequency.xml")
    .then(response => response.text())
    .then(xmlText => {
        const parser = new DOMParser();
        const xml = parser.parseFromString(xmlText, "application/xml");

        const words = [...xml.querySelectorAll("w")]
            .map(w => ({
                text: w.textContent.trim(),
                freq: Number(w.getAttribute("n"))
            }))
            .filter(w => w.freq >= 2);   // << keep only words 3+


        createWordCloud(words);
    })
    .catch(err => console.error("Error loading XML:", err));

// ---- WORD CLOUD FUNCTION ----
function loadWordsFromXML() {
    const xmlString = `<?xml version="1.0" encoding="UTF-8"?>
<frequency>
   <w n="30">gar</w>
   <w n="29">week</w>
   <w n="28">joan</w>
   <w n="14">nonny</w>
   <w n="10">sola</w>
   <w n="7">juvenal</w>
   <w n="6">via</w>
   <w n="6">untutored</w>
   <w n="6">loo</w>
   <w n="5">sherris</w>
   <w n="5">sympathize</w>
   <w n="5">fer</w>
   <w n="4">bawcock</w>
   <w n="4">diable</w>
   <w n="4">dateless</w>
   <w n="4">bavian</w>
   <w n="3">propertied</w>
   <w n="3">exposure</w>
   <w n="3">canopied</w>
   <w n="3">uncurrent</w>
   <w n="3">unbated</w>
   <w n="3">argal</w>
   <w n="3">unfathered</w>
   <w n="3">sessa</w>
   <w n="3">aroint</w>
   <w n="3">passado</w>
   <w n="3">allons</w>
   <w n="3">nayword</w>
   <w n="3">fixture</w>
   <w n="3">expressure</w>
   <w n="2">unhardened</w>
   <w n="2">collied</w>
   <w n="2">undistinguishable</w>
   <w n="2">trippingly</w>
   <w n="2">directitude</w>
   <w n="2">untender</w>
   <w n="2">fitment</w>
   <w n="2">unpregnant</w>
   <w n="2">chapless</w>
   <w n="2">keech</w>
   <w n="2">drollery</w>
   <w n="2">undeserver</w>
   <w n="2">foutre</w>
   <w n="2">dwindle</w>
   <w n="2">ungrown</w>
   <w n="2">smirched</w>
   <w n="2">deracinate</w>
   <w n="2">savagery</w>
</frequency>`;

    // ... XML parsing (skipped)
    const parser = new DOMParser();
    const xmlDoc = parser.parseFromString(xmlString, "text/xml");
    const wordElements = xmlDoc.getElementsByTagName("w");

    const wordsMap = new Map();

    for (let i = 0; i < wordElements.length; i++) {
        const text = wordElements[i].textContent;
        const freq = parseInt(wordElements[i].getAttribute("n"));

        if (!wordsMap.has(text)) {
            wordsMap.set(text, freq);
        }
    }

    const words = Array.from(wordsMap, ([text, freq]) => ({ text, freq }));
    words.sort((a, b) => b.freq - a.freq);

    return words;
}

let cloudInitialized = false;

function createWordCloud(words) {
    if (cloudInitialized) return;
    cloudInitialized = true;

    const container = document.getElementById("word-cloud");

    // Get container dimensions
    const cWidth = container.offsetWidth;
    const cHeight = container.offsetHeight;
    // Center of the container
    const centerX = cWidth / 2;
    const centerY = cHeight / 2;
    // Radius of the circle (with a 40px padding)
    const cloudRadius = Math.min(cWidth, cHeight) / 2 - 40;

    // --- NEW ---
    // A map to "anchor" your most important words
    // (50, 50) is the dead center.
    const wordPositions = {
        // Top 3 (Big Triangle)
        "GAR": { x: 50, y: 30 }, // Top-center
        "WEEK": { x: 35, y: 75 }, // Bottom-left
        "JOAN": { x: 65, y: 75 }, // Bottom-right

        // Second Tier (Filling the sides)
        "NONNY": { x: 20, y: 50 }, // Far-left
        "SOLA": { x: 80, y: 50 }, // Far-right

        // Third Tier (Filling the gaps)
        "JUVENAL": { x: 30, y: 25 }, // Top-left
        "UNTUTORED": { x: 70, y: 25 }, // Top-right
        "FER": { x: 50, y: 60 }, // Middle-ish
        "BAWCOCK": { x: 45, y: 45 }, // Center-left
        "DATELESS": { x: 60, y: 45 }  // Center-right
    };
    // -----------------------

    // --- ADD THIS ---
    // Create a palette of blues to pick from randomly
    const bluePalette = [
        "#a8daff", // lightest blue
        "#89c4ff",
        "#6aaeff",
        "#489bff",
        "#2790ff", // accent blue
        "#1e7cff", // main blue
        "#0056b3", // dark blue
        "#004aad",
        "#003a8a"  // darkest blue
    ];

    // Use scalePow for better size distribution
    const sizeScale = d3.scalePow()
        .exponent(2) // Squaring the frequency
        .domain([
            d3.min(words, d => d.freq),
            d3.max(words, d => d.freq)
        ])
        .range([18, 100]); // min 18px, max 100px

    words.forEach((w, i) => {
        w.el = document.createElement("div");
        w.el.className = "word";
        w.el.innerText = w.text;
        w.el.style.fontSize = sizeScale(w.freq) + "px";
        w.el.style.color = bluePalette[Math.floor(Math.random() * bluePalette.length)];
        container.appendChild(w.el);
    });

    setTimeout(() => {

        // --- NEW PLACEMENT LOGIC ---
        words.forEach((w, i) => {
            const rect = w.el.getBoundingClientRect();
            w.width = rect.width;
            w.height = rect.height;

            // Check if this word is in our layout map
            const key = w.text.toUpperCase(); // Use toUpperCase() for a safe key
            if (wordPositions[key]) {
                const pos = wordPositions[key];
                // It's in the map! Place it using the percentage
                w.x = (pos.x / 100) * cWidth;
                w.y = (pos.y / 100) * cHeight;

            } else {
                // It's a minor word, place it randomly
                const angle = Math.random() * Math.PI * 2;
                // Use sqrt for a uniform distribution
                const radius = Math.sqrt(Math.random()) * cloudRadius;
                w.x = centerX + radius * Math.cos(angle);
                w.y = centerY + radius * Math.sin(angle);
            }

            w.el.style.left = w.x + "px";
            w.el.style.top = w.y + "px";
        });
        // -----------------------------

        function wRadius(w) {
            return Math.max(w.width, w.height) / 2 + 2;
        }

        function wordsOverlap(w1, w2) {
            const dx = w1.x - w2.x;
            const dy = w1.y - w2.y;
            const distance = Math.sqrt(dx * dx + dy * dy);
            const minDistance = wRadius(w1) + wRadius(w2);
            return distance < minDistance;
        }

        // Replaced ticked function to force circular boundary
        function ticked() {
            words.forEach(w => {
                // Find distance from center
                const dx = w.x - centerX;
                const dy = w.y - centerY;
                const distance = Math.sqrt(dx * dx + dy * dy);

                // Find the "radius" of the word itself
                const wordRad = Math.max(w.width, w.height) / 2;

                // This is the max distance the *center* of the word can be from the *center* of the circle
                const maxDist = cloudRadius - wordRad;

                // If it's outside, push it back in
                if (distance > maxDist) {
                    const overshot = distance - maxDist;
                    // Move it back along the line to the center
                    w.x -= (dx / distance) * overshot;
                    w.y -= (dy / distance) * overshot;
                }

                w.el.style.left = w.x + "px";
                w.el.style.top = w.y + "px";
            });
        }

        // Added X and Y forces to pull to center
        const sim = d3.forceSimulation(words)
            .force("collision", d3.forceCollide()
                .radius(w => wRadius(w))
                .strength(1)
                .iterations(10))
            .force("charge", d3.forceManyBody().strength(-5))
            // Add forces to gently pull all words to the center
            .force("x", d3.forceX(centerX).strength(0.05))
            .force("y", d3.forceY(centerY).strength(0.05))
            .alphaDecay(0.015)
            .velocityDecay(0.6)
            .on("tick", ticked);

        setTimeout(() => {
            sim.stop();
            // Save original positions AFTER simulation settles
            words.forEach(w => {
                w.originalX = w.x;
                w.originalY = w.y;
            });
            // Fade in the container
            container.style.opacity = 1;
        }, 6000); // 6-second simulation

        words.forEach(w => {
            const baseSize = sizeScale(w.freq);
            let hovering = false;

            w.el.addEventListener("mouseenter", () => {
                if (hovering) return;
                hovering = true;

                w.el.style.fontSize = baseSize * 1.3 + "px";
                w.el.style.fontWeight = "900";

                const rect = w.el.getBoundingClientRect();
                const oldWidth = w.width;
                const oldHeight = w.height;
                w.width = rect.width;
                w.height = rect.height;

                const overlappingWords = words.filter(other => {
                    if (other === w) return false;
                    return wordsOverlap(w, other);
                });

                if (overlappingWords.length > 0) {
                    overlappingWords.forEach(other => {
                        const dx = other.x - w.x;
                        const dy = other.y - w.y;
                        const distance = Math.sqrt(dx * dx + dy * dy);

                        const requiredDistance = wRadius(w) + wRadius(other);
                        const overlap = requiredDistance - distance;

                        if (overlap > 0 && distance > 0) {
                            const pushX = (dx / distance) * overlap;
                            const pushY = (dy / distance) * overlap;

                            // Calculate new tentative position
                            const newX = other.x + pushX;
                            const newY = other.y + pushY;

                            // Apply circular clamping
                            other.x = newX;
                            other.y = newY;

                            const dx_other = other.x - centerX;
                            const dy_other = other.y - centerY;
                            const dist_other = Math.sqrt(dx_other * dx_other + dy_other * dy_other);
                            const wordRad_other = Math.max(other.width, other.height) / 2;
                            const maxDist_other = cloudRadius - wordRad_other;

                            if (dist_other > maxDist_other) {
                                const overshot = dist_other - maxDist_other;
                                other.x -= (dx_other / dist_other) * overshot;
                                other.y -= (dy_other / dist_other) * overshot;
                            }

                            // Apply transition and new clamped positions
                            other.el.style.transition = "left 0.3s ease, top 0.3s ease";
                            other.el.style.left = other.x + "px";
                            other.el.style.top = other.y + "px";
                        }
                    });
                }
            });

            w.el.addEventListener("mouseleave", () => {
                hovering = false;

                w.el.style.fontSize = baseSize + "px";
                w.el.style.fontWeight = "bold";

                const rect = w.el.getBoundingClientRect();
                w.width = rect.width;
                w.height = rect.height;

                // Return ALL words to their saved original positions
                words.forEach(word => {
                    word.el.style.transition = "left 0.5s ease, top 0.5s ease";
                    word.x = word.originalX;
                    word.y = word.originalY;
                    word.el.style.left = word.x + "px";
                    word.el.style.top = word.y + "px";

                    setTimeout(() => {
                        word.el.style.transition = "";
                    }, 500);
                });
            });

            w.el.addEventListener("click", () => {
                alert(`${w.text}: frequency = ${w.freq}`);
            });
        });
    }, 100);
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        const words = loadWordsFromXML();
        createWordCloud(words);
    });
} else {
    const words = loadWordsFromXML();
    createWordCloud(words);
}

document.addEventListener("DOMContentLoaded", () => {

    // === SCROLL FADE-IN ===
    const faders = document.querySelectorAll('.fade-in');

    const observer = new IntersectionObserver((entries, obs) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('show');
                obs.unobserve(entry.target);
            }
        });
    }, {
        threshold: 0.1,
        rootMargin: "0px 0px -150px 0px"  // NEW
    });


    faders.forEach(el => observer.observe(el));
});
