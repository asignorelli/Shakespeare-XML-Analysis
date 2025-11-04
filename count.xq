let $docs := collection('shakespeare-xml-only?select=*.xml;on-error=ignore')
return count($docs)