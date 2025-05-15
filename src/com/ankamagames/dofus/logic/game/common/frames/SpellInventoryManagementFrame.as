package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.breeds.Breed;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.roleplay.actions.SpellSetPositionAction;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.messages.game.inventory.spells.SlaveSwitchContextMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.spells.SpellListMessage;
   import com.ankamagames.dofus.network.types.game.data.items.SpellItem;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.utils.getQualifiedClassName;
   
   public class SpellInventoryManagementFrame implements Frame
   {
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SpellInventoryManagementFrame));
      
      private var _fullSpellList:Array = new Array();
      
      public function SpellInventoryManagementFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get fullSpellList() : Array
      {
         return this._fullSpellList;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:SpellSetPositionAction = null;
         var _loc3_:SpellListMessage = null;
         var _loc4_:Array = null;
         var _loc5_:SlaveSwitchContextMessage = null;
         var _loc6_:SpellItem = null;
         var _loc7_:Breed = null;
         var _loc8_:Spell = null;
         var _loc9_:SpellItem = null;
         switch(true)
         {
            case param1 is SpellSetPositionAction:
               _loc2_ = param1 as SpellSetPositionAction;
               return true;
            case param1 is SpellListMessage:
               _loc3_ = param1 as SpellListMessage;
               this._fullSpellList = new Array();
               _loc4_ = new Array();
               for each(_loc6_ in _loc3_.spells)
               {
                  this._fullSpellList.push(SpellWrapper.create(_loc6_.position,_loc6_.spellId,_loc6_.spellLevel,true,PlayedCharacterManager.getInstance().id));
                  _loc4_.push(_loc6_.spellId);
               }
               if(_loc3_.spellPrevisualization)
               {
                  _loc7_ = Breed.getBreedById(PlayedCharacterManager.getInstance().infos.breed);
                  for each(_loc8_ in _loc7_.breedSpells)
                  {
                     if(_loc4_.indexOf(_loc8_.id) == -1)
                     {
                        this._fullSpellList.push(SpellWrapper.create(1,_loc8_.id,0,true,PlayedCharacterManager.getInstance().id));
                     }
                  }
               }
               PlayedCharacterManager.getInstance().spellsInventory = this._fullSpellList;
               PlayedCharacterManager.getInstance().playerSpellList = this._fullSpellList;
               KernelEventsManager.getInstance().processCallback(HookList.SpellList,this._fullSpellList);
               return true;
            case param1 is SlaveSwitchContextMessage:
               _loc5_ = param1 as SlaveSwitchContextMessage;
               this._fullSpellList = new Array();
               for each(_loc9_ in _loc5_.slaveSpells)
               {
                  this._fullSpellList.push(SpellWrapper.create(_loc9_.position,_loc9_.spellId,_loc9_.spellLevel,true,_loc5_.slaveId));
               }
               PlayedCharacterManager.getInstance().spellsInventory = this._fullSpellList;
               CurrentPlayedFighterManager.getInstance().setCharacteristicsInformations(_loc5_.slaveId,_loc5_.slaveStats);
               KernelEventsManager.getInstance().processCallback(HookList.SpellList,this._fullSpellList);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
   }
}

