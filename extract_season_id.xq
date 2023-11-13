declare variable $season_year as xs:string external;
declare variable $season_prefix as xs:string external;

let $y := doc('seasons.xml')//season[@year=$season_year and starts-with(@name,$season_prefix)]
return
        for $season in $y
        return data($season/@id)
