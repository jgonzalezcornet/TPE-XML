# IMPORTANTE : falta el manejo de errores en todos los pasos del programa

#!/bin/bash
API_KEY="xrbr4d7jguscwkdg7hu393gt"

#Get seasons_aux.xml file from API
curl -X GET "https://api.sportradar.us/rugby-league/trial/v3/en/seasons.xml?api_key=${API_KEY}" -o seasons_aux.xml

#Remove the XML Schema Namespace from seasons_aux.xml (new final file created: seasons.xml)
sed 's/xmlns:xsi="http:\/\/www\.w3\.org\/2001\/XMLSchema-instance"//; 
     s/generated_at="[^"]*"//; s/xmlns="http:\/\/schemas\.sportradar\.com\/sportsapi\/rugby-league\/v3"//; 
     s/xsi:schemaLocation="[^"]*"//' seasons_aux.xml > seasons.xml 

#Delete aux file
rm seasons_aux.xml

#Get the season_id (via extract_season_id.xq) and assign it to local variable "id"
id=$(java net.sf.saxon.Query extract_season_id.xq -ext season_year=$2 season_prefix=$1 \!method=text)

#Get season_info_aux.xml
curl -X GET "https://api.sportradar.us/rugby-league/trial/v3/en/seasons/$id/info.xml?api_key=${API_KEY}" -o season_info_aux.xml

#Get season_lineups_aux.xml
curl -X GET "https://api.sportradar.us/rugby-league/trial/v3/en/seasons/$id/lineups.xml?api_key=${API_KEY}" -o season_lineups_aux.xml

#Remove the XML Schema NameSpace from season_info.xml and season_lineups.xml
sed 's/xmlns:xsi="http:\/\/www\.w3\.org\/2001\/XMLSchema-instance"//; 
     s/generated_at="[^"]*"//; s/xmlns="http:\/\/schemas\.sportradar\.com\/sportsapi\/rugby-league\/v3"//; 
     s/xsi:schemaLocation="[^"]*"//' season_info_aux.xml > season_info.xml 
     
sed 's/xmlns:xsi="http:\/\/www\.w3\.org\/2001\/XMLSchema-instance"//; 
     s/generated_at="[^"]*"//; s/xmlns="http:\/\/schemas\.sportradar\.com\/sportsapi\/rugby-league\/v3"//; 
     s/xsi:schemaLocation="[^"]*"//' season_lineups_aux.xml > season_lineups.xml 

#Delete aux files
rm season_info_aux.xml
rm season_lineups_aux.xml

#Generate season_data.xml (via extract_season_data.xq)
java net.sf.saxon.Query extract_season_data.xq > season_data.xml

#Generate season_page.md (via generate_markdown.xsl)
java net.sf.saxon.Transform season_data.xml generate_markdown.xsl > season_page.md
