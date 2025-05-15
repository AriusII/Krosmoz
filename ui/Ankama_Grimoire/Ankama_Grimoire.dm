<module>
    <!-- Information about the module -->
    <header>
        <!-- Name displayed in modules list -->
        <name>Grimoire</name>
        
        <!-- Module's version -->
        <version>0.1</version>

        <!-- Last Dofus version that works with -->
        <dofusVersion>2.0</dofusVersion>

        <!-- Author of the module -->
        <author>Ankama</author>

        <!-- A short description -->
        <shortDescription>ui.module.grimoire.shortDesc</shortDescription>

        <!-- Detailled description -->
        <description></description>
	</header>
	
	<uiGroup name="grimoire" exclusive="true" permanent="false" />
	
	<uis group="grimoire">
		<ui name="book" 				file="ui/book.xml" 						class="ui::Book"/>
		<ui name="spellTab" 			file="ui/spellTab.xml" 					class="ui::SpellTab"/>
		<ui name="objectTab" 		    file="ui/objectTab.xml" 				class="ui::ObjectTab"/>
		<ui name="alignmentTab"		file="ui/alignmentTab.xml"				class="ui::AlignmentTab"/>
		<ui name="bestiaryTab" 			file="ui/bestiaryTab.xml"				class="ui::BestiaryTab"	/>
		<ui name="questTab" 			file="ui/questTab.xml"					class="ui::QuestTab"/>
		<ui name="jobTab" 				file="ui/jobTab.xml"					class="ui::JobTab"/>
		<ui name="krosmasterTab" 				file="ui/krosmasterTab.xml"					class="ui::KrosmasterTab"/>
		<ui name="krosmasterCardViewer" 				file="ui/krosmasterCardViewer.xml"					class="ui::KrosmasterCardViewer"/>
		<ui name="calendarTab" 			file="ui/calendarTab.xml"					class="ui::CalendarTab"/>
		<ui name="achievementTab" 			file="ui/achievementTab.xml"					class="ui::AchievementTab"/>
		<ui name="titleTab" 			file="ui/titleTab.xml"					class="ui::TitleTab"/>
		<ui name="jobCraftOptions" 		file="ui/jobCraftOptions.xml"			class="ui::JobCraftOptions"/>
		<ui name="jobRecipeItem" 			file="ui/items/jobRecipeItem.xml" 			class="ui.items::JobRecipeItem" />
		<ui name="skillItem" 			file="ui/items/skillItem.xml" 			class="ui.items::SkillItem" />
		<ui name="giftXmlItem"		file="ui/items/giftXmlItem.xml"		class="ui.items::GiftXmlItem" />
	</uis>
	
	<script>Grimoire.swf</script>
	
</module> 