package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.fightEvents.FightEventsHelper;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightSpellCastFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightTurnFrame;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   
   public class FightTeleportStep extends AbstractSequencable implements IFightStep
   {
      private var _fighterId:int;
      
      private var _destinationCell:MapPoint;
      
      public function FightTeleportStep(param1:int, param2:MapPoint)
      {
         super();
         this._fighterId = param1;
         this._destinationCell = param2;
         var _loc3_:GameFightFighterInformations = FightEntitiesFrame.getCurrentInstance().getEntityInfos(this._fighterId) as GameFightFighterInformations;
         _loc3_.disposition.cellId = param2.cellId;
      }
      
      public function get stepType() : String
      {
         return "teleport";
      }
      
      override public function start() : void
      {
         var _loc2_:FightTurnFrame = null;
         var _loc1_:IMovable = DofusEntities.getEntity(this._fighterId) as IMovable;
         if(_loc1_)
         {
            (_loc1_ as IDisplayable).display(PlacementStrataEnums.STRATA_PLAYER);
            _loc1_.jump(this._destinationCell);
         }
         else
         {
            _log.warn("Unable to teleport unknown entity " + this._fighterId + ".");
         }
         if(this._fighterId == PlayedCharacterManager.getInstance().id)
         {
            _loc2_ = Kernel.getWorker().getFrame(FightTurnFrame) as FightTurnFrame;
            if(Boolean(_loc2_) && _loc2_.myTurn)
            {
               _loc2_.drawPath();
            }
         }
         FightSpellCastFrame.updateRangeAndTarget();
         FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_TELEPORTED,[this._fighterId],0,castingSpellId);
         executeCallbacks();
      }
   }
}

