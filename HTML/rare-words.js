// JS/rare-word-analyzer.js  ← UPGRADED WITH CONTEXT LINES!
const RARE_WORDS = [
  "unpregnant","ungrown","argal","smirched","fixture","untutored","passado","juvenal","gar","aroint",
  "dwindle","allons","sympathize","nonny","canopied","bawcock","expressure","unhardened","loo","via",
  "bavian","unfathered","diable","fitment","fer","propertied","dateless","drollery","nayword","week",
  "uncurrent","joan","deracinate","keech","untender","foutre","undeserver","unbated","directitude",
  "exposure","sola","sherris","undistinguishable","chapless","sessa","savagery"
].map(w => w.toLowerCase());

const PLAY_DATA = [ /* ← same exact list as before, I'm shortening here for space */ 
  {file: "XML/Alls_Well_That_Ends_Well.xml", title: "All's Well That Ends Well"},
  {file: "XML/Antony_and_Cleopatra.xml", title: "Antony and Cleopatra"},
  // ... all 37 plays exactly the same as last time (copy-paste the full list from previous message)
  {file: "XML/Winters_Tale.xml", title: "The Winter's Tale"}
];

// NEW: Function that returns every occurrence with full context
async function getRareWordOccurrences(xmlFile) {
  const resp = await fetch(xmlFile);
  const xmlText = await resp.text();
  const parser = new DOMParser();
  const doc = parser.parseFromString(xmlText, "text/xml");

  const occurrences = [];

  // Find every <w> or <pc> token that matches one of our rare words
  const tokens = doc.querySelectorAll("w, pc");
  tokens.forEach(token => {
    const word = token.textContent.toLowerCase();
    if (RARE_WORDS.includes(word)) {
      // Climb up to find speaker, act, scene, line
      const speakerEl = token.closest("sp")?.querySelector("speaker");
      const speaker = speakerEl ? speakerEl.textContent.trim() : "Chorus/Stage Direction";

      const lineEl = token.closest("l, ab");
      const lineNum = lineEl?.getAttribute("n") || "?";

      const act = token.closest("div[type='act']")?.getAttribute("n") || "?";
      const scene = token.closest("div[type='scene']")?.getAttribute("n") || "?";

      // Build the full line text
      const fullLine = lineEl ? lineEl.textContent.replace(/\s+/g, " ").trim() : token.textContent;

      occurrences.push({
        word: word,
        highlightedLine: fullLine.replace(
          new RegExp(`(\\b${word}\\b)`, "gi"),
          "<strong style='color:red;'>$1</strong>"
        ),
        speaker: speaker,
        location: `Act ${act}, Scene ${scene}, Line ${lineNum}`
      });
    }
  });

  return occurrences;
}

window.RareWordAnalyzer = {
  RARE_WORDS,
  PLAY_DATA,
  getRareWordOccurrences
};
