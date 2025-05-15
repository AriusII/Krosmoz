package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.logic.game.fight.fightEvents.FightEventsHelper;
   import com.ankamagames.dofus.logic.game.fight.managers.MarkedCellsManager;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.dofus.logic.game.fight.types.MarkInstance;
   import com.ankamagames.dofus.network.enums.GameActionMarkTypeEnum;
   import com.ankamagames.dofus.network.types.game.actions.fight.GameActionMarkedCell;
   import com.ankamagames.dofus.types.sequences.AddGlyphGfxStep;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   
   public class FightMarkCellsStep extends AbstractSequencable implements IFightStep
   {
      private var _markId:int;
      
      private var _markType:int;
      
      private var _associatedSpellRank:SpellLevel;
      
      private var _cells:Vector.<GameActionMarkedCell>;
      
      private var _markSpellId:int;
      
      public function FightMarkCellsStep(param1:int, param2:int, param3:SpellLevel, param4:Vector.<GameActionMarkedCell>, param5:int)
      {
         super();
         this._markId = param1;
         this._cells = param4;
         this._markType = param2;
         this._associatedSpellRank = param3;
         this._markSpellId = param5;
      }
      
      public function get stepType() : String
      {
         return "markCells";
      }
      
      override public function start() : void
      {
         var _loc4_:GameActionMarkedCell = null;
         var _loc5_:AddGlyphGfxStep = null;
         var _loc1_:Spell = Spell.getSpellById(this._markSpellId);
         MarkedCellsManager.getInstance().addMark(this._markId,this._markType,_loc1_,this._cells);
         if(this._markType == GameActionMarkTypeEnum.WALL)
         {
            if(_loc1_.getParamByName("glyphGfxId"))
            {
               for each(_loc4_ in this._cells)
               {
                  _loc5_ = new AddGlyphGfxStep(_loc1_.getParamByName("glyphGfxId"),_loc4_.cellId,this._markId,this._markType);
                  _loc5_.start();
               }
            }
         }
         var _loc2_:MarkInstance = MarkedCellsManager.getInstance().getMarkDatas(this._markId);
         var _loc3_:String = FightEventEnum.UNKNOWN_FIGHT_EVENT;
         switch(_loc2_.markType)
         {
            case GameActionMarkTypeEnum.GLYPH:
               _loc3_ = FightEventEnum.GLYPH_APPEARED;
               break;
            case GameActionMarkTypeEnum.TRAP:
               _loc3_ = FightEventEnum.TRAP_APPEARED;
               break;
            default:
               _log.warn("Unknown mark type (" + _loc2_.markType + ").");
         }
         FightEventsHelper.sendFightEvent(_loc3_,[_loc2_.associatedSpell.id],0,castingSpellId);
         executeCallbacks();
      }
   }
}

