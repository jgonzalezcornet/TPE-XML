declare variable $season_year as xs:string external;
declare variable $season_prefix as xs:string external;

let $season := doc('seasons.xml')//season[@year=$season_year and starts-with(@name,$season_prefix)]
return data($season/@id)                       
