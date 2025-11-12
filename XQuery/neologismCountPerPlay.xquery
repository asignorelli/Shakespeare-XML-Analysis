xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";
<plays> {
(: Load all marked-up TEI XML files :)
let $docs := collection('file:///Users/77zap/Github/Shakespeare-XML-Analysis/shakespeare-neo-and-newDef?select=*.xml')

for $doc in $docs
let $title := tokenize(base-uri($doc), '/')[last()]     (: filename as title :)
let $count := count($doc//tei:w[@ana='neologism'])
order by $count descending
return
  <play>
    <title>{$title}</title>
    <neologism-count>{$count}</neologism-count>
  </play>}
  </plays>