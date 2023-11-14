declare function local:get_groups($stage as element()*) as element()* {
        for $group in $stage//group
        return element group {
                for $competitor in $group//competitor
                return
                <competitor id="{$competitor/@id}">
                        <name>{data($competitor/@name)}</name>
                        <abbreviation>{data($competitor/@abbreviation)}</abbreviation>
                </competitor>
        }
};

declare function local:get_stages($file as document-node()) as element()* {
        for $stage in $file//stage
        return element stage {
                attribute phase {$stage/@phase},
                attribute start_date {$stage/@start_date},
                attribute end_date {$stage/@end_date},
                <groups>{local:get_groups($stage)}</groups>
        }
};

declare function local:get_players($file as document-node(), $competitor as element()*) as element()* {
        let $players_id := $file//competitor[@id=$competitor/@id]//player/@id
        for $player_id in distinct-values($players_id)
        let $player := ($file//player[@id = $player_id])[1]
        return element player {
                <name>{data($player/@name)}</name>,
                <type>{data($player/@type)}</type>,
                <date_of_birth>{data($player/@date_of_birth)}</date_of_birth>,
                <nationality>{data($player/@nationality)}</nationality>,
                <events_played>{count($file//player[@id=$file//player[@id=$player_id][1]/@id and @played="true"])}</events_played>
        }
};

declare function local:get_competitors_lineup($file as document-node(), $competitors as element()*) as element()* {
        for $competitor in $competitors
        return element competitor {
                attribute id {$competitor/@id},
                <name>{data($competitor/@name)}</name>,
                <players>{local:get_players($file, $competitor)}</players>
        }
};

let $info_doc := doc('season_info.xml')
let $info_root := doc('season_info.xml')/season_info
let $lineups_doc := doc('season_lineups.xml')
let $lineups_root := doc('season_lineups.xml')/season_lineups

let $info_season := doc('season_info.xml')//season
let $competition := $info_season/competition
let $competitors := $info_root/stages/stage/groups/group/competitors

let $data:= (

<season_data>
        <resultT>
                <season>
                        <name>{data($info_season/@name)}</name>
                        <competition>
                                <name>{data($competition/@name)}</name>
                                <gender>{data($competition/@gender)}</gender>
                        </competition>
                        <date>
                                <start>{data($info_season/@start_date)}</start>
                                <end>{data($info_season/@end_date)}</end>
                                <year>{data($info_season/@year)}</year>
                        </date>
                </season>

                <stages>
                        {local:get_stages($info_doc)}
                </stages>

                <competitors>
                        {local:get_competitors_lineup($lineups_doc, $competitors)}
                </competitors>

        </resultT>
</season_data>
)

return $data
