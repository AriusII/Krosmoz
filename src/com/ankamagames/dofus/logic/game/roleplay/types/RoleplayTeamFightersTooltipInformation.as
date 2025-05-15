package com.ankamagames.dofus.logic.game.roleplay.types
{
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorFirstname;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorName;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberWithAllianceCharacterInformations;
   
   public class RoleplayTeamFightersTooltipInformation
   {
      public var fighters:Vector.<Fighter>;
      
      public function RoleplayTeamFightersTooltipInformation(param1:FightTeam)
      {
         var _loc2_:FightTeamMemberInformations = null;
         var _loc3_:Fighter = null;
         var _loc4_:String = null;
         var _loc5_:Monster = null;
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         var _loc8_:uint = 0;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         super();
         this.fighters = new Vector.<Fighter>();
         for each(_loc2_ in param1.teamInfos.teamMembers)
         {
            switch(true)
            {
               case _loc2_ is FightTeamMemberCharacterInformations:
                  if(_loc2_ is FightTeamMemberWithAllianceCharacterInformations)
                  {
                     _loc4_ = (_loc2_ as FightTeamMemberWithAllianceCharacterInformations).allianceInfos.allianceTag;
                  }
                  _loc3_ = new Fighter((_loc2_ as FightTeamMemberCharacterInformations).name,(_loc2_ as FightTeamMemberCharacterInformations).level,_loc4_);
                  break;
               case _loc2_ is FightTeamMemberMonsterInformations:
                  _loc5_ = Monster.getMonsterById((_loc2_ as FightTeamMemberMonsterInformations).monsterId);
                  _loc6_ = _loc5_.getMonsterGrade((_loc2_ as FightTeamMemberMonsterInformations).grade).level;
                  _loc7_ = _loc5_.name;
                  _loc3_ = new Fighter(_loc7_,_loc6_);
                  break;
               case _loc2_ is FightTeamMemberTaxCollectorInformations:
                  _loc8_ = (_loc2_ as FightTeamMemberTaxCollectorInformations).level;
                  _loc9_ = TaxCollectorFirstname.getTaxCollectorFirstnameById((_loc2_ as FightTeamMemberTaxCollectorInformations).firstNameId).firstname;
                  _loc10_ = TaxCollectorName.getTaxCollectorNameById((_loc2_ as FightTeamMemberTaxCollectorInformations).lastNameId).name;
                  _loc11_ = _loc9_ + " " + _loc10_;
                  _loc3_ = new Fighter(_loc11_,_loc8_);
                  break;
            }
            this.fighters.push(_loc3_);
         }
      }
   }
}

class Fighter
{
   public var allianceTag:String;
   
   public var name:String;
   
   public var level:uint;
   
   public function Fighter(param1:String, param2:uint, param3:String = null)
   {
      super();
      this.name = param1;
      this.level = param2;
      if(param3)
      {
         this.allianceTag = "[" + param3 + "]";
      }
   }
}
