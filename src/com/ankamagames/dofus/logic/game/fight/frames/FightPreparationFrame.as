package com.ankamagames.dofus.logic.game.fight.frames
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.managers.SelectionManager;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import com.ankamagames.atouin.renderers.ZoneDARenderer;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.berilia.factories.MenusFactory;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.LinkedCursorSpriteManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.ContextMenuData;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.fight.actions.GameContextKickAction;
   import com.ankamagames.dofus.logic.game.fight.actions.GameFightReadyAction;
   import com.ankamagames.dofus.logic.game.fight.actions.RemoveEntityAction;
   import com.ankamagames.dofus.logic.game.fight.actions.ShowTacticModeAction;
   import com.ankamagames.dofus.logic.game.fight.managers.TacticModeManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.enums.TeamEnum;
   import com.ankamagames.dofus.network.messages.game.context.GameContextDestroyMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextKickMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameEntityDispositionErrorMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightEndMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightLeaveMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightPlacementPositionRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightPlacementPossiblePositionsMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightReadyMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightRemoveTeamMemberMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightUpdateTeamMessage;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCharacterInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.entities.interfaces.*;
   import com.ankamagames.jerakine.entities.messages.EntityClickMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.zones.Custom;
   import flash.ui.Mouse;
   import flash.utils.getQualifiedClassName;
   
   public class FightPreparationFrame implements Frame
   {
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FightPreparationFrame));
      
      private static const COLOR_CHALLENGER:Color = new Color(14492160);
      
      private static const COLOR_DEFENDER:Color = new Color(8925);
      
      public static const SELECTION_CHALLENGER:String = "FightPlacementChallengerTeam";
      
      public static const SELECTION_DEFENDER:String = "FightPlacementDefenderTeam";
      
      private var _fightContextFrame:FightContextFrame;
      
      private var _playerTeam:uint;
      
      private var _challengerPositions:Vector.<uint>;
      
      private var _defenderPositions:Vector.<uint>;
      
      public function FightPreparationFrame(param1:FightContextFrame)
      {
         super();
         this._fightContextFrame = param1;
      }
      
      public function get priority() : int
      {
         return Priority.HIGH;
      }
      
      public function pushed() : Boolean
      {
         Mouse.show();
         LinkedCursorSpriteManager.getInstance().removeItem("npcMonsterCursor");
         Atouin.getInstance().cellOverEnabled = true;
         this._fightContextFrame.entitiesFrame.untargetableEntities = true;
         DataMapProvider.getInstance().isInFight = true;
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:GameFightLeaveMessage = null;
         var _loc3_:GameFightPlacementPossiblePositionsMessage = null;
         var _loc4_:CellClickMessage = null;
         var _loc5_:AnimatedCharacter = null;
         var _loc6_:GameFightReadyAction = null;
         var _loc7_:GameFightReadyMessage = null;
         var _loc8_:EntityClickMessage = null;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:ContextMenuData = null;
         var _loc12_:GameContextKickAction = null;
         var _loc13_:uint = 0;
         var _loc14_:GameContextKickMessage = null;
         var _loc15_:GameFightUpdateTeamMessage = null;
         var _loc16_:int = 0;
         var _loc17_:Boolean = false;
         var _loc18_:GameFightRemoveTeamMemberMessage = null;
         var _loc19_:GameFightEndMessage = null;
         var _loc20_:FightContextFrame = null;
         var _loc21_:GameFightEndMessage = null;
         var _loc22_:IEntity = null;
         var _loc23_:String = null;
         var _loc24_:FightEntitiesFrame = null;
         var _loc25_:GameFightCharacterInformations = null;
         var _loc26_:GameFightPlacementPositionRequestMessage = null;
         var _loc27_:FightTeamMemberInformations = null;
         switch(true)
         {
            case param1 is GameFightLeaveMessage:
               _loc2_ = param1 as GameFightLeaveMessage;
               if(_loc2_.charId == PlayedCharacterManager.getInstance().id)
               {
                  Kernel.getWorker().removeFrame(this);
                  KernelEventsManager.getInstance().processCallback(HookList.GameFightLeave,_loc2_.charId);
                  _loc21_ = new GameFightEndMessage();
                  _loc21_.initGameFightEndMessage();
                  Kernel.getWorker().process(_loc21_);
                  return true;
               }
               return false;
               break;
            case param1 is GameFightPlacementPossiblePositionsMessage:
               _loc3_ = param1 as GameFightPlacementPossiblePositionsMessage;
               this.displayZone(SELECTION_CHALLENGER,this._challengerPositions = _loc3_.positionsForChallengers,COLOR_CHALLENGER);
               this.displayZone(SELECTION_DEFENDER,this._defenderPositions = _loc3_.positionsForDefenders,COLOR_DEFENDER);
               this._playerTeam = _loc3_.teamNumber;
               return true;
            case param1 is CellClickMessage:
               _loc4_ = param1 as CellClickMessage;
               for each(_loc22_ in EntitiesManager.getInstance().getEntitiesOnCell(_loc4_.cellId))
               {
                  if(_loc22_ is AnimatedCharacter && !(_loc22_ as AnimatedCharacter).isMoving)
                  {
                     _loc5_ = _loc22_ as AnimatedCharacter;
                     break;
                  }
               }
               if(_loc5_)
               {
                  if(_loc5_.id > 0)
                  {
                     _loc23_ = this._fightContextFrame.getFighterName(_loc5_.id);
                     _loc24_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
                     _loc25_ = _loc24_.getEntityInfos(_loc5_.id) as GameFightCharacterInformations;
                     _loc10_ = UiModuleManager.getInstance().getModule("Ankama_ContextMenu").mainClass;
                     _loc11_ = MenusFactory.create(_loc25_,"player",[_loc5_]);
                     _loc10_.createContextMenu(_loc11_);
                  }
               }
               else if(this.isValidPlacementCell(_loc4_.cellId,this._playerTeam))
               {
                  _loc26_ = new GameFightPlacementPositionRequestMessage();
                  _loc26_.initGameFightPlacementPositionRequestMessage(_loc4_.cellId);
                  ConnectionsHandler.getConnection().send(_loc26_);
               }
               return true;
            case param1 is GameEntityDispositionErrorMessage:
               _log.error("Cette position n\'est pas accessible.");
               return true;
            case param1 is GameFightReadyAction:
               _loc6_ = param1 as GameFightReadyAction;
               _loc7_ = new GameFightReadyMessage();
               _loc7_.initGameFightReadyMessage(_loc6_.isReady);
               ConnectionsHandler.getConnection().send(_loc7_);
               return true;
            case param1 is EntityClickMessage:
               _loc8_ = param1 as EntityClickMessage;
               if(_loc8_.entity.id < 0)
               {
                  return true;
               }
               _loc9_ = new Object();
               _loc9_.name = this._fightContextFrame.getFighterName(_loc8_.entity.id);
               _loc10_ = UiModuleManager.getInstance().getModule("Ankama_ContextMenu").mainClass;
               _loc11_ = MenusFactory.create(_loc9_,"player",[_loc8_.entity]);
               _loc10_.createContextMenu(_loc11_);
               return true;
               break;
            case param1 is GameContextKickAction:
               _loc12_ = param1 as GameContextKickAction;
               _loc13_ = PlayedCharacterManager.getInstance().infos.id;
               _loc14_ = new GameContextKickMessage();
               _loc14_.initGameContextKickMessage(_loc12_.targetId);
               ConnectionsHandler.getConnection().send(_loc14_);
               return true;
            case param1 is GameFightUpdateTeamMessage:
               _loc15_ = param1 as GameFightUpdateTeamMessage;
               _loc16_ = PlayedCharacterManager.getInstance().id;
               _loc17_ = false;
               for each(_loc27_ in _loc15_.team.teamMembers)
               {
                  if(_loc27_.id == _loc16_)
                  {
                     _loc17_ = true;
                  }
               }
               if(_loc17_ || _loc15_.team.teamMembers.length >= 1 && _loc15_.team.teamMembers[0].id == _loc16_)
               {
                  PlayedCharacterManager.getInstance().teamId = _loc15_.team.teamId;
                  this._fightContextFrame.isFightLeader = _loc15_.team.leaderId == _loc16_;
               }
               return true;
            case param1 is GameFightRemoveTeamMemberMessage:
               _loc18_ = param1 as GameFightRemoveTeamMemberMessage;
               this._fightContextFrame.entitiesFrame.process(RemoveEntityAction.create(_loc18_.charId));
               return true;
            case param1 is GameContextDestroyMessage:
               _loc19_ = new GameFightEndMessage();
               _loc19_.initGameFightEndMessage();
               _loc20_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
               if(_loc20_)
               {
                  _loc20_.process(_loc19_);
               }
               else
               {
                  Kernel.getWorker().process(_loc19_);
               }
               return true;
            case param1 is ShowTacticModeAction:
               this.removeSelections();
               if(!TacticModeManager.getInstance().tacticModeActivated)
               {
                  TacticModeManager.getInstance().show(PlayedCharacterManager.getInstance().currentMap);
               }
               else
               {
                  TacticModeManager.getInstance().hide();
               }
               this.displayZone(SELECTION_CHALLENGER,this._challengerPositions,COLOR_CHALLENGER);
               this.displayZone(SELECTION_DEFENDER,this._defenderPositions,COLOR_DEFENDER);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         DataMapProvider.getInstance().isInFight = false;
         this.removeSelections();
         this._fightContextFrame.entitiesFrame.untargetableEntities = Dofus.getInstance().options.cellSelectionOnly;
         return true;
      }
      
      private function removeSelections() : void
      {
         var _loc1_:Selection = SelectionManager.getInstance().getSelection(SELECTION_CHALLENGER);
         if(_loc1_)
         {
            _loc1_.remove();
         }
         var _loc2_:Selection = SelectionManager.getInstance().getSelection(SELECTION_DEFENDER);
         if(_loc2_)
         {
            _loc2_.remove();
         }
      }
      
      private function displayZone(param1:String, param2:Vector.<uint>, param3:Color) : void
      {
         var _loc4_:Selection = new Selection();
         _loc4_.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA);
         _loc4_.color = param3;
         _loc4_.zone = new Custom(param2);
         SelectionManager.getInstance().addSelection(_loc4_,param1);
         SelectionManager.getInstance().update(param1);
      }
      
      private function isValidPlacementCell(param1:uint, param2:uint) : Boolean
      {
         var _loc5_:uint = 0;
         var _loc3_:MapPoint = MapPoint.fromCellId(param1);
         if(!DataMapProvider.getInstance().pointMov(_loc3_.x,_loc3_.y,false))
         {
            return false;
         }
         var _loc4_:Vector.<uint> = new Vector.<uint>();
         switch(param2)
         {
            case TeamEnum.TEAM_CHALLENGER:
               _loc4_ = this._challengerPositions;
               break;
            case TeamEnum.TEAM_DEFENDER:
               _loc4_ = this._defenderPositions;
               break;
            case TeamEnum.TEAM_SPECTATOR:
               return false;
         }
         if(_loc4_)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               if(_loc4_[_loc5_] == param1)
               {
                  return true;
               }
               _loc5_++;
            }
         }
         return false;
      }
   }
}

