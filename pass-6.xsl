<?xml version="1.0" encoding="us-ascii"?>
<!--
    Pass 6: Marks non-normative contents.

    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    Copyright (C) 2013  Cable Television Laboratories, Inc.
    Contact: http://www.cablelabs.com/

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions
    are met:

    1. Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.
    2. Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
    IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
    THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
    PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL CABLELABS OR ITS CONTRIBUTORS BE
    LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
    CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
    SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
    INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
    CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
    ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGE.
 !-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" encoding="us-ascii" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="section[@number = '']
                       | section[@id = 'normative-references']
                       | section[@id = 'informative-references']
                       | section[t/text() = 'This section is non-normative.']
                       | section[t/text() = 'This section is not normative.']
                       | section[t/text() = 'This subsection is not normative.']
                       | section[t/text() = '(This section is not normative.)']
                       | section[t/text() = 'This section is informative']
                       | section[t/text() = 'This section is informative.']">
    <non-normative-section>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="non-normative">true</xsl:attribute>

      <xsl:for-each select="t">
        <xsl:call-template name="non-normative-t"/>
      </xsl:for-each>
    </non-normative-section>
  </xsl:template>

  <xsl:template match="t[starts-with(text(), '(Non-normative)')]">
    <xsl:call-template name="non-normative-t"/>
  </xsl:template>

  <xsl:template name="non-normative-t">
    <non-normative-t>
      <xsl:apply-templates select="node()"/>
    </non-normative-t>
  </xsl:template>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
