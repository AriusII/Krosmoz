package com.ankamagames.dofus.logic.game.fight.types
{
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.SpellInventoryManagementFrame;
   import com.ankamagames.dofus.logic.game.fight.types.castSpellManager.SpellManager;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class SpellCastInFightManager
   {
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SpellCastInFightManager));
      
      private var _spells:Dictionary = new Dictionary();
      
      private var skipFirstTurn:Boolean = true;
      
      public var currentTurn:int = 0;
      
      public var entityId:int;
      
      public function SpellCastInFightManager(param1:int)
      {
         super();
         this.entityId = param1;
      }
      
      public function nextTurn() : void
      {
         var _loc1_:SpellManager = null;
         ++this.currentTurn;
         for each(_loc1_ in this._spells)
         {
            _loc1_.newTurn();
         }
      }
      
      public function resetInitialCooldown() : void
      {
         var _loc1_:SpellManager = null;
         var _loc3_:SpellWrapper = null;
         var _loc2_:SpellInventoryManagementFrame = Kernel.getWorker().getFrame(SpellInventoryManagementFrame) as SpellInventoryManagementFrame;
         for each(_loc3_ in _loc2_.fullSpellList)
         {
            if(_loc3_.spellLevelInfos.initialCooldown != 0)
            {
               if(this._spells[_loc3_.spellId] == null)
               {
                  this._spells[_loc3_.spellId] = new SpellManager(this,_loc3_.spellId,_loc3_.spellLevel);
               }
               _loc1_ = this._spells[_loc3_.spellId];
               _loc1_.resetInitialCooldown(this.currentTurn);
            }
         }
      }
      
      public function castSpell(param1:uint, param2:uint, param3:Array, param4:Boolean = true) : void
      {
         if(this._spells[param1] == null)
         {
            this._spells[param1] = new SpellManager(this,param1,param2);
         }
         (this._spells[param1] as SpellManager).cast(this.currentTurn,param3,param4);
      }
      
      public function getSpellManagerBySpellId(param1:uint) : SpellManager
      {
         return this._spells[param1] as SpellManager;
      }
   }
}

