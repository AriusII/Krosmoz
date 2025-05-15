package com.ankamagames.dofus.logic.game.fight.frames
{
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.kernel.sound.enum.UISoundEnum;
   import com.ankamagames.dofus.logic.game.common.frames.PlayedCharacterUpdatesFrame;
   import com.ankamagames.dofus.logic.game.common.managers.AFKFightManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.actions.DisableAfkAction;
   import com.ankamagames.dofus.logic.game.fight.actions.GameFightTurnFinishAction;
   import com.ankamagames.dofus.logic.game.fight.actions.ShowAllNamesAction;
   import com.ankamagames.dofus.logic.game.fight.fightEvents.FightEventsHelper;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.fight.managers.FightersStateManager;
   import com.ankamagames.dofus.logic.game.fight.managers.MarkedCellsManager;
   import com.ankamagames.dofus.logic.game.fight.messages.GameActionFightLeaveMessage;
   import com.ankamagames.dofus.logic.game.fight.miscs.FightEntitiesHolder;
   import com.ankamagames.dofus.logic.game.roleplay.frames.InfoEntitiesFrame;
   import com.ankamagames.dofus.misc.lists.FightHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.messages.game.actions.GameActionAcknowledgementMessage;
   import com.ankamagames.dofus.network.messages.game.actions.sequence.SequenceEndMessage;
   import com.ankamagames.dofus.network.messages.game.actions.sequence.SequenceStartMessage;
   import com.ankamagames.dofus.network.messages.game.character.stats.CharacterStatsListMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextDestroyMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightEndMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightLeaveMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightNewRoundMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightSynchronizeMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightTurnEndMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightTurnListMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightTurnReadyMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightTurnReadyRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightTurnResumeMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightTurnStartMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightTurnStartSlaveMessage;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.sequences.AddGfxEntityStep;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.jerakine.handlers.messages.Action;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   import gs.TweenMax;
   
   public class FightBattleFrame implements Frame
   {
      public static const FIGHT_SEQUENCER_NAME:String = "FightBattleSequencer";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FightBattleFrame));
      
      private var _sequenceFrameSwitcher:FightSequenceSwitcherFrame;
      
      private var _turnFrame:FightTurnFrame = new FightTurnFrame();
      
      private var _currentSequenceFrame:FightSequenceFrame;
      
      private var _sequenceFrames:Array;
      
      private var _executingSequence:Boolean;
      
      private var _confirmTurnEnd:Boolean;
      
      private var _endBattle:Boolean;
      
      private var _leaveSpectator:Boolean;
      
      private var _battleResults:GameFightEndMessage;
      
      private var _refreshTurnsList:Boolean;
      
      private var _newTurnsList:Vector.<int>;
      
      private var _newDeadTurnsList:Vector.<int>;
      
      private var _turnsList:Vector.<int>;
      
      private var _deadTurnsList:Vector.<int>;
      
      private var _synchroniseFighters:Vector.<GameFightFighterInformations> = null;
      
      private var _synchroniseFightersInstanceId:uint = 4294967295;
      
      private var _delayCslmsg:CharacterStatsListMessage;
      
      private var _playerNewTurn:AnimatedCharacter;
      
      private var _turnsCount:uint = 0;
      
      private var _destroyed:Boolean;
      
      private var _playingSlaveEntity:Boolean = false;
      
      private var _lastPlayerId:int;
      
      private var _currentPlayerId:uint;
      
      private var _skipTurnTimer:Timer;
      
      private var _infoEntitiesFrame:InfoEntitiesFrame = new InfoEntitiesFrame();
      
      public function FightBattleFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.HIGH;
      }
      
      public function get fightersList() : Vector.<int>
      {
         return this._turnsList;
      }
      
      public function get deadFightersList() : Vector.<int>
      {
         return this._deadTurnsList;
      }
      
      public function get turnsCount() : uint
      {
         return this._turnsCount;
      }
      
      public function set turnsCount(param1:uint) : void
      {
         this._turnsCount = param1;
      }
      
      public function get currentPlayerId() : int
      {
         return this._currentPlayerId;
      }
      
      public function get executingSequence() : Boolean
      {
         return this._executingSequence;
      }
      
      public function get currentSequenceFrame() : FightSequenceFrame
      {
         return this._currentSequenceFrame;
      }
      
      public function pushed() : Boolean
      {
         this._playingSlaveEntity = false;
         this._sequenceFrames = new Array();
         DataMapProvider.getInstance().isInFight = true;
         Kernel.getWorker().addFrame(this._turnFrame);
         this._destroyed = false;
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:GameFightTurnListMessage = null;
         var _loc3_:GameFightSynchronizeMessage = null;
         var _loc4_:GameFightTurnStartMessage = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:SoundApi = null;
         var _loc8_:GameFightFighterInformations = null;
         var _loc9_:GameFightTurnEndMessage = null;
         var _loc10_:GameContextActorInformations = null;
         var _loc11_:SequenceStartMessage = null;
         var _loc12_:SequenceEndMessage = null;
         var _loc13_:GameFightNewRoundMessage = null;
         var _loc14_:GameFightLeaveMessage = null;
         var _loc15_:GameFightFighterInformations = null;
         var _loc16_:FightSequenceFrame = null;
         var _loc17_:GameFightEndMessage = null;
         var _loc18_:uint = 0;
         var _loc19_:AnimatedCharacter = null;
         var _loc20_:SerialSequencer = null;
         var _loc21_:Number = NaN;
         var _loc22_:SerialSequencer = null;
         var _loc23_:int = 0;
         var _loc24_:Action = null;
         var _loc25_:FightEntitiesFrame = null;
         var _loc26_:int = 0;
         var _loc27_:GameContextActorInformations = null;
         var _loc28_:GameFightFighterInformations = null;
         var _loc29_:GameActionFightLeaveMessage = null;
         var _loc30_:SequenceEndMessage = null;
         var _loc31_:GameFightEndMessage = null;
         switch(true)
         {
            case param1 is GameFightTurnListMessage:
               _loc2_ = param1 as GameFightTurnListMessage;
               if(this._executingSequence || Boolean(this._currentSequenceFrame))
               {
                  _log.debug("There was a turns list update during this sequence... Let\'s wait its finish before doing it.");
                  this._refreshTurnsList = true;
                  this._newTurnsList = _loc2_.ids;
                  this._newDeadTurnsList = _loc2_.deadsIds;
               }
               else
               {
                  this.updateTurnsList(_loc2_.ids,_loc2_.deadsIds);
               }
               return true;
            case param1 is GameFightSynchronizeMessage:
               _loc3_ = param1 as GameFightSynchronizeMessage;
               if(this._executingSequence)
               {
                  this._synchroniseFighters = _loc3_.fighters;
                  this._synchroniseFightersInstanceId = FightSequenceFrame.currentInstanceId;
               }
               else
               {
                  this.gameFightSynchronize(_loc3_.fighters,false);
               }
               return true;
            case param1 is GameFightTurnStartMessage:
               _loc4_ = param1 as GameFightTurnStartMessage;
               _loc5_ = PlayedCharacterManager.getInstance().id;
               _loc6_ = 0;
               if(param1 is GameFightTurnStartSlaveMessage)
               {
                  _loc6_ = (param1 as GameFightTurnStartSlaveMessage).idSummoner;
                  this._playingSlaveEntity = _loc6_ == _loc5_;
               }
               else
               {
                  if(this._playingSlaveEntity)
                  {
                     CurrentPlayedFighterManager.getInstance().resetPlayerSpellList();
                  }
                  this._playingSlaveEntity = false;
               }
               this._turnFrame.turnDuration = _loc4_.waitTime;
               this._currentPlayerId = _loc4_.id;
               if(!(param1 is GameFightTurnResumeMessage))
               {
                  BuffManager.getInstance().decrementDuration(_loc4_.id);
               }
               if(_loc4_.id > 0 || Boolean(_loc6_))
               {
                  if(FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc4_.id).disposition.cellId != -1 && !FightEntitiesHolder.getInstance().getEntity(_loc4_.id))
                  {
                     _loc19_ = DofusEntities.getEntity(_loc4_.id) as AnimatedCharacter;
                     if(_loc19_ != null)
                     {
                        _loc20_ = new SerialSequencer();
                        _loc20_.addStep(new AddGfxEntityStep(154,_loc19_.position.cellId));
                        _loc20_.start();
                        _loc21_ = 65 * _loc19_.look.getScaleY();
                        _loc22_ = new SerialSequencer();
                        _loc22_.addStep(new AddGfxEntityStep(153,_loc19_.position.cellId,0,-_loc21_));
                        _loc22_.start();
                     }
                     this._playerNewTurn = _loc19_;
                  }
               }
               _loc7_ = new SoundApi();
               _loc8_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc4_.id) as GameFightFighterInformations;
               if(_loc4_.id == _loc5_ && _loc8_ && _loc8_.alive || this._playingSlaveEntity)
               {
                  CurrentPlayedFighterManager.getInstance().currentFighterId = _loc4_.id;
                  if(_loc7_.playSoundAtTurnStart())
                  {
                     SoundManager.getInstance().manager.playUISound(UISoundEnum.PLAYER_TURN);
                  }
                  SpellWrapper.refreshAllPlayerSpellHolder(_loc4_.id);
                  this._turnFrame.myTurn = true;
               }
               else
               {
                  this._turnFrame.myTurn = false;
               }
               KernelEventsManager.getInstance().processCallback(HookList.GameFightTurnStart,_loc4_.id,_loc4_.waitTime,Dofus.getInstance().options.turnPicture);
               if(this._skipTurnTimer)
               {
                  this._skipTurnTimer.stop();
                  this._skipTurnTimer.removeEventListener(TimerEvent.TIMER,this.onSkipTurnTimeOut);
                  this._skipTurnTimer = null;
               }
               if(_loc4_.id == _loc5_ || this._playingSlaveEntity)
               {
                  if(AFKFightManager.getInstance().isAfk)
                  {
                     _loc23_ = getTimer();
                     if(AFKFightManager.getInstance().lastTurnSkip + 5 * 1000 < _loc23_)
                     {
                        _loc24_ = new GameFightTurnFinishAction();
                        Kernel.getWorker().process(_loc24_);
                     }
                     else
                     {
                        this._skipTurnTimer = new Timer(5 * 1000 - (_loc23_ - AFKFightManager.getInstance().lastTurnSkip),1);
                        this._skipTurnTimer.addEventListener(TimerEvent.TIMER,this.onSkipTurnTimeOut);
                        this._skipTurnTimer.start();
                     }
                  }
                  else
                  {
                     _loc25_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
                     _loc26_ = 0;
                     for each(_loc27_ in _loc25_.getEntitiesDictionnary())
                     {
                        if(_loc27_ is GameFightCharacterInformations && GameFightCharacterInformations(_loc27_).alive && _loc27_.contextualId > 0)
                        {
                           _loc26_++;
                        }
                     }
                     if(_loc26_ > 1)
                     {
                        AFKFightManager.getInstance().initialize();
                     }
                  }
               }
               return true;
            case param1 is GameFightTurnEndMessage:
               _loc9_ = param1 as GameFightTurnEndMessage;
               this._lastPlayerId = _loc9_.id;
               _loc10_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc9_.id);
               if(_loc10_ is GameFightFighterInformations && !(_loc10_ as GameFightFighterInformations).alive)
               {
                  _loc28_ = _loc10_ as GameFightFighterInformations;
                  BuffManager.getInstance().decrementDuration(_loc9_.id);
                  BuffManager.getInstance().markFinishingBuffs(this._lastPlayerId);
                  _loc28_.stats.actionPoints = _loc28_.stats.maxActionPoints;
                  _loc28_.stats.movementPoints = _loc28_.stats.maxMovementPoints;
                  KernelEventsManager.getInstance().processCallback(HookList.GameFightTurnEnd,this._lastPlayerId);
                  if(_loc9_.id == CurrentPlayedFighterManager.getInstance().currentFighterId)
                  {
                     CurrentPlayedFighterManager.getInstance().getSpellCastManager().nextTurn();
                     SpellWrapper.refreshAllPlayerSpellHolder(_loc9_.id);
                  }
               }
               if(_loc9_.id == CurrentPlayedFighterManager.getInstance().currentFighterId)
               {
                  AFKFightManager.getInstance().lastTurnSkip = getTimer();
                  AFKFightManager.getInstance().confirm = true;
                  this._turnFrame.myTurn = false;
               }
               return true;
            case param1 is SequenceStartMessage:
               _loc11_ = param1 as SequenceStartMessage;
               if(!this._sequenceFrameSwitcher)
               {
                  this._sequenceFrameSwitcher = new FightSequenceSwitcherFrame();
                  Kernel.getWorker().addFrame(this._sequenceFrameSwitcher);
               }
               this._currentSequenceFrame = new FightSequenceFrame(this,this._currentSequenceFrame);
               this._sequenceFrameSwitcher.currentFrame = this._currentSequenceFrame;
               return true;
            case param1 is SequenceEndMessage:
               _loc12_ = param1 as SequenceEndMessage;
               if(!this._currentSequenceFrame)
               {
                  _log.warn("Wow wow wow, I\'ve got a Sequence End but no Sequence Start? What the hell?");
                  return true;
               }
               this._currentSequenceFrame.mustAck = _loc12_.authorId == CurrentPlayedFighterManager.getInstance().currentFighterId;
               this._currentSequenceFrame.ackIdent = _loc12_.actionId;
               this._sequenceFrameSwitcher.currentFrame = null;
               if(!this._currentSequenceFrame.parent)
               {
                  Kernel.getWorker().removeFrame(this._sequenceFrameSwitcher);
                  this._sequenceFrameSwitcher = null;
                  this._sequenceFrames.push(this._currentSequenceFrame);
                  this._currentSequenceFrame = null;
                  this.executeNextSequence();
               }
               else
               {
                  this._currentSequenceFrame.execute();
                  this._sequenceFrameSwitcher.currentFrame = this._currentSequenceFrame.parent;
                  this._currentSequenceFrame = this._currentSequenceFrame.parent;
               }
               return true;
               break;
            case param1 is GameFightTurnReadyRequestMessage:
               if(this._executingSequence)
               {
                  _log.debug("Delaying turn end acknowledgement because we\'re still in a sequence.");
                  this._confirmTurnEnd = true;
               }
               else
               {
                  this.confirmTurnEnd();
               }
               return true;
            case param1 is GameFightNewRoundMessage:
               _loc13_ = param1 as GameFightNewRoundMessage;
               this._turnsCount = _loc13_.roundNumber;
               CurrentPlayedFighterManager.getInstance().getSpellCastManager().currentTurn = this._turnsCount - 1;
               KernelEventsManager.getInstance().processCallback(FightHookList.TurnCountUpdated,this._turnsCount);
               return true;
            case param1 is GameFightLeaveMessage:
               _loc14_ = param1 as GameFightLeaveMessage;
               _loc15_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(this._lastPlayerId) as GameFightFighterInformations;
               _loc16_ = new FightSequenceFrame(this);
               if(Boolean(_loc15_) && _loc15_.alive)
               {
                  _loc29_ = new GameActionFightLeaveMessage();
                  _loc16_.process(_loc29_.initGameActionFightLeaveMessage(0,0,_loc14_.charId));
                  this._sequenceFrames.push(_loc16_);
                  this.executeNextSequence();
               }
               if(_loc14_.charId == PlayedCharacterManager.getInstance().infos.id && PlayedCharacterManager.getInstance().isSpectator)
               {
                  if(this._executingSequence)
                  {
                     this._leaveSpectator = true;
                  }
                  PlayedCharacterManager.getInstance().resetSummonedCreature();
                  PlayedCharacterManager.getInstance().resetSummonedBomb();
                  KernelEventsManager.getInstance().processCallback(HookList.GameFightLeave,_loc14_.charId);
               }
               return true;
            case param1 is GameFightEndMessage:
               _loc17_ = param1 as GameFightEndMessage;
               _loc18_ = 5;
               while(Boolean(this._currentSequenceFrame) && Boolean(--_loc18_))
               {
                  _log.error("/!\\ Fight end but no SequenceEnd was received");
                  _loc30_ = new SequenceEndMessage();
                  _loc30_.initSequenceEndMessage();
                  this.process(_loc30_);
               }
               if(this._executingSequence)
               {
                  _log.debug("Delaying fight end because we\'re still in a sequence.");
                  this._endBattle = true;
                  this._battleResults = _loc17_;
               }
               else
               {
                  this.endBattle(_loc17_);
               }
               PlayedCharacterManager.getInstance().resetSummonedCreature();
               PlayedCharacterManager.getInstance().resetSummonedBomb();
               FightersStateManager.getInstance().endFight();
               CurrentPlayedFighterManager.getInstance().endFight();
               return true;
            case param1 is GameContextDestroyMessage:
               if(this._battleResults)
               {
                  _log.debug("Fin de combat propre (resultat connu)");
                  this.endBattle(this._battleResults);
               }
               else
               {
                  _log.debug("Fin de combat brutale (pas de resultat connu)");
                  this._executingSequence = false;
                  _loc31_ = new GameFightEndMessage();
                  _loc31_.initGameFightEndMessage(0,0,0,null);
                  this.process(_loc31_);
               }
               return true;
            case param1 is DisableAfkAction:
               AFKFightManager.getInstance().confirm = false;
               AFKFightManager.getInstance().enabled = false;
               return true;
            case param1 is ShowAllNamesAction:
               if(Kernel.getWorker().contains(InfoEntitiesFrame))
               {
                  Kernel.getWorker().removeFrame(this._infoEntitiesFrame);
               }
               else
               {
                  Kernel.getWorker().addFrame(this._infoEntitiesFrame);
               }
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         var _loc1_:FightSequenceFrame = null;
         DataMapProvider.getInstance().isInFight = false;
         TweenMax.killAllTweens(false);
         if(Kernel.getWorker().contains(FightTurnFrame))
         {
            Kernel.getWorker().removeFrame(this._turnFrame);
         }
         BuffManager.getInstance().destroy();
         MarkedCellsManager.getInstance().destroy();
         if(this._executingSequence || Kernel.getWorker().contains(FightSequenceFrame))
         {
            _log.warn("Wow, wait. We\'re pulling FightBattle but there\'s still sequences inside the worker !!");
            _loc1_ = Kernel.getWorker().getFrame(FightSequenceFrame) as FightSequenceFrame;
            Kernel.getWorker().removeFrame(_loc1_);
         }
         SerialSequencer.clearByType(FIGHT_SEQUENCER_NAME);
         SerialSequencer.clearByType(FightSequenceFrame.FIGHT_SEQUENCERS_CATEGORY);
         AFKFightManager.getInstance().enabled = false;
         this._currentSequenceFrame = null;
         this._sequenceFrameSwitcher = null;
         this._turnFrame = null;
         this._battleResults = null;
         this._newTurnsList = null;
         this._newDeadTurnsList = null;
         this._turnsList = null;
         this._deadTurnsList = null;
         this._sequenceFrames = null;
         if(this._playerNewTurn)
         {
            this._playerNewTurn.destroy();
         }
         if(this._skipTurnTimer)
         {
            this._skipTurnTimer.reset();
            this._skipTurnTimer.removeEventListener(TimerEvent.TIMER,this.onSkipTurnTimeOut);
            this._skipTurnTimer = null;
         }
         this._destroyed = true;
         return true;
      }
      
      public function delayCharacterStatsList(param1:CharacterStatsListMessage) : void
      {
         this._delayCslmsg = param1;
      }
      
      private function executeNextSequence() : Boolean
      {
         if(this._executingSequence)
         {
            return false;
         }
         var _loc1_:FightSequenceFrame = this._sequenceFrames.shift();
         if(_loc1_)
         {
            this._executingSequence = true;
            _loc1_.execute(this.finishSequence(_loc1_));
            return true;
         }
         return false;
      }
      
      private function finishSequence(param1:FightSequenceFrame) : Function
      {
         var sequenceFrame:FightSequenceFrame = param1;
         return function():void
         {
            var ack:* = undefined;
            var characterFrame:* = undefined;
            if(_destroyed)
            {
               return;
            }
            if(sequenceFrame.mustAck)
            {
               ack = new GameActionAcknowledgementMessage();
               ack.initGameActionAcknowledgementMessage(true,sequenceFrame.ackIdent);
               try
               {
                  ConnectionsHandler.getConnection().send(ack);
               }
               catch(e:Error)
               {
                  return;
               }
            }
            FightEventsHelper.sendAllFightEvent(true);
            _log.debug("Sequence finished.");
            _executingSequence = false;
            if(_refreshTurnsList)
            {
               _log.debug("There was a turns list refresh delayed, what about updating it now?");
               _refreshTurnsList = false;
               updateTurnsList(_newTurnsList,_newDeadTurnsList);
               _newTurnsList = null;
               _newDeadTurnsList = null;
            }
            if(!_executingSequence && _sequenceFrames.length && _sequenceFrames[0].instanceId >= _synchroniseFightersInstanceId)
            {
               gameFightSynchronize(_synchroniseFighters,false);
               _synchroniseFighters = null;
            }
            if(executeNextSequence())
            {
               return;
            }
            if(_synchroniseFighters)
            {
               gameFightSynchronize(_synchroniseFighters);
               _synchroniseFighters = null;
            }
            if(_delayCslmsg)
            {
               characterFrame = Kernel.getWorker().getFrame(PlayedCharacterUpdatesFrame) as PlayedCharacterUpdatesFrame;
               if(characterFrame)
               {
                  characterFrame.updateCharacterStatsList(_delayCslmsg);
               }
               _delayCslmsg = null;
            }
            if(_endBattle)
            {
               _log.debug("This fight must end ! Finishing things now.");
               _endBattle = false;
               endBattle(_battleResults);
               _battleResults = null;
               return;
            }
            if(_confirmTurnEnd)
            {
               _log.debug("There was a turn end delayed, dispatching now.");
               _confirmTurnEnd = false;
               confirmTurnEnd();
            }
         };
      }
      
      private function updateTurnsList(param1:Vector.<int>, param2:Vector.<int>) : void
      {
         this._turnsList = param1;
         this._deadTurnsList = param2;
         KernelEventsManager.getInstance().processCallback(HookList.FightersListUpdated);
         if(Boolean(Dofus.getInstance().options.orderFighters) && Boolean(Kernel.getWorker().getFrame(FightEntitiesFrame)))
         {
            (Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame).updateAllEntitiesNumber(param1);
         }
      }
      
      private function confirmTurnEnd() : void
      {
         var _loc3_:CharacterCharacteristicsInformations = null;
         var _loc1_:GameFightFighterInformations = FightEntitiesFrame.getCurrentInstance().getEntityInfos(this._lastPlayerId) as GameFightFighterInformations;
         if(_loc1_)
         {
            BuffManager.getInstance().markFinishingBuffs(this._lastPlayerId);
            KernelEventsManager.getInstance().processCallback(HookList.GameFightTurnEnd,this._lastPlayerId);
            if(this._lastPlayerId == CurrentPlayedFighterManager.getInstance().currentFighterId)
            {
               _loc3_ = CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations();
               _loc3_.actionPointsCurrent = _loc1_.stats.maxActionPoints;
               _loc3_.movementPointsCurrent = _loc1_.stats.maxMovementPoints;
               KernelEventsManager.getInstance().processCallback(HookList.CharacterStatsList);
               CurrentPlayedFighterManager.getInstance().getSpellCastManager().nextTurn();
               SpellWrapper.refreshAllPlayerSpellHolder(this._lastPlayerId);
            }
            _loc1_.stats.actionPoints = _loc1_.stats.maxActionPoints;
            _loc1_.stats.movementPoints = _loc1_.stats.maxMovementPoints;
            KernelEventsManager.getInstance().processCallback(HookList.GameFightTurnEnd,this._lastPlayerId);
         }
         var _loc2_:GameFightTurnReadyMessage = new GameFightTurnReadyMessage();
         _loc2_.initGameFightTurnReadyMessage(true);
         ConnectionsHandler.getConnection().send(_loc2_);
      }
      
      private function endBattle(param1:GameFightEndMessage) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:FightContextFrame = null;
         var _loc2_:FightEntitiesHolder = FightEntitiesHolder.getInstance();
         var _loc3_:Dictionary = _loc2_.getEntities();
         for each(_loc4_ in _loc3_)
         {
            (_loc4_ as AnimatedCharacter).display();
         }
         _loc2_.reset();
         this._synchroniseFighters = null;
         Kernel.getWorker().removeFrame(this);
         _loc5_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         _loc5_.process(param1);
      }
      
      private function onSkipTurnTimeOut(param1:TimerEvent) : void
      {
         var _loc2_:Action = null;
         this._skipTurnTimer.removeEventListener(TimerEvent.TIMER,this.onSkipTurnTimeOut);
         this._skipTurnTimer = null;
         if(AFKFightManager.getInstance().isAfk)
         {
            _loc2_ = new GameFightTurnFinishAction();
            Kernel.getWorker().process(_loc2_);
         }
      }
      
      private function gameFightSynchronize(param1:Vector.<GameFightFighterInformations>, param2:Boolean = true) : void
      {
         var _loc6_:GameFightFighterInformations = null;
         var _loc3_:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         var _loc4_:FightBattleFrame = Kernel.getWorker().getFrame(FightBattleFrame) as FightBattleFrame;
         var _loc5_:BuffManager = BuffManager.getInstance();
         if(param2)
         {
            BuffManager.getInstance().synchronize();
         }
         for each(_loc6_ in param1)
         {
            if(_loc6_.alive)
            {
               if(_loc4_)
               {
                  BuffManager.getInstance().markFinishingBuffs(_loc6_.contextualId,true);
               }
               _loc3_.updateFighter(_loc6_,null,BuffManager.getInstance().getFinishingBuffs(_loc6_.contextualId));
            }
         }
      }
   }
}

import com.ankamagames.atouin.Atouin;
import com.ankamagames.atouin.AtouinConstants;
import com.ankamagames.dofus.types.entities.AnimatedCharacter;
import flash.geom.ColorTransform;
import gs.TweenMax;

class PlayerColorTransformManager
{
   private var _offSetValue:Number;
   
   private var _alphaValue:Number;
   
   private var _player:AnimatedCharacter;
   
   public function PlayerColorTransformManager(param1:AnimatedCharacter)
   {
      super();
      this._player = param1;
      this._alphaValue = param1.alpha;
      this.offSetValue = 0;
   }
   
   public function set offSetValue(param1:Number) : void
   {
      this._offSetValue = param1;
      if(Atouin.getInstance().options.transparentOverlayMode)
      {
         this._player.transform.colorTransform = new ColorTransform(1,1,1,this._alphaValue != 1 ? Number(this._alphaValue) : AtouinConstants.OVERLAY_MODE_ALPHA,param1,param1,param1,0);
      }
      else
      {
         this._player.transform.colorTransform = new ColorTransform(1,1,1,this._alphaValue,param1,param1,param1,0);
      }
   }
   
   public function get offSetValue() : Number
   {
      return this._offSetValue;
   }
   
   public function enlightPlayer() : void
   {
      TweenMax.to(this,0.7,{
         "offSetValue":50,
         "yoyo":1
      });
   }
}
