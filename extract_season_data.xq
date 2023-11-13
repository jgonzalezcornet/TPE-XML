(: Declaring local variables for easier access :)
let $season_info_root := doc('season_info.xml')/season_info
let $season_info_season := doc('season_info.xml')//season
let $competition := $season/competition
let $season_lineups_root := doc('season_lineups.xml')/season_lineups

let $data:= (

<season_data>
	<resultT>
		<season>
			<name>{data($season_info_season/@name)}</name>
			<competition>
				<name>{data($competition/@name)}</name>
				<gender>{data($competition/@gender)<gender>
			</competition>
			<date>
				<start>{data($season_info_season/@start_date)}</start>
				<end>{data($season_info_season/@end_date)}</end>
				<year>{data($season_info_season/@year)}</year>
			</date>
		</season>
		<stages>
		{
		  for $stage in $season_info_root/stages/stage
			return
				<stage phase="{$stage/@phase}" start_date="{$stage/@start_date}" end_date="{$stage/@end_date}">
					<groups>
					{
					for $group in $stage/groups/group
					return
						<group>
						{
						for $competitor in $group/competitors/competitor
						return
							<competitor id="{$competitor/@id}>
								<name>{data($competitor/@name)}</name>
								<abbreviation>{data($competitor/@abbreviation)}</abbreviation>
							</competitor>
						}
 						</group>
					}
					</groups>
				</stage>
			}
			</stages>
  
      (: List of competitors with their corresponding players missing. :)

	</resultT>
</season_data>
)

return $data
