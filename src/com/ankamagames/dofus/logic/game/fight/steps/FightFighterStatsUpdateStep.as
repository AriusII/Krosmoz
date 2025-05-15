package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   
   public class FightFighterStatsUpdateStep extends AbstractSequencable implements IFightStep
   {
      private var _stats:CharacterCharacteristicsInformations;
      
      public function FightFighterStatsUpdateStep(param1:CharacterCharacteristicsInformations)
      {
         super();
         this._stats = param1;
      }
      
      public function get stepType() : String
      {
         return "fighterStatsUpdate";
      }
      
      override public function start() : void
      {
         CurrentPlayedFighterManager.getInstance().setCharacteristicsInformations(CurrentPlayedFighterManager.getInstance().currentFighterId,this._stats);
         SpellWrapper.refreshAllPlayerSpellHolder(CurrentPlayedFighterManager.getInstance().currentFighterId);
      }
   }
}

