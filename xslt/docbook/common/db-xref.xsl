<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Common Cross Reference Utilities</doc:title>


<!-- == db.ulink.tooltip =================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.ulink.tooltip</name>
  <purpose>
    Generate the tooltip for an external link
  </purpose>
</template>

<xsl:template name="db.ulink.tooltip">
  <xsl:param name="node" select="."/>
  <xsl:param name="url" select="$node/@url"/>
  <xsl:choose>
    <xsl:when test="starts-with($url, 'mailto:')">
      <xsl:variable name="addy" select="substring-after($url, 'mailto:')"/>
      <xsl:call-template name="format.tooltip.mailto">
        <xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="address">
          <xsl:choose>
            <xsl:when test="contains($addy, '?')">
              <xsl:value-of select="substring-before($addy, '?')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$addy"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="normalize-space($url)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- == db.xref.content ==================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.xref.content</name>
  <purpose>
    Generate the content for a cross reference
  </purpose>
</template>

<xsl:template name="db.xref.content">
  <xsl:param name="linkend" select="@linkend"/>
  <xsl:param name="target" select="key('idkey', $linkend)"/>
  <xsl:param name="xrefstyle" select="@xrefstyle"/>
  <xsl:choose>
    <!-- FIXME: should we prefer xrefstyle over xreflabel? -->
    <xsl:when test="$target/@xreflabel">
      <xsl:value-of select="$target/@xreflabel"/>
    </xsl:when>
    <xsl:when test="$xrefstyle and starts-with($xrefstyle, 'role:')">
      <xsl:call-template name="db.label">
        <xsl:with-param name="node" select="$target"/>
        <xsl:with-param name="role" select="substring-after($xrefstyle, 'role:')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="db.label">
        <xsl:with-param name="node" select="$target"/>
        <xsl:with-param name="role" select="'xref'"/>
      </xsl:call-template> 
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- == db.xref.target ===================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.xref.target</name>
  <purpose>
    Generate the target for a cross reference
  </purpose>
  <parameter>
    <name>linkend</name>
    <purpose>
      The <sgmltag class="attribute">id</sgmltag> of the target element
    </purpose>
  </parameter>
  <parameter>
    <name>target</name>
    <purpose>
      The target element
    </purpose>
  </parameter>
</template>

<xsl:template name="db.xref.target">
  <xsl:param name="linkend" select="@linkend"/>
  <xsl:param name="target" select="key('idkey', $linkend)"/>
  <xsl:choose>
    <xsl:when test="$linkend = $db.chunk.info_basename">
      <xsl:value-of select="concat($db.chunk.info_basename, $db.chunk.extension)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="target_chunk_id">
        <xsl:call-template name="db.chunk.chunk-id">
          <xsl:with-param name="node" select="$target"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="not($db.chunk.chunk_top) and
                        string($target_chunk_id) = string(/*/@id)">
          <xsl:value-of select="concat($db.chunk.basename, $db.chunk.extension)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($target_chunk_id, $db.chunk.extension)"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="string($target_chunk_id) != string($linkend)">
        <xsl:value-of select="concat('#', $linkend)"/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- == db.xref.tooltip ==================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db.xref.tooltip</name>
  <purpose>
    Generate the tooltip for a cross reference
  </purpose>
</template>

<xsl:template name="db.xref.tooltip">
  <xsl:param name="linkend" select="@linkend"/>
  <xsl:param name="target" select="key('idkey', $linkend)"/>
  <xsl:apply-templates mode="db.xref.tooltip.mode" select="$target"/>
</xsl:template>


<!-- == db.xref.tooltip.mode =============================================== -->

<xsl:template mode="db.xref.tooltip.mode" match="*" priority="-1"/>

<xsl:template mode="db.xref.tooltip.mode" match="*">
  <xsl:call-template name="db.title">
    <xsl:with-param name="node" select="."/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db.xref.tooltip.mode" match="glossentry">
  <xsl:call-template name="format.tooltip.glossentry">
    <xsl:with-param name="node" select="."/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
