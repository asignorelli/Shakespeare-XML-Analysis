xquery version "3.1";
  
declare namespace tei="http://www.tei-c.org/ns/1.0";
<frequency> {
let $docs := collection('file:///Users/77zap/Github/Shakespeare-XML-Analysis/shakespeare-neo-and-newDef?select=*.xml')

let $all-neologisms :=
  for $w in $docs//tei:w[@ana='newDef']
  return lower-case(normalize-space(string($w)))

for $word in distinct-values($all-neologisms)
let $freq := count($all-neologisms[. = $word])
order by $freq descending
return
  <w n="{$freq}">{$word}</w>}
</frequency>
  