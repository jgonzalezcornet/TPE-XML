<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" indent="yes"/>
<!--Main template-->
<xsl:template match="/">
<xsl:choose>
  <xsl:when test="//error">
      <xsl:apply-templates select="//error"/>
</xsl:when>
<xsl:otherwise>
    <xsl:call-template name="headerT"><!--calls header template-->
      <xsl:with-param name="season_name" select="//season/name"/>
      <xsl:with-param name="competition" select="//season/competition"/> <!--name and gender-->
      <xsl:with-param name="date" select="//season/date"/> <!--year, start and end date-->
    </xsl:call-template>
    <xsl:call-template name="stagesT"><!--calls stages template-->
      <xsl:with-param name="stages" select="//stages"/>
    </xsl:call-template>
    <xsl:call-template name="teamsT"><!--calls teams template-->
      <xsl:with-param name="teams" select="//competitors"/>
    </xsl:call-template>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<!--Header template-->
<xsl:template name="headerT">
  <xsl:param name="season_name"/>
  <xsl:param name="competition"/>
  <xsl:param name="date"/>
  # Season <xsl:value-of select="$season_name"/>
  ### Competition: <xsl:value-of select="$competition/name"/>
  Gender: <xsl:value-of select="$competition/gender"/>
  #### Year: <xsl:value-of select="$date/year"/>. From <xsl:value-of select="$date/start"/> to <xsl:value-of select="$date/end"/>
  ---
</xsl:template>

<!--Stages template-->
<xsl:template name="stagesT">
  <xsl:param name="stages"/>
  <xsl:for-each select="$stages/stage">
    ---
     #### <xsl:value-of select="./@phase"/>. From <xsl:value-of select="./@start_date"/> to <xsl:value-of select="./@end_date"/>
    ---
    #### Competitors:
    
    <xsl:for-each select="./groups/group/competitor"><!-- for each of competitors-->
      - <xsl:value-of select="./name"/> (<xsl:value-of select="./abbreviation"/>)
    </xsl:for-each>
    
  </xsl:for-each>
</xsl:template>

<!--Teams template-->
<xsl:template name="teamsT">
  <xsl:param name="teams"/>
  #### Teams:
  <xsl:for-each select="$teams/competitor"><!-- for each of teams-->
  #### <xsl:value-of select="./name"/>
  ##### Players:
    | Name | Type | Date of birth | Nationality | Events played |
    <!-- for each ordered by events_played descendant-->
  <xsl:for-each select="./players/player"> <!-- for each of players-->
    <xsl:sort select="./events_played" order="descending"/>
      | <xsl:value-of select="./name"/> | <xsl:value-of select="./type"/> | <xsl:value-of select="./date_of_birth"/> | <xsl:value-of select="./nationality"/> | <xsl:value-of select="./events_played"/> |
  </xsl:for-each>
  ---
</xsl:for-each>
</xsl:template>

<!--Error template-->
<xsl:template match="error">
  ### Error:
  
  <xsl:value-of select="."/>
</xsl:template>
</xsl:stylesheet>
