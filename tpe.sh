#!/bin/bash
API_KEY="xrbr4d7jguscwkdg7hu393gt"
SEASON_URL="https://api.sportradar.us/rugby-league/trial/v3/en/seasons.xml?api_key={API_KEY}"

#Get seasons.xml file from API
curl -X GET $SEASON_URL

#Ask the user for season_year
echo "Enter the season year"
read year

#Ask the user for season_prefix
echo "Enter the season prefix"
read prefix

#Get the season_id (via extract_season_id.xq) and assign it to local variable "id"
$id=(java net.sf.saxon.Query extract_season_id.xq java net.sf.saxon.Query extract_season_id.xq -ext season_year=$year season_prefix=$prefix)

#Get season_info.xml
$ curl -X GET "https://api.sportradar.us/rugby-league/trial/v3/en/seasons/$id/info.xml?api_key={$API_KEY}" > season_info.xml

#Get season_lineups.xml
$ curl -X GET "https://api.sportradar.us/rugby-league/trial/v3/en/seasons/$id/lineups.xml?api_key={$API_KEY}" > season_lineups.xml

#Generate season_data.xml (via extract_season_data.xq)
java net.sf.saxon.Query extract_season_data.xq > season_data.xml

#Generate season_page.md (via generate_markdown.xsl)
