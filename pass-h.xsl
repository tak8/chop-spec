<?xml version="1.0" encoding="us-ascii"?>
<!--
    Pass H: Generates the HTML document with text chunk IDs embedded.

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
  <xsl:output method="html" encoding="us-ascii"/>

  <xsl:template match="@*">
    <xsl:copy/>
  </xsl:template>

  <xsl:template match="node()">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:variable name="id" select="@__addr_id"/>
      <xsl:if test="$id">
        <xsl:variable name="id_short" select="concat('@', substring-after($id, '@'))"/>
        <a id="{$id}"/>
        <a id="{$id_short}" title="{$id}" href="#{$id}" class="text_chunk_id">
          <xsl:value-of select="$id_short"/>
        </a>
        <xsl:text> </xsl:text>
      </xsl:if>

      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="head">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>

      <style>
a.text_chunk_id {
    font: bold x-small sans-serif; color: #000; background: #bbb;
    text-decoration: none; padding: 0em 0.2em;
}
a.text_chunk_id:hover {
    background: #ddd;
}
</style>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@__addr"/>
  <xsl:template match="@__addr_id"/>
</xsl:stylesheet>
