<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes"/>
<!--Main template-->
<xsl:template match="/">
<xsl:choose>
  <xsl:when test="//error">
  <html lang="en">
    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    </head>
    <body>
      <xsl:apply-templates select="//error"/>
    </body>
  </html>
</xsl:when>
<xsl:otherwise>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <style>
      table,
      td,
      th,
      tr {
        border: 1px solid #000000;
      }
    </style>
  </head>
  <body>
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
  </body>
</html>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<!--Header template-->
<xsl:template name="headerT">
  <xsl:param name="season_name"/>
  <xsl:param name="competition"/>
  <xsl:param name="date"/>
  <h1>Season <xsl:value-of select="$season_name"/></h1>
  <h3>Competition: <xsl:value-of select="$competition/name"/></h3>
  <p>Gender:<xsl:value-of select="$competition/gender"/></p>
  <h4>Year <xsl:value-of select="$date/year"/>. From <xsl:value-of select="$date/start"/> to <xsl:value-of select="$date/end"/></h4>
  <hr></hr>
</xsl:template>

<!--Stages template-->
<xsl:template name="stagesT">
  <xsl:param name="stages"/>
  <xsl:for-each select="$stages/stage">
    <hr></hr>
    <h4><xsl:value-of select="./@phase"/>. From <xsl:value-of select="./@start_date"/> to <xsl:value-of select="./@end_date"/></h4>
    <hr></hr>
    <h4>Competitors:</h4>
    <ul>
      <xsl:for-each select="./groups/group/competitor"><!-- for each of competitors-->
        <li><xsl:value-of select="./name"/> (<xsl:value-of select="./abbreviation"/>)</li>
      </xsl:for-each>
    </ul>
  </xsl:for-each>
</xsl:template>

<!--Teams template-->
<xsl:template name="teamsT">
  <xsl:param name="teams"/>
  <h4>Teams:</h4>
  <xsl:for-each select="$teams/competitor"><!-- for each of teams-->
  <h4><xsl:value-of select="./name"/></h4>
  <h5>Players:</h5>
  <table>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Date of birth</th>
      <th>Nationality</th>
      <th>Events played</th>
    </tr>
    <!-- for each ordered by events_played descendant-->
  <xsl:for-each select="./players/player"> <!-- for each of players-->
    <xsl:sort select="./events_played" order="descending"/>
    <tr>
      <td><xsl:value-of select="./name"/></td><!--Name-->
      <td><xsl:value-of select="./type"/></td><!--Type-->
      <td><xsl:value-of select="./date_of_birth"/></td><!--Date of birth-->
      <td><xsl:value-of select="./nationality"/></td><!--Nationality-->
      <td><xsl:value-of select="./events_played"/></td><!--Events played-->
    </tr>
  </xsl:for-each>
  </table>
  <hr></hr>
</xsl:for-each>
</xsl:template>

<!--Error template-->
<xsl:template match="error">
  <h1>Error:</h1>
  <p><xsl:value-of select="."/></p>
</xsl:template>

</xsl:stylesheet>
