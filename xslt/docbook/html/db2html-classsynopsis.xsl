<?xml version='1.0' encoding='utf-8'?><!-- -*- indent-tabs-mode: nil -*- -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
                exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Class Synopses</doc:title>


<!-- == Variables ========================================================== -->
<!-- == (possible candidates for params) == -->

<xsl:variable name="cpp.tab" select="'&#160;&#160;&#160;&#160;'"/>
<xsl:variable name="python.tab" select="'&#160;&#160;&#160;&#160;'"/>


<!-- == db2html.classsynopsis.language ===================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.classsynopsis.language</name>
  <description>
    The default language for <xmltag>classsynopsis</xmltag> elements
  </description>
</parameter>

<xsl:param name="db2html.classsynopsis.language">
  <xsl:choose>
    <xsl:when test="processing-instruction('db2html.classsynopsis.language')">
      <xsl:value-of
       select="processing-instruction('db2html.classsynopsis.language')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'cpp'"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>


<!-- == Matched Templates ================================================== -->

<!-- = *synopsis = -->
<xsl:template match="
              classsynopsis  | constructorsynopsis | fieldsynopsis |
              methodsynopsis | destructorsynopsis  ">
  <xsl:param name="language">
    <xsl:choose>
      <xsl:when test="@language">
        <xsl:value-of select="@language"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$db2html.classsynopsis.language"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <div class="{local-name(.)}">
    <xsl:call-template name="db2html.anchor"/>
    <pre class="$language">
      <xsl:choose>
        <xsl:when test="$language = 'cpp'">
          <xsl:apply-templates mode="db2html.class.cpp.mode" select="."/>
        </xsl:when>
        <xsl:when test="$language = 'python'">
          <xsl:apply-templates mode="db2html.class.cpp.mode" select="."/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            <xsl:text>No information about the language '</xsl:text>
            <xsl:value-of select="$language"/>
            <xsl:text>' for classsynopsis.</xsl:text>
          </xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </pre>
  </div>
</xsl:template>

<!-- = classsynopsisinfo = -->
<xsl:template match="classsynopsisinfo">
  <xsl:apply-templates/>
</xsl:template>

<!-- = ooclass = -->
<xsl:template match="ooclass">
  <span class="ooclass" style="font-family: monospace;">
    <xsl:for-each select="modifier | classname">
      <xsl:if test="position() != 1">
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </span>
</xsl:template>

<!-- = ooexception = -->
<xsl:template match="ooexception">
  <span class="ooexception" style="font-family: monospace;">
    <xsl:for-each select="modifier | exceptionname">
      <xsl:if test="position() != 1">
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </span>
</xsl:template>

<!-- = oointerface = -->
<xsl:template match="oointerface">
  <span class="oointerface" style="font-family: monospace;">
    <xsl:for-each select="modifier | interfacename">
      <xsl:if test="position() != 1">
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </span>
</xsl:template>

<!-- = methodparam/parameter = -->
<xsl:template match="methodparam/parameter">
  <xsl:call-template name="db2html.inline">
    <xsl:with-param name="mono" select="true()"/>
    <xsl:with-param name="italic" select="true()"/>
  </xsl:call-template>
</xsl:template>


<!-- == class.cpp.modifier ================================================= -->

<xsl:template name="class.cpp.modifier" doc:private="true">
  <!-- For C++, we expect the first modifier to be the visibility -->
  <xsl:if test="../self::classsynopsis">
    <xsl:variable name="pres" select="
                  preceding-sibling::constructorsynopsis |
                  preceding-sibling::destructorsynopsis  |
                  preceding-sibling::fieldsynopsis       |
                  preceding-sibling::methodsynopsis      "/>
    <xsl:if test="not($pres[modifier][last()][modifier[1] = current()/modifier[1]])">
      <xsl:if test="$pres">
        <xsl:text>&#x000A;</xsl:text>
      </xsl:if>
      <xsl:apply-templates select="modifier[1]"/>
      <xsl:text>:&#x000A;</xsl:text>
    </xsl:if>
  </xsl:if>
</xsl:template>


<!-- == db2html.class.cpp.mode ============================================= -->

<xsl:template mode="db2html.class.cpp.mode" match="*">
  <xsl:apply-templates select="."/>
</xsl:template>

<!-- = classsynopsis =
element classsynopsis {
  common.attrib, role.attrib,
  attribute language { "cpp" }?,
  attribute class { "class" }?,
  ooclass+,
  (classsynopsisinfo   |
   constructorsynopsis |
   destructorsynopsis  |
   fieldsynopsis       |
   methodsynopsis      )
}
-->
<xsl:template mode="db2html.class.cpp.mode" match="classsynopsis">
  <xsl:if test="@class = 'class' or not(@class)">
    <span class="ooclass">
      <xsl:for-each select="ooclass[1]/modifier">
        <xsl:if test="position() != 1">
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:apply-templates mode="db2html.class.cpp.mode" select="."/>
      </xsl:for-each>
      <xsl:text> class </xsl:text>
      <xsl:apply-templates mode="db2html.class.cpp.mode"
                           select="ooclass[1]/classname"/>
    </span>
    <xsl:if test="ooclass[2]">
      <xsl:text> : </xsl:text>
      <xsl:for-each select="ooclass[position() != 1]">
        <xsl:if test="position() != 1">
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:apply-templates mode="db2html.class.cpp.mode" select="."/>
      </xsl:for-each>
    </xsl:if>
    <xsl:text>&#x000A;{&#x000A;</xsl:text>
    <xsl:apply-templates mode="db2html.class.cpp.mode"
                         select="
                           classsynopsisinfo   |
                           constructorsynopsis | destructorsynopsis |
                           fieldsynopsis       | methodsynopsis     "/>
    <xsl:text>}&#x000A;</xsl:text>
  </xsl:if>
</xsl:template>

<!-- = constructorsynopsis =
element constructorsynopsis {
  common.attrib, role.attrib,
  attribute language { "cpp" }?,
  modifier+,
  methodname?,
  (methodparam+ | void?)
}
-->
<xsl:template mode="db2html.class.cpp.mode" match="constructorsynopsis">
  <xsl:call-template name="class.cpp.modifier"/>
  <xsl:value-of select="$cpp.tab"/>
  <xsl:for-each select="modifier[position() != 1]">
    <xsl:if test="position() != 1">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.cpp.mode" select="."/>
  </xsl:for-each>
  <xsl:if test="modifier[2]">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="methodname">
      <xsl:apply-templates mode="db2html.class.cpp.mode" select="methodname"/>
    </xsl:when>
    <xsl:when test="../self::classsynopsis[ooclass]">
      <span class="methodname">
        <xsl:value-of select="../ooclass/classname"/>
      </span>
    </xsl:when>
  </xsl:choose>
  <xsl:text>(</xsl:text>
  <xsl:for-each select="methodparam">
    <xsl:if test="position() != 1">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.cpp.mode" select="."/>
  </xsl:for-each>
  <xsl:text>);&#x000A;</xsl:text>
</xsl:template>

<!-- = destructorsynopsis =
element destructorsynopsis {
  common.attrib, role.attrib,
  attribute language { "cpp" }?,
  modifier+,
  methodname?,
  (methodparam+ | void?)
}
-->
<xsl:template mode="db2html.class.cpp.mode" match="destructorsynopsis">
  <xsl:call-template name="class.cpp.modifier"/>
  <xsl:value-of select="$cpp.tab"/>
  <xsl:for-each select="modifier[position() != 1]">
    <xsl:if test="position() != 1">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.cpp.mode" select="."/>
  </xsl:for-each>
  <xsl:if test="modifier[2]">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="methodname">
      <xsl:apply-templates mode="db2html.class.cpp.mode" select="methodname"/>
    </xsl:when>
    <xsl:when test="../self::classsynopsis[ooclass]">
      <span class="methodname">
        <xsl:text>~</xsl:text>
        <xsl:value-of select="../ooclass/classname"/>
      </span>
    </xsl:when>
  </xsl:choose>
  <xsl:text>(</xsl:text>
  <xsl:for-each select="methodparam">
    <!-- FIXME: should we do each methodparam on its own line? -->
    <xsl:if test="position() != 1">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.cpp.mode" select="."/>
  </xsl:for-each>
  <xsl:text>);&#x000A;</xsl:text>
</xsl:template>

<!-- = fieldsynopsis =
element fieldsynopsis {
  common.attrib, role.attrib,
  attribute language { "cpp" }?,
  modifier+,
  type,
  varname,
  initializer?
}
-->
<xsl:template mode="db2html.class.cpp.mode" match="fieldsynopsis">
  <xsl:call-template name="class.cpp.modifier"/>
  <xsl:value-of select="$cpp.tab"/>
  <xsl:for-each select="modifier[position() != 1]">
    <xsl:if test="position() != 1">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.cpp.mode" select="."/>
  </xsl:for-each>
  <xsl:if test="modifier[2]">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:if test="type">
    <xsl:apply-templates mode="db2html.class.cpp.mode" select="type"/>
  </xsl:if>
  <xsl:if test="modifier[2] or type">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="db2html.class.cpp.mode" select="varname"/>
  <xsl:if test="initializer">
    <xsl:text> = </xsl:text>
    <xsl:apply-templates mode="db2html.class.cpp.mode" select="initializer"/>
  </xsl:if>
  <xsl:text>;&#x000A;</xsl:text>
</xsl:template>

<!-- = methodparam = -->
<xsl:template mode="db2html.class.cpp.mode" match="methodparam">
  <span class="methodparam">
    <xsl:for-each select="*">
      <xsl:if test="position() != 1">
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates mode="db2html.class.cpp.mode" select="."/>
    </xsl:for-each>
  </span>
</xsl:template>

<!-- = methodsynopsis =
element methodsynopsis {
  common.attrib, role.attrib,
  attribute language { "cpp" }?,
  modifier+,
  (type | void),
  methodname,
  (methodparam+ | void?)
}
-->
<xsl:template mode="db2html.class.cpp.mode" match="methodsynopsis">
  <xsl:call-template name="class.cpp.modifier"/>
  <xsl:value-of select="$cpp.tab"/>
  <!-- Parens for document order -->
  <xsl:for-each select="(methodname/preceding-sibling::modifier)[position() != 1]">
    <xsl:if test="position() != 1">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.cpp.mode" select="."/>
  </xsl:for-each>
  <xsl:if test="methodname/preceding-sibling::modifier[2]">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="db2html.class.cpp.mode" select="type | void"/>
  <xsl:text> </xsl:text>
  <xsl:apply-templates mode="db2html.class.cpp.mode" select="methodname"/>
  <xsl:text>(</xsl:text>
  <xsl:for-each select="methodparam">
    <xsl:if test="position() != 1">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.cpp.mode" select="."/>
  </xsl:for-each>
  <xsl:text>);&#x000A;</xsl:text>
</xsl:template>


<!-- == db2html.class.python.mode ========================================== -->

<xsl:template mode="db2html.class.python.mode" match="*">
  <xsl:apply-templates select="."/>
</xsl:template>

<!-- = classsynopsis = -->
<!--
<xsl:template mode="db2html.class.python.mode" match="classsynopsis">
  <xsl:if test="@class = 'class' or not(@class)">
    <span class="ooclass">
      <xsl:for-each select="ooclass[1]/modifier">
        <xsl:if test="position() != 1">
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:apply-templates mode="db2html.class.python.mode" select="."/>
      </xsl:for-each>
      <xsl:text> class </xsl:text>
      <xsl:apply-templates mode="db2html.class.python.mode"
                           select="ooclass[1]/classname"/>
    </span>
    <xsl:if test="ooclass[2]">
      <xsl:text> : </xsl:text>
      <xsl:for-each select="ooclass[position() != 1]">
        <xsl:if test="position() != 1">
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:apply-templates mode="db2html.class.python.mode" select="."/>
      </xsl:for-each>
    </xsl:if>
    <xsl:text>&#x000A;{&#x000A;</xsl:text>
    <xsl:apply-templates mode="db2html.class.python.mode"
                         select="
                           classsynopsisinfo   |
                           constructorsynopsis | destructorsynopsis |
                           fieldsynopsis       | methodsynopsis     "/>
    <xsl:text>}&#x000A;</xsl:text>
  </xsl:if>
</xsl:template>
-->

<!-- = constructorsynopsis = -->
<!--
<xsl:template mode="db2html.class.python.mode" match="constructorsynopsis">
  <xsl:call-template name="class.python.modifier"/>
  <xsl:value-of select="$cpp.tab"/>
  <xsl:for-each select="modifier[position() != 1]">
    <xsl:if test="position() != 1">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.python.mode" select="."/>
  </xsl:for-each>
  <xsl:if test="modifier[2]">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="methodname">
      <xsl:apply-templates mode="db2html.class.python.mode" select="methodname"/>
    </xsl:when>
    <xsl:when test="../self::classsynopsis[ooclass]">
      <span class="methodname">
        <xsl:value-of select="../ooclass/classname"/>
      </span>
    </xsl:when>
  </xsl:choose>
  <xsl:text>(</xsl:text>
  <xsl:for-each select="methodparam">
    <xsl:if test="position() != 1">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.python.mode" select="."/>
  </xsl:for-each>
  <xsl:text>);&#x000A;</xsl:text>
</xsl:template>
-->

<!-- = destructorsynopsis = -->
<!--
<xsl:template mode="db2html.class.python.mode" match="destructorsynopsis">
  <xsl:call-template name="class.python.modifier"/>
  <xsl:value-of select="$cpp.tab"/>
  <xsl:for-each select="modifier[position() != 1]">
    <xsl:if test="position() != 1">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.python.mode" select="."/>
  </xsl:for-each>
  <xsl:if test="modifier[2]">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="methodname">
      <xsl:apply-templates mode="db2html.class.python.mode" select="methodname"/>
    </xsl:when>
    <xsl:when test="../self::classsynopsis[ooclass]">
      <span class="methodname">
        <xsl:text>~</xsl:text>
        <xsl:value-of select="../ooclass/classname"/>
      </span>
    </xsl:when>
  </xsl:choose>
  <xsl:text>(</xsl:text>
  <xsl:for-each select="methodparam">
    <xsl:if test="position() != 1">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.python.mode" select="."/>
  </xsl:for-each>
  <xsl:text>);&#x000A;</xsl:text>
</xsl:template>
-->

<!-- = fieldsynopsis = -->
<!--
<xsl:template mode="db2html.class.python.mode" match="fieldsynopsis">
  <xsl:call-template name="class.python.modifier"/>
  <xsl:value-of select="$cpp.tab"/>
  <xsl:for-each select="modifier[position() != 1]">
    <xsl:if test="position() != 1">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.python.mode" select="."/>
  </xsl:for-each>
  <xsl:if test="modifier[2]">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:if test="type">
    <xsl:apply-templates mode="db2html.class.python.mode" select="type"/>
  </xsl:if>
  <xsl:if test="modifier[2] or type">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="db2html.class.python.mode" select="varname"/>
  <xsl:if test="initializer">
    <xsl:text> = </xsl:text>
    <xsl:apply-templates mode="db2html.class.python.mode" select="initializer"/>
  </xsl:if>
  <xsl:text>;&#x000A;</xsl:text>
</xsl:template>
-->

<!-- = methodparam = -->
<!--
<xsl:template mode="db2html.class.python.mode" match="methodparam">
  <span class="methodparam">
    <xsl:for-each select="*">
      <xsl:if test="position() != 1">
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates mode="db2html.class.python.mode" select="."/>
    </xsl:for-each>
  </span>
</xsl:template>
-->

<!-- = methodsynopsis = -->
<!--
<xsl:template mode="db2html.class.python.mode" match="methodsynopsis">
  <xsl:call-template name="class.python.modifier"/>
  <xsl:value-of select="$cpp.tab"/>
  <xsl:for-each select="modifier[position() != 1]">
    <xsl:if test="position() != 1">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.python.mode" select="."/>
  </xsl:for-each>
  <xsl:if test="modifier[2]">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="db2html.class.python.mode" select="type | void"/>
  <xsl:text> </xsl:text>
  <xsl:apply-templates mode="db2html.class.python.mode" select="methodname"/>
  <xsl:text>(</xsl:text>
  <xsl:for-each select="methodparam">
    <xsl:if test="position() != 1">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="db2html.class.python.mode" select="."/>
  </xsl:for-each>
  <xsl:text>);&#x000A;</xsl:text>
</xsl:template>
-->

</xsl:stylesheet>