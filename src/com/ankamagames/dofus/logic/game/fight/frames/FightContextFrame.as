package com.ankamagames.dofus.logic.game.fight.frames
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.*;
   import com.ankamagames.atouin.messages.CellOutMessage;
   import com.ankamagames.atouin.messages.CellOverMessage;
   import com.ankamagames.atouin.messages.MapLoadedMessage;
   import com.ankamagames.atouin.messages.MapsLoadingCompleteMessage;
   import com.ankamagames.atouin.renderers.*;
   import com.ankamagames.atouin.types.*;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorFirstname;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorName;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.internalDatacenter.fight.ChallengeWrapper;
   import com.ankamagames.dofus.internalDatacenter.fight.FightResultEntryWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.internalDatacenter.world.WorldPointWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.kernel.sound.enum.UISoundEnum;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowCellManager;
   import com.ankamagames.dofus.logic.game.common.frames.PartyManagementFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.SpeakingItemManager;
   import com.ankamagames.dofus.logic.game.common.messages.FightEndingMessage;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.common.misc.SpellModificator;
   import com.ankamagames.dofus.logic.game.fight.actions.ChallengeTargetsListRequestAction;
   import com.ankamagames.dofus.logic.game.fight.actions.ShowTacticModeAction;
   import com.ankamagames.dofus.logic.game.fight.actions.TimelineEntityOutAction;
   import com.ankamagames.dofus.logic.game.fight.actions.TimelineEntityOverAction;
   import com.ankamagames.dofus.logic.game.fight.actions.TogglePointCellAction;
   import com.ankamagames.dofus.logic.game.fight.fightEvents.FightEventsHelper;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.fight.managers.MarkedCellsManager;
   import com.ankamagames.dofus.logic.game.fight.managers.TacticModeManager;
   import com.ankamagames.dofus.logic.game.fight.miscs.FightReachableCellsMaker;
   import com.ankamagames.dofus.logic.game.fight.types.BasicBuff;
   import com.ankamagames.dofus.logic.game.fight.types.CastingSpell;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.dofus.logic.game.fight.types.SpellCastInFightManager;
   import com.ankamagames.dofus.logic.game.fight.types.StatBuff;
   import com.ankamagames.dofus.misc.lists.FightHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.lists.TriggerHookList;
   import com.ankamagames.dofus.network.enums.CharacterSpellModificationTypeEnum;
   import com.ankamagames.dofus.network.enums.FightOutcomeEnum;
   import com.ankamagames.dofus.network.enums.GameActionFightInvisibilityStateEnum;
   import com.ankamagames.dofus.network.enums.MapObstacleStateEnum;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightCarryCharacterMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightNoSpellCastMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextReadyMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightEndMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightJoinMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightResumeMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightResumeWithSlavesMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightSpectateMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightStartMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightStartingMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightUpdateTeamMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.challenge.ChallengeInfoMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.challenge.ChallengeResultMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.challenge.ChallengeTargetUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.challenge.ChallengeTargetsListMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.challenge.ChallengeTargetsListRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.CurrentMapMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapInformationsRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapObstacleUpdateMessage;
   import com.ankamagames.dofus.network.types.game.action.fight.FightDispellableEffectExtendedInformations;
   import com.ankamagames.dofus.network.types.game.actions.fight.GameActionMark;
   import com.ankamagames.dofus.network.types.game.actions.fight.GameActionMarkedCell;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterSpellModification;
   import com.ankamagames.dofus.network.types.game.context.fight.FightResultFighterListEntry;
   import com.ankamagames.dofus.network.types.game.context.fight.FightResultListEntry;
   import com.ankamagames.dofus.network.types.game.context.fight.FightResultPlayerListEntry;
   import com.ankamagames.dofus.network.types.game.context.fight.FightResultTaxCollectorListEntry;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterNamedInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMutantInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightResumeSlaveInfo;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightSpellCooldown;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.interactive.MapObstacle;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.sequences.AddGlyphGfxStep;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.entities.interfaces.*;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOutMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOverMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.types.zones.Custom;
   import com.ankamagames.jerakine.utils.memory.WeakReference;
   import com.hurlant.util.Hex;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class FightContextFrame implements Frame
   {
      public static var fighterEntityTooltipId:int;
      
      public static var timelineOverEntityId:int;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FightContextFrame));
      
      public static var preFightIsActive:Boolean = true;
      
      public static var currentCell:int = -1;
      
      private const TYPE_LOG_FIGHT:uint = 30000;
      
      private const INVISIBLE_POSITION_SELECTION:String = "invisible_position";
      
      private var _entitiesFrame:FightEntitiesFrame;
      
      private var _preparationFrame:FightPreparationFrame;
      
      private var _battleFrame:FightBattleFrame;
      
      private var _pointCellFrame:FightPointCellFrame;
      
      private var _overEffectOk:GlowFilter;
      
      private var _overEffectKo:GlowFilter;
      
      private var _linkedEffect:ColorMatrixFilter;
      
      private var _linkedMainEffect:ColorMatrixFilter;
      
      private var _lastEffectEntity:WeakReference;
      
      private var _reachableRangeSelection:Selection;
      
      private var _unreachableRangeSelection:Selection;
      
      private var _timerFighterInfo:Timer;
      
      private var _timerMovementRange:Timer;
      
      private var _currentFighterInfo:GameFightFighterInformations;
      
      private var _currentMapRenderId:int = -1;
      
      public var _challengesList:Array;
      
      private var _fightType:uint;
      
      public var isFightLeader:Boolean;
      
      public function FightContextFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get entitiesFrame() : FightEntitiesFrame
      {
         return this._entitiesFrame;
      }
      
      public function get battleFrame() : FightBattleFrame
      {
         return this._battleFrame;
      }
      
      public function get challengesList() : Array
      {
         return this._challengesList;
      }
      
      public function get fightType() : uint
      {
         return this._fightType;
      }
      
      public function set fightType(param1:uint) : void
      {
         this._fightType = param1;
         var _loc2_:PartyManagementFrame = Kernel.getWorker().getFrame(PartyManagementFrame) as PartyManagementFrame;
         _loc2_.lastFightType = param1;
      }
      
      public function pushed() : Boolean
      {
         if(!Kernel.beingInReconection)
         {
            Atouin.getInstance().displayGrid(true,true);
         }
         currentCell = -1;
         timelineOverEntityId = 0;
         this._overEffectOk = new GlowFilter(16777215,1,4,4,3,1);
         this._overEffectKo = new GlowFilter(14090240,1,4,4,3,1);
         var _loc1_:Array = new Array();
         _loc1_ = _loc1_.concat([0.5,0,0,0,100]);
         _loc1_ = _loc1_.concat([0,0.5,0,0,100]);
         _loc1_ = _loc1_.concat([0,0,0.5,0,100]);
         _loc1_ = _loc1_.concat([0,0,0,1,0]);
         this._linkedEffect = new ColorMatrixFilter(_loc1_);
         var _loc2_:Array = new Array();
         _loc2_ = _loc2_.concat([0.5,0,0,0,0]);
         _loc2_ = _loc2_.concat([0,0.5,0,0,0]);
         _loc2_ = _loc2_.concat([0,0,0.5,0,0]);
         _loc2_ = _loc2_.concat([0,0,0,1,0]);
         this._linkedMainEffect = new ColorMatrixFilter(_loc2_);
         this._entitiesFrame = new FightEntitiesFrame();
         this._preparationFrame = new FightPreparationFrame(this);
         this._battleFrame = new FightBattleFrame();
         this._pointCellFrame = new FightPointCellFrame();
         this._challengesList = new Array();
         this._timerFighterInfo = new Timer(100,1);
         this._timerFighterInfo.addEventListener(TimerEvent.TIMER,this.showFighterInfo,false,0,true);
         this._timerMovementRange = new Timer(200,1);
         this._timerMovementRange.addEventListener(TimerEvent.TIMER,this.showMovementRange,false,0,true);
         if(MapDisplayManager.getInstance().getDataMapContainer())
         {
            MapDisplayManager.getInstance().getDataMapContainer().setTemporaryAnimatedElementState(false);
         }
         var _loc3_:UiRootContainer = Berilia.getInstance().getUi("mapInfo");
         if(_loc3_)
         {
            _loc3_.visible = false;
         }
         return true;
      }
      
      public function getFighterName(param1:int) : String
      {
         var _loc2_:GameFightFighterInformations = null;
         var _loc3_:GameFightTaxCollectorInformations = null;
         _loc2_ = this.getFighterInfos(param1);
         if(!_loc2_)
         {
            return "Unknown Fighter";
         }
         switch(true)
         {
            case _loc2_ is GameFightFighterNamedInformations:
               return (_loc2_ as GameFightFighterNamedInformations).name;
            case _loc2_ is GameFightMonsterInformations:
               return Monster.getMonsterById((_loc2_ as GameFightMonsterInformations).creatureGenericId).name;
            case _loc2_ is GameFightTaxCollectorInformations:
               _loc3_ = _loc2_ as GameFightTaxCollectorInformations;
               return TaxCollectorFirstname.getTaxCollectorFirstnameById(_loc3_.firstNameId).firstname + " " + TaxCollectorName.getTaxCollectorNameById(_loc3_.lastNameId).name;
            default:
               return "Unknown Fighter Type";
         }
      }
      
      public function getFighterStatus(param1:int) : uint
      {
         var _loc2_:GameFightFighterInformations = this.getFighterInfos(param1);
         if(!_loc2_)
         {
            return 1;
         }
         switch(true)
         {
            case _loc2_ is GameFightFighterNamedInformations:
               return (_loc2_ as GameFightFighterNamedInformations).status.statusId;
            default:
               return 1;
         }
      }
      
      public function getFighterLevel(param1:int) : uint
      {
         var _loc2_:GameFightFighterInformations = null;
         var _loc3_:Monster = null;
         _loc2_ = this.getFighterInfos(param1);
         if(!_loc2_)
         {
            return 0;
         }
         switch(true)
         {
            case _loc2_ is GameFightMutantInformations:
               return (_loc2_ as GameFightMutantInformations).powerLevel;
            case _loc2_ is GameFightCharacterInformations:
               return (_loc2_ as GameFightCharacterInformations).level;
            case _loc2_ is GameFightMonsterInformations:
               _loc3_ = Monster.getMonsterById((_loc2_ as GameFightMonsterInformations).creatureGenericId);
               return _loc3_.getMonsterGrade((_loc2_ as GameFightMonsterInformations).creatureGrade).level;
            case _loc2_ is GameFightTaxCollectorInformations:
               return (_loc2_ as GameFightTaxCollectorInformations).level;
            default:
               return 0;
         }
      }
      
      public function getChallengeById(param1:uint) : ChallengeWrapper
      {
         var _loc2_:ChallengeWrapper = null;
         for each(_loc2_ in this._challengesList)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:GameFightStartingMessage = null;
         var _loc3_:CurrentMapMessage = null;
         var _loc4_:WorldPointWrapper = null;
         var _loc5_:ByteArray = null;
         var _loc6_:GameContextReadyMessage = null;
         var _loc7_:GameFightResumeMessage = null;
         var _loc8_:Vector.<GameFightResumeSlaveInfo> = null;
         var _loc9_:GameFightResumeSlaveInfo = null;
         var _loc10_:CurrentPlayedFighterManager = null;
         var _loc11_:int = 0;
         var _loc12_:Array = null;
         var _loc13_:Array = null;
         var _loc14_:Array = null;
         var _loc15_:CastingSpell = null;
         var _loc16_:GameFightUpdateTeamMessage = null;
         var _loc17_:GameFightSpectateMessage = null;
         var _loc18_:Array = null;
         var _loc19_:Array = null;
         var _loc20_:Array = null;
         var _loc21_:CastingSpell = null;
         var _loc22_:GameFightJoinMessage = null;
         var _loc23_:int = 0;
         var _loc24_:GameActionFightCarryCharacterMessage = null;
         var _loc25_:CellOutMessage = null;
         var _loc26_:AnimatedCharacter = null;
         var _loc27_:CellOverMessage = null;
         var _loc28_:AnimatedCharacter = null;
         var _loc29_:EntityMouseOverMessage = null;
         var _loc30_:EntityMouseOutMessage = null;
         var _loc31_:TimelineEntityOverAction = null;
         var _loc32_:TogglePointCellAction = null;
         var _loc33_:GameFightEndMessage = null;
         var _loc34_:ChallengeTargetsListRequestAction = null;
         var _loc35_:ChallengeTargetsListRequestMessage = null;
         var _loc36_:ChallengeTargetsListMessage = null;
         var _loc37_:ChallengeInfoMessage = null;
         var _loc38_:ChallengeWrapper = null;
         var _loc39_:ChallengeTargetUpdateMessage = null;
         var _loc40_:ChallengeResultMessage = null;
         var _loc41_:MapObstacleUpdateMessage = null;
         var _loc42_:GameActionFightNoSpellCastMessage = null;
         var _loc43_:uint = 0;
         var _loc44_:MapInformationsRequestMessage = null;
         var _loc45_:String = null;
         var _loc46_:GameFightResumeWithSlavesMessage = null;
         var _loc47_:int = 0;
         var _loc48_:GameFightResumeSlaveInfo = null;
         var _loc49_:int = 0;
         var _loc50_:int = 0;
         var _loc51_:GameFightSpellCooldown = null;
         var _loc52_:SpellWrapper = null;
         var _loc53_:SpellLevel = null;
         var _loc54_:SpellCastInFightManager = null;
         var _loc55_:int = 0;
         var _loc56_:SpellModificator = null;
         var _loc57_:CharacterCharacteristicsInformations = null;
         var _loc58_:CharacterSpellModification = null;
         var _loc59_:FightDispellableEffectExtendedInformations = null;
         var _loc60_:BasicBuff = null;
         var _loc61_:GameActionMark = null;
         var _loc62_:Spell = null;
         var _loc63_:GameActionMarkedCell = null;
         var _loc64_:AddGlyphGfxStep = null;
         var _loc65_:FightDispellableEffectExtendedInformations = null;
         var _loc66_:BasicBuff = null;
         var _loc67_:GameActionMark = null;
         var _loc68_:Spell = null;
         var _loc69_:GameActionMarkedCell = null;
         var _loc70_:AddGlyphGfxStep = null;
         var _loc71_:IEntity = null;
         var _loc72_:IEntity = null;
         var _loc73_:FightEndingMessage = null;
         var _loc74_:Vector.<FightResultEntryWrapper> = null;
         var _loc75_:uint = 0;
         var _loc76_:FightResultEntryWrapper = null;
         var _loc77_:Vector.<FightResultEntryWrapper> = null;
         var _loc78_:FightResultListEntry = null;
         var _loc79_:Object = null;
         var _loc80_:FightResultEntryWrapper = null;
         var _loc81_:uint = 0;
         var _loc82_:ItemWrapper = null;
         var _loc83_:int = 0;
         var _loc84_:int = 0;
         var _loc85_:FightResultEntryWrapper = null;
         var _loc86_:Number = NaN;
         var _loc87_:MapObstacle = null;
         var _loc88_:SpellLevel = null;
         switch(true)
         {
            case param1 is MapLoadedMessage:
               MapDisplayManager.getInstance().getDataMapContainer().setTemporaryAnimatedElementState(false);
               if(PlayedCharacterManager.getInstance().isSpectator)
               {
                  _loc44_ = new MapInformationsRequestMessage();
                  _loc44_.initMapInformationsRequestMessage(MapDisplayManager.getInstance().currentMapPoint.mapId);
                  ConnectionsHandler.getConnection().send(_loc44_);
               }
               return false;
            case param1 is GameFightStartingMessage:
               _loc2_ = param1 as GameFightStartingMessage;
               TooltipManager.hideAll();
               Atouin.getInstance().cancelZoom();
               KernelEventsManager.getInstance().processCallback(HookList.StartZoom,false);
               MapDisplayManager.getInstance().activeIdentifiedElements(false);
               FightEventsHelper.reset();
               KernelEventsManager.getInstance().processCallback(HookList.GameFightStarting,_loc2_.fightType);
               this.fightType = _loc2_.fightType;
               CurrentPlayedFighterManager.getInstance().currentFighterId = PlayedCharacterManager.getInstance().id;
               CurrentPlayedFighterManager.getInstance().getSpellCastManager().currentTurn = 0;
               SoundManager.getInstance().manager.prepareFightMusic();
               SoundManager.getInstance().manager.playUISound(UISoundEnum.INTRO_FIGHT);
               return true;
            case param1 is CurrentMapMessage:
               _loc3_ = param1 as CurrentMapMessage;
               ConnectionsHandler.pause();
               Kernel.getWorker().pause();
               if(TacticModeManager.getInstance().tacticModeActivated)
               {
                  TacticModeManager.getInstance().hide();
               }
               _loc4_ = new WorldPointWrapper(_loc3_.mapId);
               KernelEventsManager.getInstance().processCallback(HookList.StartZoom,false);
               Atouin.getInstance().initPreDisplay(_loc4_);
               Atouin.getInstance().clearEntities();
               if(Boolean(_loc3_.mapKey) && Boolean(_loc3_.mapKey.length))
               {
                  _loc45_ = XmlConfig.getInstance().getEntry("config.maps.encryptionKey");
                  if(!_loc45_)
                  {
                     _loc45_ = _loc3_.mapKey;
                  }
                  _loc5_ = Hex.toArray(Hex.fromString(_loc45_));
               }
               this._currentMapRenderId = Atouin.getInstance().display(_loc4_,_loc5_);
               _log.info("Ask map render for fight #" + this._currentMapRenderId);
               PlayedCharacterManager.getInstance().currentMap = _loc4_;
               KernelEventsManager.getInstance().processCallback(HookList.CurrentMap,_loc3_.mapId);
               return true;
            case param1 is MapsLoadingCompleteMessage:
               _log.info("MapsLoadingCompleteMessage #" + MapsLoadingCompleteMessage(param1).renderRequestId);
               if(this._currentMapRenderId != MapsLoadingCompleteMessage(param1).renderRequestId)
               {
                  return false;
               }
               Atouin.getInstance().showWorld(true);
               Atouin.getInstance().displayGrid(true,true);
               Atouin.getInstance().cellOverEnabled = true;
               _loc6_ = new GameContextReadyMessage();
               _loc6_.initGameContextReadyMessage(MapDisplayManager.getInstance().currentMapPoint.mapId);
               ConnectionsHandler.getConnection().send(_loc6_);
               Kernel.getWorker().resume();
               ConnectionsHandler.resume();
               break;
            case param1 is GameFightResumeMessage:
               _loc7_ = param1 as GameFightResumeMessage;
               this.tacticModeHandler();
               PlayedCharacterManager.getInstance().currentSummonedCreature = _loc7_.summonCount;
               this._battleFrame.turnsCount = _loc7_.gameTurn - 1;
               CurrentPlayedFighterManager.getInstance().getSpellCastManager().currentTurn = _loc7_.gameTurn - 1;
               KernelEventsManager.getInstance().processCallback(FightHookList.TurnCountUpdated,_loc7_.gameTurn - 1);
               if(param1 is GameFightResumeWithSlavesMessage)
               {
                  _loc46_ = param1 as GameFightResumeWithSlavesMessage;
                  _loc8_ = _loc46_.slavesInfo;
               }
               else
               {
                  _loc8_ = new Vector.<GameFightResumeSlaveInfo>();
               }
               _loc9_ = new GameFightResumeSlaveInfo();
               _loc9_.spellCooldowns = _loc7_.spellCooldowns;
               _loc9_.slaveId = PlayedCharacterManager.getInstance().id;
               _loc8_.unshift(_loc9_);
               _loc10_ = CurrentPlayedFighterManager.getInstance();
               _loc11_ = int(_loc8_.length);
               _loc47_ = 0;
               while(_loc47_ < _loc11_)
               {
                  _loc48_ = _loc8_[_loc47_];
                  _loc49_ = int(_loc48_.spellCooldowns.length);
                  _loc50_ = 0;
                  while(_loc50_ < _loc49_)
                  {
                     _loc51_ = _loc48_.spellCooldowns[_loc50_];
                     _loc52_ = SpellWrapper.getFirstSpellWrapperById(_loc51_.spellId,_loc48_.slaveId);
                     if((Boolean(_loc52_)) && _loc52_.spellLevel > 0)
                     {
                        _loc53_ = _loc52_.spell.getSpellLevel(_loc52_.spellLevel);
                        _loc54_ = _loc10_.getSpellCastManagerById(_loc48_.slaveId);
                        _loc54_.castSpell(_loc52_.id,_loc52_.spellLevel,[],false);
                        _loc55_ = int(_loc53_.minCastInterval);
                        if(_loc51_.cooldown != 63)
                        {
                           _loc56_ = new SpellModificator();
                           _loc57_ = PlayedCharacterManager.getInstance().characteristics;
                           for each(_loc58_ in _loc57_.spellModifications)
                           {
                              if(_loc58_.spellId != _loc51_.spellId)
                              {
                                 continue;
                              }
                              switch(_loc58_.modificationType)
                              {
                                 case CharacterSpellModificationTypeEnum.CAST_INTERVAL:
                                    _loc56_.castInterval = _loc58_.value;
                                    break;
                                 case CharacterSpellModificationTypeEnum.CAST_INTERVAL_SET:
                                    _loc56_.castIntervalSet = _loc58_.value;
                                    break;
                              }
                           }
                           if(_loc56_.getTotalBonus(_loc56_.castIntervalSet))
                           {
                              _loc55_ = -_loc56_.getTotalBonus(_loc56_.castInterval) + _loc56_.getTotalBonus(_loc56_.castIntervalSet);
                           }
                           else
                           {
                              _loc55_ -= _loc56_.getTotalBonus(_loc56_.castInterval);
                           }
                        }
                        _loc54_.getSpellManagerBySpellId(_loc52_.id).forceLastCastTurn(_loc7_.gameTurn - 1 + _loc51_.cooldown - _loc55_);
                     }
                     _loc50_++;
                  }
                  _loc47_++;
               }
               _loc12_ = [];
               for each(_loc59_ in _loc7_.effects)
               {
                  if(!_loc12_[_loc59_.effect.targetId])
                  {
                     _loc12_[_loc59_.effect.targetId] = [];
                  }
                  _loc13_ = _loc12_[_loc59_.effect.targetId];
                  if(!_loc13_[_loc59_.effect.turnDuration])
                  {
                     _loc13_[_loc59_.effect.turnDuration] = [];
                  }
                  _loc14_ = _loc13_[_loc59_.effect.turnDuration];
                  _loc15_ = _loc14_[_loc59_.effect.spellId];
                  if(!_loc15_)
                  {
                     _loc15_ = new CastingSpell();
                     _loc15_.casterId = _loc59_.sourceId;
                     _loc15_.spell = Spell.getSpellById(_loc59_.effect.spellId);
                     _loc14_[_loc59_.effect.spellId] = _loc15_;
                  }
                  _loc60_ = BuffManager.makeBuffFromEffect(_loc59_.effect,_loc15_,_loc59_.actionId);
                  BuffManager.getInstance().addBuff(_loc60_);
               }
               for each(_loc61_ in _loc7_.marks)
               {
                  _loc62_ = Spell.getSpellById(_loc61_.markSpellId);
                  MarkedCellsManager.getInstance().addMark(_loc61_.markId,_loc61_.markType,_loc62_,_loc61_.cells);
                  if(_loc62_.getParamByName("glyphGfxId"))
                  {
                     for each(_loc63_ in _loc61_.cells)
                     {
                        _loc64_ = new AddGlyphGfxStep(_loc62_.getParamByName("glyphGfxId"),_loc63_.cellId,_loc61_.markId,_loc61_.markType);
                        _loc64_.start();
                     }
                  }
               }
               Kernel.beingInReconection = false;
               return true;
            case param1 is GameFightUpdateTeamMessage:
               _loc16_ = param1 as GameFightUpdateTeamMessage;
               PlayedCharacterManager.getInstance().teamId = _loc16_.team.teamId;
               return true;
            case param1 is GameFightSpectateMessage:
               _loc17_ = param1 as GameFightSpectateMessage;
               this.tacticModeHandler();
               this._battleFrame.turnsCount = _loc17_.gameTurn - 1;
               KernelEventsManager.getInstance().processCallback(FightHookList.TurnCountUpdated,_loc17_.gameTurn - 1);
               _loc18_ = [];
               for each(_loc65_ in _loc17_.effects)
               {
                  if(!_loc18_[_loc65_.effect.targetId])
                  {
                     _loc18_[_loc65_.effect.targetId] = [];
                  }
                  _loc19_ = _loc18_[_loc65_.effect.targetId];
                  if(!_loc19_[_loc65_.effect.turnDuration])
                  {
                     _loc19_[_loc65_.effect.turnDuration] = [];
                  }
                  _loc20_ = _loc19_[_loc65_.effect.turnDuration];
                  _loc21_ = _loc20_[_loc65_.effect.spellId];
                  if(!_loc21_)
                  {
                     _loc21_ = new CastingSpell();
                     _loc21_.casterId = _loc65_.sourceId;
                     _loc21_.spell = Spell.getSpellById(_loc65_.effect.spellId);
                     _loc20_[_loc65_.effect.spellId] = _loc21_;
                  }
                  _loc66_ = BuffManager.makeBuffFromEffect(_loc65_.effect,_loc21_,_loc65_.actionId);
                  BuffManager.getInstance().addBuff(_loc66_,!(_loc66_ is StatBuff));
               }
               for each(_loc67_ in _loc17_.marks)
               {
                  _loc68_ = Spell.getSpellById(_loc67_.markSpellId);
                  MarkedCellsManager.getInstance().addMark(_loc67_.markId,_loc67_.markType,_loc68_,_loc67_.cells);
                  if(_loc68_.getParamByName("glyphGfxId"))
                  {
                     for each(_loc69_ in _loc67_.cells)
                     {
                        _loc70_ = new AddGlyphGfxStep(_loc68_.getParamByName("glyphGfxId"),_loc69_.cellId,_loc67_.markId,_loc67_.markType);
                        _loc70_.start();
                     }
                  }
               }
               FightEventsHelper.sendAllFightEvent();
               return true;
            case param1 is INetworkMessage && INetworkMessage(param1).getMessageId() == GameFightJoinMessage.protocolId:
               _loc22_ = param1 as GameFightJoinMessage;
               preFightIsActive = !_loc22_.isFightStarted;
               this.fightType = _loc22_.fightType;
               Kernel.getWorker().addFrame(this._entitiesFrame);
               if(preFightIsActive)
               {
                  Kernel.getWorker().addFrame(this._preparationFrame);
               }
               else
               {
                  Kernel.getWorker().removeFrame(this._preparationFrame);
                  Kernel.getWorker().addFrame(this._battleFrame);
                  KernelEventsManager.getInstance().processCallback(HookList.GameFightStart);
               }
               PlayedCharacterManager.getInstance().isSpectator = _loc22_.isSpectator;
               PlayedCharacterManager.getInstance().isFighting = true;
               _loc23_ = int(_loc22_.timeMaxBeforeFightStart);
               if(_loc23_ == 0 && preFightIsActive)
               {
                  _loc23_ = -1;
               }
               KernelEventsManager.getInstance().processCallback(HookList.GameFightJoin,_loc22_.canBeCancelled,_loc22_.canSayReady,_loc22_.isSpectator,_loc23_,_loc22_.fightType);
               return true;
            case param1 is GameActionFightCarryCharacterMessage:
               _loc24_ = param1 as GameActionFightCarryCharacterMessage;
               if(Boolean(this._lastEffectEntity) && this._lastEffectEntity.object.id == _loc24_.targetId)
               {
                  this.process(new EntityMouseOutMessage(this._lastEffectEntity.object as IInteractive));
               }
               return false;
            case param1 is GameFightStartMessage:
               preFightIsActive = false;
               Kernel.getWorker().removeFrame(this._preparationFrame);
               this._entitiesFrame.removeSwords();
               CurrentPlayedFighterManager.getInstance().getSpellCastManager().resetInitialCooldown();
               Kernel.getWorker().addFrame(this._battleFrame);
               KernelEventsManager.getInstance().processCallback(HookList.GameFightStart);
               SoundManager.getInstance().manager.playFightMusic();
               return true;
            case param1 is CellOutMessage:
               _loc25_ = param1 as CellOutMessage;
               for each(_loc71_ in EntitiesManager.getInstance().getEntitiesOnCell(_loc25_.cellId))
               {
                  if(_loc71_ is AnimatedCharacter)
                  {
                     _loc26_ = _loc71_ as AnimatedCharacter;
                     break;
                  }
               }
               if(_loc26_)
               {
                  TooltipManager.hide();
                  TooltipManager.hide("fighter");
                  this.outEntity(_loc26_.id);
               }
               currentCell = -1;
               return true;
            case param1 is CellOverMessage:
               _loc27_ = param1 as CellOverMessage;
               for each(_loc72_ in EntitiesManager.getInstance().getEntitiesOnCell(_loc27_.cellId))
               {
                  if(_loc72_ is AnimatedCharacter && !(_loc72_ as AnimatedCharacter).isMoving)
                  {
                     _loc28_ = _loc72_ as AnimatedCharacter;
                     break;
                  }
               }
               if(_loc28_)
               {
                  this.overEntity(_loc28_.id);
               }
               currentCell = _loc27_.cellId;
               return true;
            case param1 is EntityMouseOverMessage:
               _loc29_ = param1 as EntityMouseOverMessage;
               currentCell = _loc29_.entity.position.cellId;
               this.overEntity(_loc29_.entity.id);
               return true;
            case param1 is EntityMouseOutMessage:
               _loc30_ = param1 as EntityMouseOutMessage;
               currentCell = -1;
               this.outEntity(_loc30_.entity.id);
               return true;
            case param1 is TimelineEntityOverAction:
               _loc31_ = param1 as TimelineEntityOverAction;
               this.overEntity(_loc31_.targetId,_loc31_.showRange);
               timelineOverEntityId = _loc31_.targetId;
               return true;
            case param1 is TimelineEntityOutAction:
               TooltipManager.hideAll();
               this.outEntity(TimelineEntityOutAction(param1).targetId);
               timelineOverEntityId = 0;
               return true;
            case param1 is TogglePointCellAction:
               _loc32_ = param1 as TogglePointCellAction;
               if(Kernel.getWorker().contains(FightPointCellFrame))
               {
                  KernelEventsManager.getInstance().processCallback(HookList.ShowCell);
                  Kernel.getWorker().removeFrame(this._pointCellFrame);
               }
               else
               {
                  Kernel.getWorker().addFrame(this._pointCellFrame);
               }
               return true;
            case param1 is GameFightEndMessage:
               _loc33_ = param1 as GameFightEndMessage;
               if(TacticModeManager.getInstance().tacticModeActivated)
               {
                  TacticModeManager.getInstance().hide(true);
               }
               if(this._entitiesFrame.isInCreaturesFightMode())
               {
                  this._entitiesFrame.showCreaturesInFight(false);
               }
               TooltipManager.hide();
               TooltipManager.hide("fighter");
               this.hideMovementRange();
               CurrentPlayedFighterManager.getInstance().resetPlayerSpellList();
               MapDisplayManager.getInstance().activeIdentifiedElements(true);
               FightEventsHelper.sendAllFightEvent(true);
               if(!PlayedCharacterManager.getInstance().isSpectator)
               {
                  FightEventsHelper.sendFightEvent(FightEventEnum.FIGHT_END,[],0,-1,true);
               }
               SoundManager.getInstance().manager.stopFightMusic();
               PlayedCharacterManager.getInstance().isFighting = false;
               SpellWrapper.removeAllSpellWrapperBut(PlayedCharacterManager.getInstance().id,SecureCenter.ACCESS_KEY);
               SpellWrapper.resetAllCoolDown(PlayedCharacterManager.getInstance().id,SecureCenter.ACCESS_KEY);
               if(_loc33_.results == null)
               {
                  KernelEventsManager.getInstance().processCallback(FightHookList.SpectatorWantLeave);
               }
               else
               {
                  _loc73_ = new FightEndingMessage();
                  _loc73_.initFightEndingMessage();
                  Kernel.getWorker().process(_loc73_);
                  _loc74_ = new Vector.<FightResultEntryWrapper>();
                  _loc75_ = 0;
                  _loc77_ = new Vector.<FightResultEntryWrapper>();
                  for each(_loc78_ in _loc33_.results)
                  {
                     switch(true)
                     {
                        case _loc78_ is FightResultPlayerListEntry:
                           _loc80_ = new FightResultEntryWrapper(_loc78_,this._entitiesFrame.getEntityInfos((_loc78_ as FightResultPlayerListEntry).id) as GameFightFighterInformations);
                           _loc80_.alive = FightResultPlayerListEntry(_loc78_).alive;
                           break;
                        case _loc78_ is FightResultTaxCollectorListEntry:
                           _loc80_ = new FightResultEntryWrapper(_loc78_,this._entitiesFrame.getEntityInfos((_loc78_ as FightResultTaxCollectorListEntry).id) as GameFightFighterInformations);
                           _loc80_.alive = FightResultTaxCollectorListEntry(_loc78_).alive;
                           break;
                        case _loc78_ is FightResultFighterListEntry:
                           _loc80_ = new FightResultEntryWrapper(_loc78_,this._entitiesFrame.getEntityInfos((_loc78_ as FightResultFighterListEntry).id) as GameFightFighterInformations);
                           _loc80_.alive = FightResultFighterListEntry(_loc78_).alive;
                           break;
                        case _loc78_ is FightResultListEntry:
                           _loc80_ = new FightResultEntryWrapper(_loc78_);
                     }
                     if(_loc78_.outcome == FightOutcomeEnum.RESULT_DEFENDER_GROUP)
                     {
                        _loc76_ = _loc80_;
                     }
                     else
                     {
                        if(_loc78_.outcome == FightOutcomeEnum.RESULT_VICTORY)
                        {
                           _loc77_.push(_loc80_);
                        }
                        var _loc91_:*;
                        _loc74_[_loc91_ = _loc75_++] = _loc80_;
                     }
                     if(_loc80_.id == PlayedCharacterManager.getInstance().infos.id)
                     {
                        switch(_loc78_.outcome)
                        {
                           case FightOutcomeEnum.RESULT_VICTORY:
                              KernelEventsManager.getInstance().processCallback(TriggerHookList.FightResultVictory);
                              SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_FIGHT_WON);
                              break;
                           case FightOutcomeEnum.RESULT_LOST:
                              SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_FIGHT_LOST);
                        }
                        if(_loc80_.rewards.objects.length >= SpeakingItemManager.GREAT_DROP_LIMIT)
                        {
                           SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_GREAT_DROP);
                        }
                     }
                  }
                  if(_loc76_)
                  {
                     _loc81_ = 0;
                     for each(_loc82_ in _loc76_.rewards.objects)
                     {
                        _loc77_[_loc81_].rewards.objects.push(_loc82_);
                        _loc81_ = ++_loc81_ % _loc77_.length;
                     }
                     _loc83_ = int(_loc76_.rewards.kamas);
                     _loc84_ = _loc83_ / _loc77_.length;
                     if(_loc83_ % _loc77_.length != 0)
                     {
                        _loc84_++;
                     }
                     for each(_loc85_ in _loc77_)
                     {
                        if(_loc83_ < _loc84_)
                        {
                           _loc85_.rewards.kamas = _loc83_;
                        }
                        else
                        {
                           _loc85_.rewards.kamas = _loc84_;
                        }
                        _loc83_ -= _loc85_.rewards.kamas;
                     }
                  }
                  _loc79_ = new Object();
                  _loc79_.results = _loc74_;
                  _loc79_.ageBonus = _loc33_.ageBonus;
                  _loc79_.sizeMalus = _loc33_.lootShareLimitMalus;
                  _loc79_.duration = _loc33_.duration;
                  _loc79_.challenges = this.challengesList;
                  _loc79_.turns = this._battleFrame.turnsCount;
                  _loc79_.fightType = this._fightType;
                  _log.debug("Sending the GameFightEnd hook. " + this._battleFrame.turnsCount);
                  KernelEventsManager.getInstance().processCallback(HookList.GameFightEnd,_loc79_);
               }
               Kernel.getWorker().removeFrame(this);
               return true;
            case param1 is ChallengeTargetsListRequestAction:
               _loc34_ = param1 as ChallengeTargetsListRequestAction;
               _loc35_ = new ChallengeTargetsListRequestMessage();
               _loc35_.initChallengeTargetsListRequestMessage(_loc34_.challengeId);
               ConnectionsHandler.getConnection().send(_loc35_);
               return true;
            case param1 is ChallengeTargetsListMessage:
               _loc36_ = param1 as ChallengeTargetsListMessage;
               for each(_loc86_ in _loc36_.targetCells)
               {
                  if(_loc86_ != -1)
                  {
                     HyperlinkShowCellManager.showCell(_loc86_);
                  }
               }
               return true;
            case param1 is ChallengeInfoMessage:
               _loc37_ = param1 as ChallengeInfoMessage;
               _loc38_ = this.getChallengeById(_loc37_.challengeId);
               if(!_loc38_)
               {
                  _loc38_ = new ChallengeWrapper();
                  this.challengesList.push(_loc38_);
               }
               _loc38_.id = _loc37_.challengeId;
               _loc38_.targetId = _loc37_.targetId;
               _loc38_.xpBonus = _loc37_.xpBonus;
               _loc38_.dropBonus = _loc37_.dropBonus;
               _loc38_.result = 0;
               KernelEventsManager.getInstance().processCallback(FightHookList.ChallengeInfoUpdate,this.challengesList);
               return true;
            case param1 is ChallengeTargetUpdateMessage:
               _loc39_ = param1 as ChallengeTargetUpdateMessage;
               _loc38_ = this.getChallengeById(_loc39_.challengeId);
               if(_loc38_ == null)
               {
                  _log.warn("Got a challenge result with no corresponding challenge (challenge id " + _loc39_.challengeId + "), skipping.");
                  return false;
               }
               _loc38_.targetId = _loc39_.targetId;
               KernelEventsManager.getInstance().processCallback(FightHookList.ChallengeInfoUpdate,this.challengesList);
               return true;
               break;
            case param1 is ChallengeResultMessage:
               _loc40_ = param1 as ChallengeResultMessage;
               _loc38_ = this.getChallengeById(_loc40_.challengeId);
               if(!_loc38_)
               {
                  _log.warn("Got a challenge result with no corresponding challenge (challenge id " + _loc40_.challengeId + "), skipping.");
                  return false;
               }
               _loc38_.result = _loc40_.success ? 1 : 2;
               KernelEventsManager.getInstance().processCallback(FightHookList.ChallengeInfoUpdate,this.challengesList);
               return true;
               break;
            case param1 is MapObstacleUpdateMessage:
               _loc41_ = param1 as MapObstacleUpdateMessage;
               for each(_loc87_ in _loc41_.obstacles)
               {
                  InteractiveCellManager.getInstance().updateCell(_loc87_.obstacleCellId,_loc87_.state == MapObstacleStateEnum.OBSTACLE_OPENED);
               }
               return true;
            case param1 is GameActionFightNoSpellCastMessage:
               _loc42_ = param1 as GameActionFightNoSpellCastMessage;
               if(_loc42_.spellLevelId != 0 || !PlayedCharacterManager.getInstance().currentWeapon)
               {
                  if(_loc42_.spellLevelId == 0)
                  {
                     _loc88_ = Spell.getSpellById(0).getSpellLevel(1);
                  }
                  else
                  {
                     _loc88_ = SpellLevel.getLevelById(_loc42_.spellLevelId);
                  }
                  _loc43_ = _loc88_.apCost;
               }
               else
               {
                  _loc43_ = uint(PlayedCharacterManager.getInstance().currentWeapon.apCost);
               }
               CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations().actionPointsCurrent = CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations().actionPointsCurrent + _loc43_;
               return true;
            case param1 is ShowTacticModeAction:
               if(PlayedCharacterApi.isInPreFight())
               {
                  return false;
               }
               if(PlayedCharacterApi.isInFight() || PlayedCharacterManager.getInstance().isSpectator)
               {
                  this.tacticModeHandler(true);
               }
               return true;
         }
         return false;
      }
      
      public function pulled() : Boolean
      {
         if(TacticModeManager.getInstance().tacticModeActivated)
         {
            TacticModeManager.getInstance().hide(true);
         }
         if(this._entitiesFrame)
         {
            Kernel.getWorker().removeFrame(this._entitiesFrame);
         }
         if(this._preparationFrame)
         {
            Kernel.getWorker().removeFrame(this._preparationFrame);
         }
         if(this._battleFrame)
         {
            Kernel.getWorker().removeFrame(this._battleFrame);
         }
         if(this._pointCellFrame)
         {
            Kernel.getWorker().removeFrame(this._pointCellFrame);
         }
         SerialSequencer.clearByType(FightSequenceFrame.FIGHT_SEQUENCERS_CATEGORY);
         this._preparationFrame = null;
         this._battleFrame = null;
         this._pointCellFrame = null;
         this._lastEffectEntity = null;
         TooltipManager.hideAll();
         this._timerFighterInfo.reset();
         this._timerFighterInfo.removeEventListener(TimerEvent.TIMER,this.showFighterInfo);
         this._timerFighterInfo = null;
         this._timerMovementRange.reset();
         this._timerMovementRange.removeEventListener(TimerEvent.TIMER,this.showMovementRange);
         this._timerMovementRange = null;
         this._currentFighterInfo = null;
         if(MapDisplayManager.getInstance().getDataMapContainer())
         {
            MapDisplayManager.getInstance().getDataMapContainer().setTemporaryAnimatedElementState(true);
         }
         Atouin.getInstance().displayGrid(false);
         var _loc1_:UiRootContainer = Berilia.getInstance().getUi("mapInfo");
         if(_loc1_)
         {
            _loc1_.visible = true;
         }
         return true;
      }
      
      public function outEntity(param1:int) : void
      {
         this._timerFighterInfo.reset();
         this._timerMovementRange.reset();
         var _loc2_:Vector.<int> = this._entitiesFrame.getEntitiesIdsList();
         fighterEntityTooltipId = param1;
         var _loc3_:IEntity = DofusEntities.getEntity(fighterEntityTooltipId);
         if(!_loc3_)
         {
            if(_loc2_.indexOf(fighterEntityTooltipId) == -1)
            {
               _log.warn("Mouse over an unknown entity : " + param1);
               return;
            }
         }
         if(Boolean(this._lastEffectEntity) && this._lastEffectEntity.object)
         {
            Sprite(this._lastEffectEntity.object).filters = [];
         }
         this._lastEffectEntity = null;
         var _loc4_:String = "tooltipOverEntity_" + param1;
         if(TooltipManager.isVisible(_loc4_))
         {
            TooltipManager.hide(_loc4_);
         }
         if(_loc3_ != null)
         {
            Sprite(_loc3_).filters = [];
         }
         this.hideMovementRange();
         var _loc5_:Selection = SelectionManager.getInstance().getSelection(this.INVISIBLE_POSITION_SELECTION);
         if(_loc5_)
         {
            _loc5_.remove();
         }
         this.removeAsLinkEntityEffect();
         if(Boolean(this._currentFighterInfo) && this._currentFighterInfo.contextualId == param1)
         {
            KernelEventsManager.getInstance().processCallback(FightHookList.FighterInfoUpdate,null);
         }
      }
      
      private function getFighterInfos(param1:int) : GameFightFighterInformations
      {
         return this.entitiesFrame.getEntityInfos(param1) as GameFightFighterInformations;
      }
      
      private function showFighterInfo(param1:TimerEvent) : void
      {
         this._timerFighterInfo.reset();
         KernelEventsManager.getInstance().processCallback(FightHookList.FighterInfoUpdate,this._currentFighterInfo);
      }
      
      private function showMovementRange(param1:TimerEvent) : void
      {
         this._timerMovementRange.reset();
         this._reachableRangeSelection = new Selection();
         this._reachableRangeSelection.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA);
         this._reachableRangeSelection.color = new Color(52326);
         this._unreachableRangeSelection = new Selection();
         this._unreachableRangeSelection.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA);
         this._unreachableRangeSelection.color = new Color(6684672);
         var _loc2_:int = getTimer();
         var _loc3_:FightReachableCellsMaker = new FightReachableCellsMaker(this._currentFighterInfo);
         this._reachableRangeSelection.zone = new Custom(_loc3_.reachableCells);
         this._unreachableRangeSelection.zone = new Custom(_loc3_.unreachableCells);
         SelectionManager.getInstance().addSelection(this._reachableRangeSelection,"movementReachableRange",this._currentFighterInfo.disposition.cellId);
         SelectionManager.getInstance().addSelection(this._unreachableRangeSelection,"movementUnreachableRange",this._currentFighterInfo.disposition.cellId);
      }
      
      private function hideMovementRange() : void
      {
         var _loc1_:Selection = SelectionManager.getInstance().getSelection("movementReachableRange");
         if(_loc1_)
         {
            _loc1_.remove();
            this._reachableRangeSelection = null;
         }
         _loc1_ = SelectionManager.getInstance().getSelection("movementUnreachableRange");
         if(_loc1_)
         {
            _loc1_.remove();
            this._unreachableRangeSelection = null;
         }
      }
      
      private function removeAsLinkEntityEffect() : void
      {
         var _loc1_:int = 0;
         var _loc2_:DisplayObject = null;
         var _loc3_:int = 0;
         for each(_loc1_ in this._entitiesFrame.getEntitiesIdsList())
         {
            _loc2_ = DofusEntities.getEntity(_loc1_) as DisplayObject;
            if(_loc2_ && _loc2_.filters && Boolean(_loc2_.filters.length))
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_.filters.length)
               {
                  if(_loc2_.filters[_loc3_] is ColorMatrixFilter)
                  {
                     _loc2_.filters = _loc2_.filters.splice(_loc3_,_loc3_);
                     break;
                  }
                  _loc3_++;
               }
            }
         }
      }
      
      private function highlightAsLinkedEntity(param1:int, param2:Boolean) : void
      {
         var _loc5_:ColorMatrixFilter = null;
         var _loc3_:IEntity = DofusEntities.getEntity(param1);
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:Sprite = _loc3_ as Sprite;
         if((Boolean(_loc4_)) && Boolean(Dofus.getInstance().options.showGlowOverTarget))
         {
            _loc5_ = param2 ? this._linkedMainEffect : this._linkedEffect;
            if(_loc4_.filters.length)
            {
               if(_loc4_.filters[0] != _loc5_)
               {
                  _loc4_.filters = [_loc5_];
               }
            }
            else
            {
               _loc4_.filters = [_loc5_];
            }
         }
      }
      
      private function overEntity(param1:int, param2:Boolean = true) : void
      {
         var _loc7_:int = 0;
         var _loc10_:GameFightFighterInformations = null;
         var _loc11_:Selection = null;
         var _loc12_:int = 0;
         var _loc13_:FightReachableCellsMaker = null;
         var _loc14_:FightSpellCastFrame = null;
         var _loc15_:GlowFilter = null;
         var _loc16_:FightTurnFrame = null;
         var _loc17_:Boolean = false;
         var _loc3_:Vector.<int> = this._entitiesFrame.getEntitiesIdsList();
         fighterEntityTooltipId = param1;
         var _loc4_:IEntity = DofusEntities.getEntity(fighterEntityTooltipId);
         if(!_loc4_)
         {
            if(_loc3_.indexOf(fighterEntityTooltipId) == -1)
            {
               _log.warn("Mouse over an unknown entity : " + param1);
               return;
            }
            param2 = false;
         }
         var _loc5_:GameFightFighterInformations = this._entitiesFrame.getEntityInfos(param1) as GameFightFighterInformations;
         if(!_loc5_)
         {
            _log.warn("Mouse over an unknown entity : " + param1);
            return;
         }
         var _loc6_:int = _loc5_.stats.summoner;
         for each(_loc7_ in _loc3_)
         {
            if(_loc7_ != param1)
            {
               _loc10_ = this._entitiesFrame.getEntityInfos(_loc7_) as GameFightFighterInformations;
               if(_loc10_.stats.summoner == param1 || _loc6_ == _loc7_ || _loc10_.stats.summoner == _loc6_ && _loc6_)
               {
                  this.highlightAsLinkedEntity(_loc7_,_loc6_ == _loc7_);
               }
            }
         }
         this._currentFighterInfo = _loc5_;
         if(Dofus.getInstance().options.showEntityInfos)
         {
            this._timerFighterInfo.reset();
            this._timerFighterInfo.start();
         }
         if(_loc5_.stats.invisibilityState == GameActionFightInvisibilityStateEnum.INVISIBLE)
         {
            _log.warn("Mouse over an invisible entity.");
            _loc11_ = SelectionManager.getInstance().getSelection(this.INVISIBLE_POSITION_SELECTION);
            if(!_loc11_)
            {
               _loc11_ = new Selection();
               _loc11_.color = new Color(52326);
               _loc11_.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA);
               SelectionManager.getInstance().addSelection(_loc11_,this.INVISIBLE_POSITION_SELECTION);
            }
            _loc12_ = FightEntitiesFrame.getCurrentInstance().getLastKnownEntityPosition(_loc5_.contextualId);
            if(_loc12_ > -1)
            {
               _loc13_ = new FightReachableCellsMaker(this._currentFighterInfo,_loc12_,FightEntitiesFrame.getCurrentInstance().getLastKnownEntityMovementPoint(_loc5_.contextualId));
               _loc11_.zone = new Custom(_loc13_.reachableCells);
               SelectionManager.getInstance().update(this.INVISIBLE_POSITION_SELECTION,_loc12_);
            }
            return;
         }
         if(_loc5_ is GameFightCharacterInformations && _loc4_ != null)
         {
            TooltipManager.show(_loc5_,(_loc4_ as IDisplayable).absoluteBounds,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,"tooltipOverEntity_" + _loc5_.contextualId,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,null,null,null,"PlayerShortInfos");
         }
         else if(_loc4_ != null)
         {
            TooltipManager.show(_loc5_,(_loc4_ as IDisplayable).absoluteBounds,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,"tooltipOverEntity_" + _loc5_.contextualId,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,"monsterFighter",null,null,"EntityShortInfos");
         }
         var _loc8_:Selection = SelectionManager.getInstance().getSelection(FightTurnFrame.SELECTION_PATH);
         if(_loc8_)
         {
            _loc8_.remove();
         }
         if(param2)
         {
            if(Dofus.getInstance().options.showMovementRange && Kernel.getWorker().contains(FightBattleFrame) && !Kernel.getWorker().contains(FightSpellCastFrame))
            {
               this._timerMovementRange.reset();
               this._timerMovementRange.start();
            }
         }
         if(this._lastEffectEntity && this._lastEffectEntity.object is Sprite && this._lastEffectEntity.object != _loc4_)
         {
            Sprite(this._lastEffectEntity.object).filters = [];
         }
         var _loc9_:Sprite = _loc4_ as Sprite;
         if((Boolean(_loc9_)) && Boolean(Dofus.getInstance().options.showGlowOverTarget))
         {
            _loc14_ = Kernel.getWorker().getFrame(FightSpellCastFrame) as FightSpellCastFrame;
            _loc16_ = Kernel.getWorker().getFrame(FightTurnFrame) as FightTurnFrame;
            _loc17_ = !!_loc16_ ? _loc16_.myTurn : true;
            if((!_loc14_ || _loc14_ && _loc14_.currentTargetIsTargetable) && _loc17_)
            {
               _loc15_ = this._overEffectOk;
            }
            else
            {
               _loc15_ = this._overEffectKo;
            }
            if(_loc9_.filters.length)
            {
               if(_loc9_.filters[0] != _loc15_)
               {
                  _loc9_.filters = [_loc15_];
               }
            }
            else
            {
               _loc9_.filters = [_loc15_];
            }
            this._lastEffectEntity = new WeakReference(_loc4_);
         }
      }
      
      private function tacticModeHandler(param1:Boolean = false) : void
      {
         if(param1 && !TacticModeManager.getInstance().tacticModeActivated)
         {
            TacticModeManager.getInstance().show(PlayedCharacterManager.getInstance().currentMap);
         }
         else if(TacticModeManager.getInstance().tacticModeActivated)
         {
            TacticModeManager.getInstance().hide();
         }
      }
   }
}

