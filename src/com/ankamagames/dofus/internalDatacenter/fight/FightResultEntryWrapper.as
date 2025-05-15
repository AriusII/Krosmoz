package com.ankamagames.dofus.internalDatacenter.fight
{
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorFirstname;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorName;
   import com.ankamagames.dofus.network.types.game.context.fight.FightResultAdditionalData;
   import com.ankamagames.dofus.network.types.game.context.fight.FightResultExperienceData;
   import com.ankamagames.dofus.network.types.game.context.fight.FightResultFighterListEntry;
   import com.ankamagames.dofus.network.types.game.context.fight.FightResultListEntry;
   import com.ankamagames.dofus.network.types.game.context.fight.FightResultMutantListEntry;
   import com.ankamagames.dofus.network.types.game.context.fight.FightResultPlayerListEntry;
   import com.ankamagames.dofus.network.types.game.context.fight.FightResultPvpData;
   import com.ankamagames.dofus.network.types.game.context.fight.FightResultTaxCollectorListEntry;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterNamedInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightTaxCollectorInformations;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class FightResultEntryWrapper implements IDataCenter
   {
      private var _item:FightResultListEntry;
      
      public var outcome:int;
      
      public var id:int;
      
      public var name:String;
      
      public var alive:Boolean;
      
      public var rewards:FightLootWrapper;
      
      public var level:int;
      
      public var type:int;
      
      public var rerollXpMultiplicator:int;
      
      public var experience:Number;
      
      public var showExperience:Boolean = false;
      
      public var experienceLevelFloor:Number;
      
      public var showExperienceLevelFloor:Boolean = false;
      
      public var experienceNextLevelFloor:Number;
      
      public var showExperienceNextLevelFloor:Boolean = false;
      
      public var experienceFightDelta:Number;
      
      public var showExperienceFightDelta:Boolean = false;
      
      public var experienceForGuild:Number;
      
      public var showExperienceForGuild:Boolean = false;
      
      public var experienceForRide:Number;
      
      public var showExperienceForRide:Boolean = false;
      
      public var grade:uint;
      
      public var honor:uint;
      
      public var honorDelta:int = -1;
      
      public var maxHonorForGrade:uint;
      
      public var minHonorForGrade:uint;
      
      public var isIncarnationExperience:Boolean;
      
      public function FightResultEntryWrapper(param1:FightResultListEntry, param2:GameFightFighterInformations = null)
      {
         var _loc3_:FightResultPlayerListEntry = null;
         var _loc4_:FightResultTaxCollectorListEntry = null;
         var _loc5_:GameFightTaxCollectorInformations = null;
         var _loc6_:FightResultMutantListEntry = null;
         var _loc7_:GameFightMonsterInformations = null;
         var _loc8_:Monster = null;
         var _loc9_:GameFightMonsterInformations = null;
         var _loc10_:Monster = null;
         var _loc11_:GameFightTaxCollectorInformations = null;
         var _loc12_:FightResultAdditionalData = null;
         super();
         this._item = param1;
         this.outcome = param1.outcome;
         this.rewards = new FightLootWrapper(param1.rewards);
         switch(true)
         {
            case param1 is FightResultPlayerListEntry:
               _loc3_ = param1 as FightResultPlayerListEntry;
               if(!param2)
               {
                  break;
               }
               if(param2 is GameFightMonsterInformations)
               {
                  _loc9_ = param2 as GameFightMonsterInformations;
                  _loc10_ = Monster.getMonsterById(_loc9_.creatureGenericId);
                  this.name = _loc10_.name;
                  this.level = _loc10_.getMonsterGrade(_loc9_.creatureGrade).level;
                  this.id = _loc10_.id;
                  this.alive = _loc9_.alive;
                  this.type = 1;
                  break;
               }
               if(param2 is GameFightTaxCollectorInformations)
               {
                  _loc11_ = param2 as GameFightTaxCollectorInformations;
                  this.name = TaxCollectorFirstname.getTaxCollectorFirstnameById(_loc11_.firstNameId).firstname + " " + TaxCollectorName.getTaxCollectorNameById(_loc11_.lastNameId).name;
                  this.level = _loc11_.level;
                  this.id = _loc11_.contextualId;
                  this.alive = _loc11_.alive;
                  this.type = 2;
                  break;
               }
               this.name = (param2 as GameFightFighterNamedInformations).name;
               this.level = _loc3_.level;
               this.id = _loc3_.id;
               this.alive = _loc3_.alive;
               this.type = 0;
               if(_loc3_.additional.length == 0)
               {
                  break;
               }
               for each(_loc12_ in _loc3_.additional)
               {
                  switch(true)
                  {
                     case _loc12_ is FightResultExperienceData:
                        this.rerollXpMultiplicator = (_loc12_ as FightResultExperienceData).rerollExperienceMul;
                        this.experience = (_loc12_ as FightResultExperienceData).experience;
                        this.showExperience = (_loc12_ as FightResultExperienceData).showExperience;
                        this.experienceLevelFloor = (_loc12_ as FightResultExperienceData).experienceLevelFloor;
                        this.showExperienceLevelFloor = (_loc12_ as FightResultExperienceData).showExperienceLevelFloor;
                        this.experienceNextLevelFloor = (_loc12_ as FightResultExperienceData).experienceNextLevelFloor;
                        this.showExperienceNextLevelFloor = (_loc12_ as FightResultExperienceData).showExperienceNextLevelFloor;
                        this.experienceFightDelta = (_loc12_ as FightResultExperienceData).experienceFightDelta;
                        this.showExperienceFightDelta = (_loc12_ as FightResultExperienceData).showExperienceFightDelta;
                        this.experienceForGuild = (_loc12_ as FightResultExperienceData).experienceForGuild;
                        this.showExperienceForGuild = (_loc12_ as FightResultExperienceData).showExperienceForGuild;
                        this.experienceForRide = (_loc12_ as FightResultExperienceData).experienceForMount;
                        this.showExperienceForRide = (_loc12_ as FightResultExperienceData).showExperienceForMount;
                        this.isIncarnationExperience = (_loc12_ as FightResultExperienceData).isIncarnationExperience;
                        this.honorDelta = -1;
                        break;
                     case _loc12_ is FightResultPvpData:
                        this.grade = (_loc12_ as FightResultPvpData).grade;
                        this.honor = (_loc12_ as FightResultPvpData).honor;
                        this.honorDelta = (_loc12_ as FightResultPvpData).honorDelta;
                        this.maxHonorForGrade = (_loc12_ as FightResultPvpData).maxHonorForGrade;
                        this.minHonorForGrade = (_loc12_ as FightResultPvpData).minHonorForGrade;
                        break;
                  }
               }
               break;
            case param1 is FightResultTaxCollectorListEntry:
               _loc4_ = param1 as FightResultTaxCollectorListEntry;
               _loc5_ = param2 as GameFightTaxCollectorInformations;
               if(_loc5_)
               {
                  this.name = TaxCollectorFirstname.getTaxCollectorFirstnameById(_loc5_.firstNameId).firstname + " " + TaxCollectorName.getTaxCollectorNameById(_loc5_.lastNameId).name;
               }
               else
               {
                  this.name = _loc4_.guildInfo.guildName;
               }
               this.level = _loc4_.level;
               this.experienceForGuild = _loc4_.experienceForGuild;
               this.id = _loc4_.id;
               this.alive = _loc4_.alive;
               this.type = 2;
               break;
            case param1 is FightResultMutantListEntry:
               _loc6_ = param1 as FightResultMutantListEntry;
               this.name = (param2 as GameFightFighterNamedInformations).name;
               this.level = _loc6_.level;
               this.id = _loc6_.id;
               this.alive = _loc6_.alive;
               this.type = 1;
               break;
            case param1 is FightResultFighterListEntry:
               _loc7_ = param2 as GameFightMonsterInformations;
               _loc8_ = Monster.getMonsterById(_loc7_.creatureGenericId);
               this.name = _loc8_.name;
               this.level = _loc8_.getMonsterGrade(_loc7_.creatureGrade).level;
               this.id = _loc8_.id;
               this.alive = _loc7_.alive;
               this.type = 1;
               break;
            case param1 is FightResultListEntry:
         }
      }
   }
}

