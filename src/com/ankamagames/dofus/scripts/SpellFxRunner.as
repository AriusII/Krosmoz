package com.ankamagames.dofus.scripts
{
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.common.misc.ISpellCastProvider;
   import com.ankamagames.dofus.logic.game.fight.types.CastingSpell;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.script.runners.IRunner;
   import com.ankamagames.jerakine.sequencer.ISequencable;
   import flash.utils.getQualifiedClassName;
   
   public class SpellFxRunner extends FxRunner implements IRunner
   {
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SpellFxRunner));
      
      private var _spellCastProvider:ISpellCastProvider;
      
      public function SpellFxRunner(param1:ISpellCastProvider)
      {
         super(DofusEntities.getEntity(param1.castingSpell.casterId),param1.castingSpell.targetedCell);
         this._spellCastProvider = param1;
      }
      
      public function get castingSpell() : CastingSpell
      {
         return this._spellCastProvider.castingSpell;
      }
      
      public function get stepsBuffer() : Vector.<ISequencable>
      {
         return this._spellCastProvider.stepsBuffer;
      }
   }
}

