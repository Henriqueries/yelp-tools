<?xml version='1.0' encoding='UTF-8'?><!-- -*- indent-tabs-mode: nil -*- -->
<!--
This program is free software; you can redistribute it and/or modify it under
the terms of the GNU Lesser General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
details.

You should have received a copy of the GNU Lesser General Public License
along with this program; see the file COPYING.LGPL.  If not, write to the
Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
02111-1307, USA.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                xmlns:msg="http://www.gnome.org/~shaunm/gnome-doc-utils/l10n"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Block-Level Elements</doc:title>


<!-- == db2html.programlisting.background_color ============================ -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.programlisting.background_color</name>
  <purpose>
    The background color for <sgmltag>programlisting</sgmltag> elements
  </purpose>
</parameter>

<xsl:param name="db2html.programlisting.background_color" select="'#EEEEEE'"/>


<!-- == db2html.programlisting.border_color ================================ -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.programlisting.border_color</name>
  <purpose>
    The border color for <sgmltag>programlisting</sgmltag> elements
  </purpose>
</parameter>

<xsl:param name="db2html.programlisting.border_color" select="'#DDDDDD'"/>


<!-- == db2html.screen.background_color ==================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.screen.background_color</name>
  <purpose>
    The background color for <sgmltag>screen</sgmltag> elements
  </purpose>
</parameter>

<xsl:param name="db2html.screen.background_color" select="'#EEEEEE'"/>


<!-- == db2html.screen.border_color ======================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.screen.border_color</name>
  <purpose>
    The border color for <sgmltag>screen</sgmltag> elements
  </purpose>
</parameter>

<xsl:param name="db2html.screen.border_color" select="'#DDDDDD'"/>


<!-- == db2html.block ====================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.block</name>
  <purpose>
    Format a block-level element
  </purpose>
  <parameter>
    <name>indent</name>
    <purpose>
      Whether this block should be indented
    </purpose>
  </parameter>
  <parameter>
    <name>verbatim</name>
    <purpose>
      Whether to maintain whitespace verbatim
    </purpose>
  </parameter>
</template>

<xsl:template name="db2html.block">
  <xsl:param name="indent" select="false()"/>
  <xsl:param name="verbatim" select="false()"/>
  <div>
    <xsl:attribute name="class">
      <xsl:value-of select="local-name(.)"/>
      <xsl:if test="$indent">
        <xsl:text> block-indent</xsl:text>
      </xsl:if>
      <xsl:if test="$verbatim">
        <xsl:text> block-verbatim</xsl:text>
      </xsl:if>
    </xsl:attribute>
    <xsl:call-template name="db2html.anchor"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>


<!-- == db2html.blockquote ================================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.blockquote</name>
  <purpose>
    Render a blockquote for an element
  </purpose>
</template>

<xsl:template name="db2html.blockquote">
  <div class="{local-name(.)} block-indent">
    <xsl:apply-templates select="title"/>
    <blockquote class="{local-name(.)}">
      <xsl:apply-templates
       select="*[name(.) != 'title' and name(.) != 'attribution']"/>
    </blockquote>
    <xsl:apply-templates select="attribution"/>
  </div>
</xsl:template>


<!-- == db2html.para ======================================================= -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.para</name>
  <purpose>
    Format an element as a paragraph
  </purpose>
</template>

<xsl:template name="db2html.para">
  <p class="{local-name(.)}">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:apply-templates/>
  </p>
</xsl:template>


<!-- == db2html.pre ======================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.pre</name>
  <purpose>
    Format an element in a <xmltag>pre</xmltag> tag
  </purpose>
  <parameter>
    <name>indent</name>
    <purpose>
      Whether this block should be indented
    </purpose>
  </parameter>
</template>

<xsl:template name="db2html.pre">
  <xsl:param name="indent" select="false()"/>
  <!-- FIXME:
  @width
  @language
  @continuation
  @format
  @startinglinenumber
  -->
  <div>
    <xsl:attribute name="class">
      <xsl:value-of select="local-name(.)"/>
      <xsl:if test="$indent">
        <xsl:text> block-indent</xsl:text>
      </xsl:if>
    </xsl:attribute>
    <xsl:call-template name="db2html.anchor"/>
    <xsl:if test="@linenumbering = 'numbered'">
      <pre class="linenumbering" style="float: left; text-align: right;"><xsl:call-template name="db.linenumbering"/></pre>
    </xsl:if>
    <pre class="{local-name(.)}">
      <!-- Strip off a leading newline -->
      <xsl:if test="node()[1]/self::text()">
        <xsl:choose>
          <!-- CR LF -->
          <xsl:when test="starts-with(text()[1], '&#x000D;&#x000A;')">
            <xsl:value-of select="substring-after(text()[1], '&#x000D;&#x000A;')"/>
          </xsl:when>
          <!-- CR -->
          <xsl:when test="starts-with(text()[1], '&#x000D;')">
            <xsl:value-of select="substring-after(text()[1], '&#x000D;')"/>
          </xsl:when>
          <!-- LF -->
          <xsl:when test="starts-with(text()[1], '&#x000A;')">
            <xsl:value-of select="substring-after(text()[1], '&#x000A;')"/>
          </xsl:when>
          <!-- NEL -->
          <xsl:when test="starts-with(text()[1], '&#x0085;')">
            <xsl:value-of select="substring-after(text()[1], '&#x0085;')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="text()[1]"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:apply-templates select="node()[not(position() = 1 and self::text())]"/>
    </pre>
  </div>
</xsl:template>


<!-- == db2html.block.css ================================================== -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.block.css</name>
  <purpose>
    Create CSS for the block elements
  </purpose>
</template>

<xsl:template name="db2html.block.css">
  <xsl:text>
    *[class~="block-indent"] {
      margin-left: 1.72em;
      margin-right: 1em;
    }
    *[class~="block-indent"] *[class~="block-indent"] {
      margin-left: 0em;
      margin-right: 0em;
    }
    *[class~="block-verbatim"] {
      white-space: pre;
    }
    pre[class~="programlisting"] {
      padding: 6px;
      -moz-border-radius: 8px;
      overflow: auto;</xsl:text>
      <xsl:if test="string($db2html.programlisting.background_color) != ''">
        <xsl:text>background-color: </xsl:text>
        <xsl:value-of select="$db2html.programlisting.background_color"/>
      </xsl:if>
      <xsl:text>;</xsl:text>
      <xsl:if test="string($db2html.programlisting.border_color) != ''">
        <xsl:text>border: solid 1px </xsl:text>
        <xsl:value-of select="$db2html.programlisting.border_color"/>
      </xsl:if>
      <xsl:text>
    }
    pre[class~="screen"] {
      padding: 6px;
      -moz-border-radius: 8px;
      overflow: auto;</xsl:text>
      <xsl:if test="string($db2html.screen.background_color) != ''">
        <xsl:text>background-color: </xsl:text>
        <xsl:value-of select="$db2html.screen.background_color"/>
      </xsl:if>
      <xsl:text>;</xsl:text>
      <xsl:if test="string($db2html.screen.border_color) != ''">
        <xsl:text>border: solid 1px </xsl:text>
        <xsl:value-of select="$db2html.screen.border_color"/>
      </xsl:if>
      <xsl:text>
    }
    pre[class~="synopsis"] {
      overflow: auto;
    }
    pre[class~="linenumbering"] {
      <!-- This margin is important to get the line numbering
      to line up vertically with the content. -->
      padding-top: 6px;
      padding-bottom: 6px;
      -moz-border-radius: 8px;
      border: solid 1px black;
      margin-top: 0px;
      margin-left: 0.83em;
      background-color: black;
      color: white;
      -moz-opacity: .3;
      padding-right: 0.4em;
      padding-left: 0.4em;
    }
    dt[class~="glossterm"] { margin-left: 0em; }
    dd + dt[class~="glossterm"] { margin-top: 2em; }
    dd[class~="glossdef"]
      { margin-top: 1em; margin-left: 2em; margin-right: 1em; }
    dd[class~="glosssee"]
      { margin-top: 1em; margin-left: 2em; margin-right: 1em; }
    dd[class~="glossseealso"]
      { margin-top: 1em; margin-left: 2em; margin-right: 1em; }
  </xsl:text>
</xsl:template>


<!-- Matched Templates ===================================================== -->

<!-- = abstract = -->
<xsl:template match="abstract">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = ackno = -->
<xsl:template match="ackno">
  <xsl:call-template name="db2html.para"/>
</xsl:template>

<!-- = address = -->
<xsl:template match="address">
  <xsl:call-template name="db2html.block">
    <xsl:with-param name="verbatim" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = attribution = -->
<xsl:template match="attribution">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = blockquote = -->
<xsl:template match="blockquote">
  <xsl:call-template name="db2html.blockquote"/>
</xsl:template>

<!-- = caption = -->
<xsl:template match="caption">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = epigraph = -->
<xsl:template match="epigraph">
  <xsl:call-template name="db2html.blockquote"/>
</xsl:template>

<!-- = equation = -->
<xsl:template match="equation">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = example = -->
<xsl:template match="example">
  <xsl:call-template name="db2html.block">
    <xsl:with-param name="indent" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = figure = -->
<xsl:template match="figure">
  <xsl:call-template name="db2html.block">
    <xsl:with-param name="indent" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = formalpara = -->
<xsl:template match="formalpara">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = glossdef = -->
<xsl:template match="glossdef">
  <dd class="glossdef">
    <xsl:apply-templates select="*[local-name(.) != 'glossseealso']"/>
  </dd>
  <xsl:apply-templates select="glossseealso[1]"/>
</xsl:template>

<!-- = glossentry = -->
<xsl:template match="glossentry">
  <dt class="glossterm">
    <xsl:apply-templates select="glossterm"/>
  </dt>
  <xsl:apply-templates select="glossdef | glosssee[1]"/>
</xsl:template>

<!-- = glosssee = -->
<xsl:template match="glosssee | glossseealso">
  <dd class="{local-name(.)}">
    <p>
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="concat(local-name(.), '.format')"/>
        <xsl:with-param name="node" select="."/>
        <xsl:with-param name="format" select="true()"/>
      </xsl:call-template>
    </p>
  </dd>
</xsl:template>

<xsl:template mode="l10n.format.mode" match="msg:glosssee">
  <xsl:param name="node"/>
  <xsl:for-each select="$node |
                        $node/following-sibling::*[name(.) = name($node)]">
    <xsl:if test="position() != 1">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="', '"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@otherterm">
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="db.xref.target">
              <xsl:with-param name="linkend" select="@otherterm"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:call-template name="db.xref.tooltip">
              <xsl:with-param name="linkend" select="@otherterm"/>
            </xsl:call-template>
          </xsl:attribute>
        </a>
        <xsl:choose>
          <xsl:when test="normalize-space(.) != ''">
            <xsl:apply-templates/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="db.xref.content">
              <xsl:with-param name="linkend" select="@otherterm"/>
              <xsl:with-param name="role" select="'glosssee'"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<xsl:template mode="l10n.format.mode" match="msg:glosssterm">
  <xsl:param name="node"/>
  <xsl:apply-templates select="$node/glossterm"/>
</xsl:template>

<!-- = highlights = -->
<xsl:template match="highlights">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = informalequation = -->
<xsl:template match="informalequation">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = informalexample = -->
<xsl:template match="informalexample">
  <xsl:call-template name="db2html.block"/>
</xsl:template>

<!-- = literallayout = -->
<xsl:template match="literallayout">
  <xsl:call-template name="db2html.block">
    <xsl:with-param name="verbatim" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = para = -->
<xsl:template match="para">
  <xsl:call-template name="db2html.para"/>
</xsl:template>

<!-- = programlisting = -->
<xsl:template match="programlisting">
  <xsl:call-template name="db2html.pre">
    <xsl:with-param name="indent" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = screen = -->
<xsl:template match="screen">
  <xsl:call-template name="db2html.pre">
    <xsl:with-param name="indent" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = simpara = -->
<xsl:template match="simpara">
  <xsl:call-template name="db2html.para"/>
</xsl:template>

<!-- = synopsis = -->
<xsl:template match="synopsis">
  <xsl:call-template name="db2html.pre">
    <xsl:with-param name="indent" select="true()"/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
