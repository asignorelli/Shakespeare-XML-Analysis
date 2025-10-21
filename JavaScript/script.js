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
