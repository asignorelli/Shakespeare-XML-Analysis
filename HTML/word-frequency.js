// This is our magic word-hunting spell for the rare words!
const RARE_WORDS = [
  "unpregnant","ungrown","argal","smirched","fixture","untutored","passado",
  "juvenal","gar","aroint","dwindle","allons","sympathize","nonny","canopied",
  "bawcock","expressure","unhardened","loo","via","bavian","unfathered",
  "diable","fitment","fer","propertied","dateless","drollery","nayword",
  "week","uncurrent","joan","deracinate","keech","untender","foutre",
  "undeserver","unbated","directitude","exposure","sola","sherris",
  "undistinguishable","chapless","sessa","savagery"
];

async function huntRareWords() {
  const counts = {};
  RARE_WORDS.forEach(word => counts[word] = 0);  // start at zero candies

  // Look inside every play (like opening 37 storybooks)
  for (let book of PLAY_FILES) {  // PLAY_FILES is the same list from before
    let story = await fetch(book).then(r => r.text());
    let lowercaseStory = story.toLowerCase();
    RARE_WORDS.forEach(word => {
      if (lowercaseStory.includes(word)) {
        // count how many times it appears in this one book
        let regex = new RegExp("\\b" + word + "\\b", "g");
        let found = (lowercaseStory.match(regex) || []).length;
        counts[word] += found;
      }
    });
  }
  return counts;
}

window.RareWordHunter = { huntRareWords, RARE_WORDS };
