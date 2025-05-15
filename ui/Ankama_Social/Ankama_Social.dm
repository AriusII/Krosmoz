<module>
    <!-- Information about the module -->
    <header>
        <!-- Name displayed in modules list -->
        <name>Social</name>
        
        <!-- Module's version -->
        <version>0.1</version>

        <!-- Last Dofus version that works with -->
        <dofusVersion>2.0</dofusVersion>

        <!-- Author of the module -->
        <author>Ankama</author>

        <!-- A short description -->
        <shortDescription>ui.module.social.shortDesc</shortDescription>

        <!-- Detailled description -->
        <description></description>
	</header>

	<uiGroup name="socialCreator" exclusive="true" permanent="true" />
	<uiGroup name="socialBase" exclusive="true" permanent="false" />
	<uiGroup name="socialCards" exclusive="false" permanent="true" />

    <uis group="socialCreator">
        <ui name="guildCreator" 				file="xml/guildCreator.xml" class="ui::GuildCreator" />
        <ui name="allianceCreator" 				file="xml/allianceCreator.xml" class="ui::AllianceCreator" />
    </uis>

    <uis group="socialCards">
        <ui name="guildCard" 					file="xml/guildCard.xml" class="ui::GuildCard" />
        <ui name="allianceCard" 				file="xml/allianceCard.xml" class="ui::AllianceCard" />
    </uis>

    <uis group="socialBase">
        <ui name="socialBase" 					file="xml/socialBase.xml" class="ui::SocialBase" />
        
        <ui name="friends" 						file="xml/friends.xml" class="ui::Friends" />
        <ui name="spouse" 						file="xml/spouse.xml" class="ui::Spouse" />
        <ui name="guild" 						file="xml/guild.xml" class="ui::Guild" />
        <ui name="alliance" 					file="xml/alliance.xml" class="ui::Alliance" />
        <ui name="directory" 					file="xml/directory.xml" class="ui::Directory" />

        <ui name="ponyXmlItem"					file="xml/item/ponyXmlItem.xml" class="ui.items::PonyXmlItem" />
        <ui name="allianceFightXmlItem"			file="xml/item/allianceFightXmlItem.xml" class="ui.items::AllianceFightXmlItem" />

        <ui name="guildMembers" 				file="xml/guildMembers.xml" class="ui::GuildMembers" />
        <ui name="guildMemberRights" 			file="xml/guildMemberRights.xml" class="ui::GuildMemberRights" />
        <ui name="guildPersonalization" 		file="xml/guildPersonalization.xml" class="ui::GuildPersonalization" />
        <ui name="guildTaxCollector" 			file="xml/guildTaxCollector.xml" class="ui::GuildTaxCollector" />
        <ui name="guildPaddock" 				file="xml/guildPaddock.xml" class="ui::GuildPaddock" />
        <ui name="guildHouses" 					file="xml/guildHouses.xml" class="ui::GuildHouses" />        
        
        <ui name="allianceMembers"				file="xml/allianceMembers.xml" class="ui::AllianceMembers" />        
        <ui name="allianceAreas"				file="xml/allianceAreas.xml" class="ui::AllianceAreas" />        
        <ui name="allianceFights"				file="xml/allianceFights.xml" class="ui::AllianceFights" />        
    </uis>
    
    <script>Social.swf</script>
    
</module> 