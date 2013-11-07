<?xml version="1.0" encoding="us-ascii"?>
<!--
    Pass 2: Keeps the text contents; strips others.

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
  <xsl:output method="xml" encoding="us-ascii"/>

  <!-- Containers and text decorations: unwrap them. -->
  <xsl:template match="body | thead | tbody | tr">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <xsl:template match="article">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <xsl:template match="section | hgroup">
    <xsl:apply-templates select="node()"/>
    <!-- TODO: Process <section> and <hgroup> correctly. -->
  </xsl:template>

  <xsl:template match="div">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <xsl:template match="a | em | strong | small | s | cite | q | dfn
                       | abbr | time | code | var | samp | kbd | sub
                       | i | b | u | mark | ruby | bdi | bdo
                       | span | wbr">
    <!--
        Note: See HTML5 Section 4.6.  <br> is not processed here to keep
        preceding text and following text separate.  <rt> and <rp> are
        eliminated below.
      -->
    <xsl:apply-templates select="node()"/>
  </xsl:template>


  <!-- Section headers: turn <h*> into <section>. -->
  <xsl:template match="h1 | h2 | h3 | h4 | h5 | h6">
    <xsl:variable name="title_raw">
      <xsl:apply-templates select="node()"/>
    </xsl:variable>

    <!--
        Extract section number and title.  Some specs, such as
        REC-SVG11-20110816, doesn't have section number
        in <span class="secno"> but as part of heading text.
      -->
    <xsl:variable name="sn_in_title"
                  select="not(span[@class = 'secno'])
                          and contains('0123456789', substring($title_raw, 1, 1))"/>

    <xsl:variable name="sn_raw">
      <xsl:choose>
        <xsl:when test="$sn_in_title">
          <xsl:value-of select="substring-before($title_raw, ' ')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space(span[@class = 'secno'])"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="title">
      <xsl:choose>
        <xsl:when test="$sn_in_title">
          <xsl:value-of select="substring($title_raw, string-length($sn_raw) + 2)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$title_raw"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="sn">
      <!-- Drop '.' at the end -->
      <xsl:choose>
        <xsl:when test="substring($sn_raw, string-length($sn_raw)) = '.'">
          <xsl:value-of select="substring($sn_raw, 1, string-length($sn_raw) - 1)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$sn_raw"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <section type="{name(.)}" id="{@id}" number="{$sn}">
      <xsl:attribute name="title"><xsl:value-of select="normalize-space($title)"/></xsl:attribute>
    </section>
  </xsl:template>

  <xsl:template match="span[@class = 'secno']"/>


  <!-- Stuff to hide mostly. -->
  <xsl:template match="dl[@class = 'element']">
    <dl><xsl:apply-templates select="@__addr"/>(ELEMENT-DEF)</dl>
  </xsl:template>


  <!-- Stuff to eliminate completely. -->

  <xsl:template match="dt"/>
  <!-- assuming that the corresponding <dd> has enough to say -->

  <xsl:template match="*[@class = 'note']"/>
  <xsl:template match="*[@class = 'example']"/>
  <xsl:template match="*[@class = 'XXX']"/>

  <xsl:template match="dl[@class = 'domintro']"/>

  <xsl:template match="rt | rp"/>
  <xsl:template match="img"/>
  <xsl:template match="pre"/>

  <xsl:template match="head"/>
  <xsl:template match="div[@class = 'head']"/>
  <xsl:template match="div[@class = 'subtoc']"/>
  <xsl:template match="ol[@class = 'toc']"/>

  <xsl:template match="nav | aside | header | footer | address"/>
  <xsl:template match="hr"/>
  <xsl:template match="comment()"/>


  <!-- Default processing. -->

  <xsl:template match="node()">
    <xsl:copy>
      <xsl:apply-templates select="@__addr | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@__addr">
    <xsl:copy/>
  </xsl:template>

  <xsl:template match="@*"/>
</xsl:stylesheet>
