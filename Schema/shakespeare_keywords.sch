<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    <sch:title>Schematron Schema for Identifying Keywords in Shakespeare Plays</sch:title>
    <sch:ns prefix="tei" uri="http://www.tei-c.org/ns/1.0"/>
    <sch:ns prefix="xhtml" uri="http://www.w3.org/1999/xhtml"/>
    <sch:pattern id="keyword-identification">
        <sch:rule context="//text()[normalize-space(.) != '']">
            
            <sch:report test="matches(., '\blove\b', 'i')" role="info">
                Keyword 'love' found in text: "<sch:value-of select="."/>" at location: <sch:value-of select="concat(ancestor::/local-name(), '[', count(ancestor::[local-name()=current()/ancestor::/local-name()]/preceding-sibling::[local-name()=current()/ancestor::*/local-name()]) + 1, ']')"/>
            </sch:report>
            
            <sch:report test="matches(., '\bdeath\b', 'i')" role="info">
                Keyword 'death' found in text: "<sch:value-of select="."/>" at location: <sch:value-of select="concat(ancestor::/local-name(), '[', count(ancestor::[local-name()=current()/ancestor::/local-name()]/preceding-sibling::[local-name()=current()/ancestor::*/local-name()]) + 1, ']')"/>
            </sch:report>
            
            <sch:report test="matches(., '\bking\b', 'i')" role="info">
                Keyword 'king' found in text: "<sch:value-of select="."/>" at location: <sch:value-of select="concat(ancestor::/local-name(), '[', count(ancestor::[local-name()=current()/ancestor::/local-name()]/preceding-sibling::[local-name()=current()/ancestor::*/local-name()]) + 1, ']')"/>
            </sch:report>
            
        </sch:rule>
    </sch:pattern>
</sch:schema>