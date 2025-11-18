// JS/rare-word-analyzer.js
const RARE_WORDS = [
  "unpregnant","ungrown","argal","smirched","fixture","untutored","passado","juvenal","gar","aroint",
  "dwindle","allons","sympathize","nonny","canopied","bawcock","expressure","unhardened","loo","via",
  "bavian","unfathered","diable","fitment","fer","propertied","dateless","drollery","nayword","week",
  "uncurrent","joan","deracinate","keech","untender","foutre","undeserver","unbated","directitude",
  "exposure","sola","sherris","undistinguishable","chapless","sessa","savagery"
].map(w => w.toLowerCase());

const PLAY_DATA = [
  {file: "XML/Alls_Well_That_Ends_Well.xml", title: "All's Well That Ends Well"},
  {file: "XML/Antony_and_Cleopatra.xml", title: "Antony and Cleopatra"},
  {file: "XML/As_You_Like_It.xml", title: "As You Like It"},
  {file: "XML/Comedy_of_Errors.xml", title: "Comedy of Errors"},
  {file: "XML/Coriolanus.xml", title: "Coriolanus"},
  {file: "XML/Cymbeline.xml", title: "Cymbeline"},
  {file: "XML/Hamlet.xml", title: "Hamlet"},
  {file: "XML/Henry_IV_Part_1.xml", title: "Henry IV, Part 1"},
  {file: "XML/Henry_IV_Part_2.xml", title: "Henry IV, Part 2"},
  {file: "XML/Henry_V.xml", title: "Henry V"},
  {file: "XML/Henry_VI_Part_1.xml", title: "Henry VI, Part 1"},
  {file: "XML/Henry_VI_Part_2.xml", title: "Henry VI, Part 2"},
  {file: "XML/Henry_VI_Part_3.xml", title: "Henry VI, Part 3"},
  {file: "XML/Henry_VIII.xml", title: "Henry VIII"},
  {file: "XML/Julius_Caesar.xml", title: "Julius Caesar"},
  {file: "XML/King_John.xml", title: "King John"},
  {file: "XML/King_Lear.xml", title: "King Lear"},
  {file: "XML/Loves_Labours_Lost.xml", title: "Love's Labour's Lost"},
  {file: "XML/Macbeth.xml", title: "Macbeth"},
  {file: "XML/Measure_for_Measure.xml", title: "Measure for Measure"},
  {file: "XML/Merchant_of_Venice.xml", title: "Merchant of Venice"},
  {file: "XML/Merry_Wives_of_Windsor.xml", title: "Merry Wives of Windsor"},
  {file: "XML/A_Midsummer_Nights_Dream.xml", title: "A Midsummer Night's Dream"},
  {file: "XML/Much_Ado_About_Nothing.xml", title: "Much Ado About Nothing"},
  {file: "XML/Othello.xml", title: "Othello"},
  {file: "XML/Pericles.xml", title: "Pericles"},
  {file: "XML/Richard_II.xml", title: "Richard II"},
  {file: "XML/Richard_III.xml", title: "Richard III"},
  {file: "XML/Romeo_and_Juliet.xml", title: "Romeo and Juliet"},
  {file: "XML/Taming_of_the_Shaw.xml", title: "Taming of the Shrew"},
  {file: "XML/The_Tempest.xml", title: "The Tempest"},
  {file: "XML/Timon_of_Athens.xml", title: "Timon of Athens"},
  {file: "XML/Titus_Andronicus.xml", title: "Titus Andronicus"},
  {file: "XML/Troilus_and_Cressida.xml", title: "Troilus and Cressida"},
  {file: "XML/Twelfth_Night.xml", title: "Twelfth Night"},
  {file: "XML/Two_Gentlemen_of_Verona.xml", title: "Two Gentlemen of Verona"},
  {file: "XML/Winters_Tale.xml", title: "The Winter's Tale"}
];

async function countRareWordsInPlay(xmlFile) {
  const response = await fetch(xmlFile);
  const text = await response.text();
  const lowercase = text.toLowerCase();
  const counts = {};
  RARE_WORDS.forEach(word => {
    const regex = new RegExp("\\b" + word + "\\b", "g");
    const matches = lowercase.match(regex);
    counts[word] = matches ? matches.length : 0;
  });
  return counts;
}

window.RareWordAnalyzer = {
  RARE_WORDS,
  PLAY_DATA,
  countRareWordsInPlay
};
