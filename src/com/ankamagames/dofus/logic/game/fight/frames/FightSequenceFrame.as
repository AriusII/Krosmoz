package com.ankamagames.dofus.logic.game.fight.frames
{
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.types.sequences.AddWorldEntityStep;
   import com.ankamagames.atouin.types.sequences.ParableGfxMovementStep;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.managers.MapMovementAdapter;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.SpeakingItemManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.common.misc.ISpellCastProvider;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.fight.messages.GameActionFightLeaveMessage;
   import com.ankamagames.dofus.logic.game.fight.miscs.ActionIdConverter;
   import com.ankamagames.dofus.logic.game.fight.steps.FightActionPointsLossDodgeStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightActionPointsVariationStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightCarryCharacterStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightChangeLookStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightChangeVisibilityStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightCloseCombatStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightDeathStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightDispellEffectStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightDispellSpellStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightDispellStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightDisplayBuffStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightEnteringStateStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightEntityMovementStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightEntitySlideStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightExchangePositionsStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightFighterStatsUpdateStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightInvisibleObstacleStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightInvisibleTemporarilyDetectedStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightKillStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightLeavingStateStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightLifeVariationStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightLossAnimStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightMarkCellsStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightMarkTriggeredStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightModifyEffectsDurationStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightMovementPointsLossDodgeStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightMovementPointsVariationStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightReducedDamagesStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightReflectedDamagesStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightReflectedSpellStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightShieldPointsVariationStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightSpellCastStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightSpellCooldownVariationStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightSpellImmunityStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightStealingKamasStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightSummonStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightTackledStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightTeleportStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightTemporaryBoostStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightThrowCharacterStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightUnmarkCellsStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightVanishStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightVisibilityStep;
   import com.ankamagames.dofus.logic.game.fight.steps.IFightStep;
   import com.ankamagames.dofus.logic.game.fight.types.BasicBuff;
   import com.ankamagames.dofus.logic.game.fight.types.CastingSpell;
   import com.ankamagames.dofus.logic.game.fight.types.StateBuff;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.misc.lists.TriggerHookList;
   import com.ankamagames.dofus.network.enums.FightSpellCastCriticalEnum;
   import com.ankamagames.dofus.network.messages.game.actions.AbstractGameActionMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightCarryCharacterMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightChangeLookMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightCloseCombatMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDeathMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDispellEffectMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDispellMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDispellSpellMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDispellableEffectMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDodgePointLossMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDropCharacterMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightExchangePositionsMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightInvisibilityMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightInvisibleDetectedMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightInvisibleObstacleMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightKillMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightLifeAndShieldPointsLostMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightLifePointsGainMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightLifePointsLostMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightMarkCellsMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightModifyEffectsDurationMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightPointsVariationMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightReduceDamagesMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightReflectDamagesMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightReflectSpellMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightSlideMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightSpellCastMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightSpellCooldownVariationMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightSpellImmunityMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightStealKamaMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightSummonMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightTackledMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightTeleportOnSameMapMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightThrowCharacterMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightTriggerEffectMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightTriggerGlyphTrapMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightUnmarkCellsMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightVanishMessage;
   import com.ankamagames.dofus.network.messages.game.actions.sequence.SequenceEndMessage;
   import com.ankamagames.dofus.network.messages.game.actions.sequence.SequenceStartMessage;
   import com.ankamagames.dofus.network.messages.game.character.stats.FighterStatsListMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameMapMovementMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.character.GameFightShowFighterMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.character.GameFightShowFighterRandomStaticPoseMessage;
   import com.ankamagames.dofus.network.types.game.actions.fight.AbstractFightDispellableEffect;
   import com.ankamagames.dofus.network.types.game.actions.fight.FightTemporaryBoostEffect;
   import com.ankamagames.dofus.network.types.game.actions.fight.GameActionMarkedCell;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.dofus.scripts.DofusEmbedScript;
   import com.ankamagames.dofus.scripts.SpellFxRunner;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.dofus.types.sequences.AddGfxEntityStep;
   import com.ankamagames.dofus.types.sequences.AddGfxInLineStep;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.script.BinaryScript;
   import com.ankamagames.jerakine.script.ScriptExec;
   import com.ankamagames.jerakine.sequencer.CallbackStep;
   import com.ankamagames.jerakine.sequencer.ISequencable;
   import com.ankamagames.jerakine.sequencer.ISequencer;
   import com.ankamagames.jerakine.sequencer.ParallelStartSequenceStep;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.types.events.SequencerEvent;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.positions.MovementPath;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import com.ankamagames.tiphon.sequence.WaitAnimationEventStep;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class FightSequenceFrame implements Frame, ISpellCastProvider
   {
      private static var _lastCastingSpell:CastingSpell;
      
      private static var _currentInstanceId:uint;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FightSequenceFrame));
      
      public static const FIGHT_SEQUENCERS_CATEGORY:String = "FightSequencer";
      
      private var _fxScriptId:uint;
      
      private var _scriptStarted:uint;
      
      private var _castingSpell:CastingSpell;
      
      private var _stepsBuffer:Vector.<ISequencable>;
      
      public var mustAck:Boolean;
      
      public var ackIdent:int;
      
      private var _sequenceEndCallback:Function;
      
      private var _subSequenceWaitingCount:uint = 0;
      
      private var _scriptInit:Boolean;
      
      private var _sequencer:SerialSequencer;
      
      private var _parent:FightSequenceFrame;
      
      private var _fightBattleFrame:FightBattleFrame;
      
      private var _fightEntitiesFrame:FightEntitiesFrame;
      
      private var _instanceId:uint;
      
      public function FightSequenceFrame(param1:FightBattleFrame, param2:FightSequenceFrame = null)
      {
         super();
         this._instanceId = _currentInstanceId++;
         this._fightBattleFrame = param1;
         this._parent = param2;
         this.clearBuffer();
      }
      
      public static function get lastCastingSpell() : CastingSpell
      {
         return _lastCastingSpell;
      }
      
      public static function get currentInstanceId() : uint
      {
         return _currentInstanceId;
      }
      
      private static function deleteTooltip(param1:int) : void
      {
         var _loc2_:FightContextFrame = null;
         if(FightContextFrame.fighterEntityTooltipId == param1 && FightContextFrame.fighterEntityTooltipId != FightContextFrame.timelineOverEntityId)
         {
            _loc2_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
            if(_loc2_)
            {
               _loc2_.outEntity(param1);
            }
         }
      }
      
      public function get priority() : int
      {
         return Priority.HIGHEST;
      }
      
      public function get castingSpell() : CastingSpell
      {
         return this._castingSpell;
      }
      
      public function get stepsBuffer() : Vector.<ISequencable>
      {
         return this._stepsBuffer;
      }
      
      public function get parent() : FightSequenceFrame
      {
         return this._parent;
      }
      
      public function get isWaiting() : Boolean
      {
         return this._subSequenceWaitingCount != 0 || !this._scriptInit;
      }
      
      public function get instanceId() : uint
      {
         return this._instanceId;
      }
      
      public function pushed() : Boolean
      {
         this._scriptInit = false;
         return true;
      }
      
      public function pulled() : Boolean
      {
         this._stepsBuffer = null;
         this._castingSpell = null;
         _lastCastingSpell = null;
         this._sequenceEndCallback = null;
         this._parent = null;
         this._fightBattleFrame = null;
         this._fightEntitiesFrame = null;
         this._sequencer.clear();
         return true;
      }
      
      public function get fightEntitiesFrame() : FightEntitiesFrame
      {
         if(!this._fightEntitiesFrame)
         {
            this._fightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         }
         return this._fightEntitiesFrame;
      }
      
      public function addSubSequence(param1:ISequencer) : void
      {
         ++this._subSequenceWaitingCount;
         this._stepsBuffer.push(new ParallelStartSequenceStep([param1],false));
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:GameActionFightSpellCastMessage = null;
         var _loc3_:Boolean = false;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:* = false;
         var _loc7_:Dictionary = null;
         var _loc8_:GameFightFighterInformations = null;
         var _loc9_:PlayedCharacterManager = null;
         var _loc10_:Boolean = false;
         var _loc11_:GameMapMovementMessage = null;
         var _loc12_:FighterStatsListMessage = null;
         var _loc13_:GameActionFightPointsVariationMessage = null;
         var _loc14_:GameActionFightLifeAndShieldPointsLostMessage = null;
         var _loc15_:GameActionFightLifePointsGainMessage = null;
         var _loc16_:GameActionFightLifePointsLostMessage = null;
         var _loc17_:GameActionFightTeleportOnSameMapMessage = null;
         var _loc18_:GameActionFightExchangePositionsMessage = null;
         var _loc19_:GameActionFightSlideMessage = null;
         var _loc20_:GameActionFightSummonMessage = null;
         var _loc21_:GameActionFightMarkCellsMessage = null;
         var _loc22_:GameActionFightUnmarkCellsMessage = null;
         var _loc23_:GameActionFightChangeLookMessage = null;
         var _loc24_:GameActionFightInvisibilityMessage = null;
         var _loc25_:GameContextActorInformations = null;
         var _loc26_:GameActionFightLeaveMessage = null;
         var _loc27_:Dictionary = null;
         var _loc28_:GameContextActorInformations = null;
         var _loc29_:GameActionFightDeathMessage = null;
         var _loc30_:Dictionary = null;
         var _loc31_:int = 0;
         var _loc32_:GameFightFighterInformations = null;
         var _loc33_:GameFightFighterInformations = null;
         var _loc34_:GameFightFighterInformations = null;
         var _loc35_:GameContextActorInformations = null;
         var _loc36_:FightContextFrame = null;
         var _loc37_:GameActionFightVanishMessage = null;
         var _loc38_:GameContextActorInformations = null;
         var _loc39_:FightContextFrame = null;
         var _loc40_:GameActionFightDispellEffectMessage = null;
         var _loc41_:GameActionFightDispellSpellMessage = null;
         var _loc42_:GameActionFightDispellMessage = null;
         var _loc43_:GameActionFightDodgePointLossMessage = null;
         var _loc44_:GameActionFightSpellCooldownVariationMessage = null;
         var _loc45_:GameActionFightSpellImmunityMessage = null;
         var _loc46_:GameActionFightInvisibleObstacleMessage = null;
         var _loc47_:GameActionFightKillMessage = null;
         var _loc48_:GameActionFightReduceDamagesMessage = null;
         var _loc49_:GameActionFightReflectDamagesMessage = null;
         var _loc50_:GameActionFightReflectSpellMessage = null;
         var _loc51_:GameActionFightStealKamaMessage = null;
         var _loc52_:GameActionFightTackledMessage = null;
         var _loc53_:GameActionFightTriggerGlyphTrapMessage = null;
         var _loc54_:int = 0;
         var _loc55_:GameActionFightDispellableEffectMessage = null;
         var _loc56_:CastingSpell = null;
         var _loc57_:AbstractFightDispellableEffect = null;
         var _loc58_:BasicBuff = null;
         var _loc59_:GameActionFightModifyEffectsDurationMessage = null;
         var _loc60_:GameActionFightCarryCharacterMessage = null;
         var _loc61_:GameActionFightThrowCharacterMessage = null;
         var _loc62_:GameActionFightDropCharacterMessage = null;
         var _loc63_:GameActionFightInvisibleDetectedMessage = null;
         var _loc64_:GameActionFightCloseCombatMessage = null;
         var _loc65_:Array = null;
         var _loc66_:Boolean = false;
         var _loc67_:SpellLevel = null;
         var _loc68_:SpellWrapper = null;
         var _loc69_:Spell = null;
         var _loc70_:SpellLevel = null;
         var _loc71_:int = 0;
         var _loc72_:GameFightShowFighterRandomStaticPoseMessage = null;
         var _loc73_:Sprite = null;
         var _loc74_:GameFightShowFighterMessage = null;
         var _loc75_:Sprite = null;
         var _loc76_:Boolean = false;
         var _loc77_:Boolean = false;
         var _loc78_:GameContextActorInformations = null;
         var _loc79_:GameFightMonsterInformations = null;
         var _loc80_:Monster = null;
         var _loc81_:GameFightCharacterInformations = null;
         var _loc82_:GameContextActorInformations = null;
         var _loc83_:int = 0;
         var _loc84_:GameFightMonsterInformations = null;
         var _loc85_:Monster = null;
         var _loc86_:GameContextActorInformations = null;
         var _loc87_:int = 0;
         var _loc88_:GameFightMonsterInformations = null;
         var _loc89_:GameFightFighterInformations = null;
         var _loc90_:StateBuff = null;
         var _loc91_:Object = null;
         var _loc92_:int = 0;
         switch(true)
         {
            case param1 is GameActionFightCloseCombatMessage:
            case param1 is GameActionFightSpellCastMessage:
               if(param1 is GameActionFightSpellCastMessage)
               {
                  _loc2_ = param1 as GameActionFightSpellCastMessage;
               }
               else
               {
                  _loc64_ = param1 as GameActionFightCloseCombatMessage;
                  _loc3_ = true;
                  _loc4_ = _loc64_.weaponGenericId;
                  _loc2_ = new GameActionFightSpellCastMessage();
                  _loc2_.initGameActionFightSpellCastMessage(_loc64_.actionId,_loc64_.sourceId,_loc64_.targetId,_loc64_.destinationCellId,_loc64_.critical,_loc64_.silentCast,0,1);
               }
               _loc5_ = this.fightEntitiesFrame.getEntityInfos(_loc2_.sourceId).disposition.cellId;
               if(this._castingSpell)
               {
                  if(_loc3_ && _loc4_ != 0)
                  {
                     this.pushCloseCombatStep(_loc2_.sourceId,_loc4_,_loc2_.critical);
                  }
                  else
                  {
                     this.pushSpellCastStep(_loc2_.sourceId,_loc2_.destinationCellId,_loc5_,_loc2_.spellId,_loc2_.spellLevel,_loc2_.critical);
                  }
                  _log.error("Il ne peut y avoir qu\'un seul cast de sort par séquence (" + param1 + ")");
                  break;
               }
               this._castingSpell = new CastingSpell();
               this._castingSpell.casterId = _loc2_.sourceId;
               this._castingSpell.spell = Spell.getSpellById(_loc2_.spellId);
               this._castingSpell.spellRank = this._castingSpell.spell.getSpellLevel(_loc2_.spellLevel);
               this._castingSpell.isCriticalFail = _loc2_.critical == FightSpellCastCriticalEnum.CRITICAL_FAIL;
               this._castingSpell.isCriticalHit = _loc2_.critical == FightSpellCastCriticalEnum.CRITICAL_HIT;
               this._castingSpell.silentCast = _loc2_.silentCast;
               if(_loc2_.destinationCellId != -1)
               {
                  this._castingSpell.targetedCell = MapPoint.fromCellId(_loc2_.destinationCellId);
               }
               if(this._castingSpell.isCriticalFail)
               {
                  this._fxScriptId = 0;
               }
               else
               {
                  this._fxScriptId = this._castingSpell.spell.getScriptId(this._castingSpell.isCriticalHit);
               }
               if(param1 is GameActionFightCloseCombatMessage)
               {
                  this._fxScriptId = 7;
                  this._castingSpell.weaponId = GameActionFightCloseCombatMessage(param1).weaponGenericId;
               }
               if(_loc2_.sourceId == CurrentPlayedFighterManager.getInstance().currentFighterId && _loc2_.critical != FightSpellCastCriticalEnum.CRITICAL_FAIL)
               {
                  _loc65_ = new Array();
                  _loc65_.push(_loc2_.targetId);
                  CurrentPlayedFighterManager.getInstance().getSpellCastManager().castSpell(_loc2_.spellId,_loc2_.spellLevel,_loc65_);
               }
               _loc6_ = _loc2_.critical == FightSpellCastCriticalEnum.CRITICAL_HIT;
               _loc7_ = FightEntitiesFrame.getCurrentInstance().getEntitiesDictionnary();
               _loc8_ = _loc7_[_loc2_.sourceId];
               if(_loc3_ && _loc4_ != 0)
               {
                  this.pushCloseCombatStep(_loc2_.sourceId,_loc4_,_loc2_.critical);
               }
               else
               {
                  this.pushSpellCastStep(_loc2_.sourceId,_loc2_.destinationCellId,_loc5_,_loc2_.spellId,_loc2_.spellLevel,_loc2_.critical);
               }
               if(_loc2_.sourceId == CurrentPlayedFighterManager.getInstance().currentFighterId)
               {
                  KernelEventsManager.getInstance().processCallback(TriggerHookList.FightSpellCast);
               }
               _loc9_ = PlayedCharacterManager.getInstance();
               _loc10_ = false;
               if(_loc7_[_loc9_.id] && _loc8_ && (_loc7_[_loc9_.id] as GameFightFighterInformations).teamId == _loc8_.teamId)
               {
                  _loc10_ = true;
               }
               if(_loc2_.sourceId != _loc9_.id && _loc10_ && !this._castingSpell.isCriticalFail)
               {
                  _loc66_ = false;
                  for each(_loc68_ in _loc9_.spellsInventory)
                  {
                     if(_loc68_.id == _loc2_.spellId)
                     {
                        _loc66_ = true;
                        _loc67_ = _loc68_.spellLevelInfos;
                        break;
                     }
                  }
                  if(_loc66_)
                  {
                     _loc69_ = Spell.getSpellById(_loc2_.spellId);
                     _loc70_ = _loc69_.getSpellLevel(_loc2_.spellLevel);
                     if(_loc70_.globalCooldown)
                     {
                        if(_loc70_.globalCooldown == -1)
                        {
                           _loc71_ = int(_loc67_.minCastInterval);
                        }
                        else
                        {
                           _loc71_ = _loc70_.globalCooldown;
                        }
                        this.pushSpellCooldownVariationStep(_loc9_.id,0,_loc2_.spellId,_loc71_);
                     }
                  }
               }
               _loc31_ = int(PlayedCharacterManager.getInstance().infos.id);
               _loc32_ = this.fightEntitiesFrame.getEntityInfos(_loc2_.sourceId) as GameFightFighterInformations;
               _loc34_ = this.fightEntitiesFrame.getEntityInfos(_loc31_) as GameFightFighterInformations;
               if(_loc6_)
               {
                  if(_loc2_.sourceId == _loc31_)
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_CC_OWNER);
                  }
                  else if(Boolean(_loc34_) && _loc32_.teamId == _loc34_.teamId)
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_CC_ALLIED);
                  }
                  else
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_CC_ENEMY);
                  }
               }
               else if(_loc2_.critical == FightSpellCastCriticalEnum.CRITICAL_FAIL)
               {
                  if(_loc2_.sourceId == _loc31_)
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_EC_OWNER);
                  }
                  else if(Boolean(_loc34_) && _loc32_.teamId == _loc34_.teamId)
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_EC_ALLIED);
                  }
                  else
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_EC_ENEMY);
                  }
               }
               return true;
               break;
            case param1 is GameMapMovementMessage:
               _loc11_ = param1 as GameMapMovementMessage;
               if(_loc11_.actorId == CurrentPlayedFighterManager.getInstance().currentFighterId)
               {
                  KernelEventsManager.getInstance().processCallback(TriggerHookList.PlayerFightMove);
               }
               this.pushMovementStep(_loc11_.actorId,MapMovementAdapter.getClientMovement(_loc11_.keyMovements));
               return true;
            case param1 is FighterStatsListMessage:
               _loc12_ = param1 as FighterStatsListMessage;
               this.pushUpdateFighterStatsStep(_loc12_.stats);
               return true;
            case param1 is GameActionFightPointsVariationMessage:
               _loc13_ = param1 as GameActionFightPointsVariationMessage;
               this.pushPointsVariationStep(_loc13_.targetId,_loc13_.actionId,_loc13_.delta);
               return false;
            case param1 is GameActionFightLifeAndShieldPointsLostMessage:
               _loc14_ = param1 as GameActionFightLifeAndShieldPointsLostMessage;
               this.pushShieldPointsVariationStep(_loc14_.targetId,-_loc14_.shieldLoss,_loc14_.actionId);
               this.pushLifePointsVariationStep(_loc14_.targetId,-_loc14_.loss,-_loc14_.permanentDamages,_loc14_.actionId);
               return true;
            case param1 is GameActionFightLifePointsGainMessage:
               _loc15_ = param1 as GameActionFightLifePointsGainMessage;
               this.pushLifePointsVariationStep(_loc15_.targetId,_loc15_.delta,0,_loc15_.actionId);
               return true;
            case param1 is GameActionFightLifePointsLostMessage:
               _loc16_ = param1 as GameActionFightLifePointsLostMessage;
               this.pushLifePointsVariationStep(_loc16_.targetId,-_loc16_.loss,-_loc16_.permanentDamages,_loc16_.actionId);
               return true;
            case param1 is GameActionFightTeleportOnSameMapMessage:
               _loc17_ = param1 as GameActionFightTeleportOnSameMapMessage;
               this.pushTeleportStep(_loc17_.targetId,_loc17_.cellId);
               return true;
            case param1 is GameActionFightExchangePositionsMessage:
               _loc18_ = param1 as GameActionFightExchangePositionsMessage;
               this.pushExchangePositionsStep(_loc18_.sourceId,_loc18_.casterCellId,_loc18_.targetId,_loc18_.targetCellId);
               return true;
            case param1 is GameActionFightSlideMessage:
               _loc19_ = param1 as GameActionFightSlideMessage;
               this.pushSlideStep(_loc19_.targetId,_loc19_.startCellId,_loc19_.endCellId);
               return true;
            case param1 is GameActionFightSummonMessage:
               _loc20_ = param1 as GameActionFightSummonMessage;
               if(_loc20_.actionId == 1024 || _loc20_.actionId == 1097)
               {
                  _loc72_ = new GameFightShowFighterRandomStaticPoseMessage();
                  _loc72_.initGameFightShowFighterRandomStaticPoseMessage(_loc20_.summon);
                  Kernel.getWorker().getFrame(FightEntitiesFrame).process(_loc72_);
                  _loc73_ = DofusEntities.getEntity(_loc20_.summon.contextualId) as Sprite;
                  _loc73_.visible = false;
                  this.pushVisibilityStep(_loc20_.summon.contextualId,true);
               }
               else
               {
                  _loc74_ = new GameFightShowFighterMessage();
                  _loc74_.initGameFightShowFighterMessage(_loc20_.summon);
                  Kernel.getWorker().getFrame(FightEntitiesFrame).process(_loc74_);
                  _loc75_ = DofusEntities.getEntity(_loc20_.summon.contextualId) as Sprite;
                  _loc75_.visible = false;
                  this.pushSummonStep(_loc20_.sourceId,_loc20_.summon);
                  if(_loc20_.sourceId == PlayedCharacterManager.getInstance().id && _loc20_.actionId != 185)
                  {
                     _loc76_ = false;
                     _loc77_ = false;
                     if(_loc20_.actionId == 1008)
                     {
                        _loc76_ = true;
                     }
                     else
                     {
                        _loc78_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc20_.summon.contextualId);
                        _loc76_ = false;
                        _loc79_ = _loc78_ as GameFightMonsterInformations;
                        if(_loc79_)
                        {
                           _loc80_ = Monster.getMonsterById(_loc79_.creatureGenericId);
                           if((Boolean(_loc80_)) && _loc80_.useBombSlot)
                           {
                              _loc76_ = true;
                           }
                           if(Boolean(_loc80_) && _loc80_.useSummonSlot)
                           {
                              _loc77_ = true;
                           }
                        }
                        else
                        {
                           _loc81_ = _loc78_ as GameFightCharacterInformations;
                        }
                     }
                     if(_loc77_ || Boolean(_loc81_))
                     {
                        PlayedCharacterManager.getInstance().addSummonedCreature();
                     }
                     else if(_loc76_)
                     {
                        PlayedCharacterManager.getInstance().addSummonedBomb();
                     }
                  }
               }
               return true;
            case param1 is GameActionFightMarkCellsMessage:
               _loc21_ = param1 as GameActionFightMarkCellsMessage;
               if(this._castingSpell)
               {
                  this._castingSpell.markId = _loc21_.mark.markId;
                  this._castingSpell.markType = _loc21_.mark.markType;
                  this.pushMarkCellsStep(_loc21_.mark.markId,_loc21_.mark.markType,_loc21_.mark.cells,_loc21_.mark.markSpellId);
               }
               return true;
            case param1 is GameActionFightUnmarkCellsMessage:
               _loc22_ = param1 as GameActionFightUnmarkCellsMessage;
               this.pushUnmarkCellsStep(_loc22_.markId);
               return true;
            case param1 is GameActionFightChangeLookMessage:
               _loc23_ = param1 as GameActionFightChangeLookMessage;
               this.pushChangeLookStep(_loc23_.targetId,_loc23_.entityLook);
               return true;
            case param1 is GameActionFightInvisibilityMessage:
               _loc24_ = param1 as GameActionFightInvisibilityMessage;
               _loc25_ = this.fightEntitiesFrame.getEntityInfos(_loc24_.targetId);
               FightEntitiesFrame.getCurrentInstance().setLastKnownEntityPosition(_loc24_.targetId,_loc25_.disposition.cellId);
               FightEntitiesFrame.getCurrentInstance().setLastKnownEntityMovementPoint(_loc24_.targetId,0,true);
               this.pushChangeVisibilityStep(_loc24_.targetId,_loc24_.state);
               return true;
            case param1 is GameActionFightLeaveMessage:
               _loc26_ = param1 as GameActionFightLeaveMessage;
               _loc27_ = FightEntitiesFrame.getCurrentInstance().getEntitiesDictionnary();
               for each(_loc82_ in _loc27_)
               {
                  if(_loc82_ is GameFightFighterInformations)
                  {
                     _loc83_ = (_loc82_ as GameFightFighterInformations).stats.summoner;
                     if(_loc83_ == _loc26_.targetId)
                     {
                        this.pushDeathStep(_loc82_.contextualId);
                     }
                  }
               }
               this.pushDeathStep(_loc26_.targetId,false);
               _loc28_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc26_.targetId);
               if(_loc28_ is GameFightMonsterInformations)
               {
                  _loc84_ = _loc28_ as GameFightMonsterInformations;
                  if(_loc84_.stats.summoner == PlayedCharacterManager.getInstance().id)
                  {
                     _loc85_ = Monster.getMonsterById(_loc84_.creatureGenericId);
                     if(_loc85_.useSummonSlot)
                     {
                        PlayedCharacterManager.getInstance().removeSummonedCreature();
                     }
                     if(_loc85_.useBombSlot)
                     {
                        PlayedCharacterManager.getInstance().removeSummonedBomb();
                     }
                  }
               }
               return true;
            case param1 is GameActionFightDeathMessage:
               _loc29_ = param1 as GameActionFightDeathMessage;
               _log.fatal("GameActionFightDeathMessage");
               _loc30_ = FightEntitiesFrame.getCurrentInstance().getEntitiesDictionnary();
               for each(_loc86_ in _loc30_)
               {
                  if(_loc86_ is GameFightFighterInformations)
                  {
                     _loc87_ = (_loc86_ as GameFightFighterInformations).stats.summoner;
                     if(_loc87_ == _loc29_.targetId)
                     {
                        this.pushDeathStep(_loc86_.contextualId);
                     }
                  }
               }
               _loc31_ = int(PlayedCharacterManager.getInstance().infos.id);
               _loc32_ = this.fightEntitiesFrame.getEntityInfos(_loc29_.sourceId) as GameFightFighterInformations;
               _loc33_ = this.fightEntitiesFrame.getEntityInfos(_loc29_.targetId) as GameFightFighterInformations;
               _loc34_ = this.fightEntitiesFrame.getEntityInfos(_loc31_) as GameFightFighterInformations;
               if(_loc29_.targetId == _loc31_)
               {
                  if(_loc29_.sourceId == _loc29_.targetId)
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_KILLED_HIMSELF);
                  }
                  else if(_loc32_.teamId != _loc34_.teamId)
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_KILLED_BY_ENEMY);
                  }
                  else
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_KILLED_BY_ENEMY);
                  }
               }
               else if(_loc29_.sourceId == _loc31_)
               {
                  if(_loc33_.teamId != _loc34_.teamId)
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_KILL_ENEMY);
                  }
                  else
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_KILL_ALLY);
                  }
               }
               this.pushDeathStep(_loc29_.targetId);
               _loc35_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc29_.targetId);
               if(_loc35_ is GameFightMonsterInformations)
               {
                  _loc88_ = _loc35_ as GameFightMonsterInformations;
                  _loc88_.alive = false;
                  if(_loc88_.stats.summoner == PlayedCharacterManager.getInstance().id)
                  {
                     _loc85_ = Monster.getMonsterById(_loc88_.creatureGenericId);
                     if(_loc85_.useSummonSlot)
                     {
                        PlayedCharacterManager.getInstance().removeSummonedCreature();
                     }
                     if(_loc85_.useBombSlot)
                     {
                        PlayedCharacterManager.getInstance().removeSummonedBomb();
                     }
                     SpellWrapper.refreshAllPlayerSpellHolder(PlayedCharacterManager.getInstance().id);
                  }
               }
               else if(_loc35_ is GameFightFighterInformations)
               {
                  (_loc35_ as GameFightFighterInformations).alive = false;
                  if((_loc35_ as GameFightFighterInformations).stats.summoner != 0)
                  {
                     _loc89_ = _loc35_ as GameFightFighterInformations;
                     if(_loc89_.stats.summoner == PlayedCharacterManager.getInstance().id)
                     {
                        PlayedCharacterManager.getInstance().removeSummonedCreature();
                        SpellWrapper.refreshAllPlayerSpellHolder(PlayedCharacterManager.getInstance().id);
                     }
                  }
               }
               _loc36_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
               if(_loc36_)
               {
                  _loc36_.outEntity(_loc29_.targetId);
               }
               FightEntitiesFrame.getCurrentInstance().updateRemovedEntity(_loc29_.targetId);
               return true;
            case param1 is GameActionFightVanishMessage:
               _loc37_ = param1 as GameActionFightVanishMessage;
               this.pushVanishStep(_loc37_.targetId,_loc37_.sourceId);
               _loc38_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc37_.targetId);
               if(_loc38_ is GameFightFighterInformations)
               {
                  (_loc38_ as GameFightFighterInformations).alive = false;
               }
               _loc39_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
               if(_loc39_)
               {
                  _loc39_.outEntity(_loc37_.targetId);
               }
               FightEntitiesFrame.getCurrentInstance().updateRemovedEntity(_loc37_.targetId);
               return true;
            case param1 is GameActionFightTriggerEffectMessage:
               return true;
            case param1 is GameActionFightDispellEffectMessage:
               _loc40_ = param1 as GameActionFightDispellEffectMessage;
               this.pushDispellEffectStep(_loc40_.targetId,_loc40_.boostUID);
               return true;
            case param1 is GameActionFightDispellSpellMessage:
               _loc41_ = param1 as GameActionFightDispellSpellMessage;
               this.pushDispellSpellStep(_loc41_.targetId,_loc41_.spellId);
               return true;
            case param1 is GameActionFightDispellMessage:
               _loc42_ = param1 as GameActionFightDispellMessage;
               this.pushDispellStep(_loc42_.targetId);
               return true;
            case param1 is GameActionFightDodgePointLossMessage:
               _loc43_ = param1 as GameActionFightDodgePointLossMessage;
               this.pushPointsLossDodgeStep(_loc43_.targetId,_loc43_.actionId,_loc43_.amount);
               return true;
            case param1 is GameActionFightSpellCooldownVariationMessage:
               _loc44_ = param1 as GameActionFightSpellCooldownVariationMessage;
               this.pushSpellCooldownVariationStep(_loc44_.targetId,_loc44_.actionId,_loc44_.spellId,_loc44_.value);
               return true;
            case param1 is GameActionFightSpellImmunityMessage:
               _loc45_ = param1 as GameActionFightSpellImmunityMessage;
               this.pushSpellImmunityStep(_loc45_.targetId);
               return true;
            case param1 is GameActionFightInvisibleObstacleMessage:
               _loc46_ = param1 as GameActionFightInvisibleObstacleMessage;
               this.pushInvisibleObstacleStep(_loc46_.sourceId,_loc46_.sourceSpellId);
               return true;
            case param1 is GameActionFightKillMessage:
               _loc47_ = param1 as GameActionFightKillMessage;
               this.pushKillStep(_loc47_.targetId,_loc47_.sourceId);
               return true;
            case param1 is GameActionFightReduceDamagesMessage:
               _loc48_ = param1 as GameActionFightReduceDamagesMessage;
               this.pushReducedDamagesStep(_loc48_.targetId,_loc48_.amount);
               return true;
            case param1 is GameActionFightReflectDamagesMessage:
               _loc49_ = param1 as GameActionFightReflectDamagesMessage;
               this.pushReflectedDamagesStep(_loc49_.sourceId);
               return true;
            case param1 is GameActionFightReflectSpellMessage:
               _loc50_ = param1 as GameActionFightReflectSpellMessage;
               this.pushReflectedSpellStep(_loc50_.targetId);
               return true;
            case param1 is GameActionFightStealKamaMessage:
               _loc51_ = param1 as GameActionFightStealKamaMessage;
               this.pushStealKamasStep(_loc51_.sourceId,_loc51_.targetId,_loc51_.amount);
               return true;
            case param1 is GameActionFightTackledMessage:
               _loc52_ = param1 as GameActionFightTackledMessage;
               this.pushTackledStep(_loc52_.sourceId);
               return true;
            case param1 is GameActionFightTriggerGlyphTrapMessage:
               if(this._castingSpell)
               {
                  this._fightBattleFrame.process(new SequenceEndMessage());
                  this._fightBattleFrame.process(new SequenceStartMessage());
                  this._fightBattleFrame.currentSequenceFrame.process(param1);
                  return true;
               }
               _loc53_ = param1 as GameActionFightTriggerGlyphTrapMessage;
               this.pushMarkTriggeredStep(_loc53_.triggeringCharacterId,_loc53_.sourceId,_loc53_.markId);
               this._fxScriptId = 1;
               this._castingSpell = new CastingSpell();
               this._castingSpell.casterId = _loc53_.sourceId;
               _loc54_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc53_.triggeringCharacterId).disposition.cellId;
               if(_loc54_ != -1)
               {
                  this._castingSpell.targetedCell = MapPoint.fromCellId(_loc54_);
                  this._castingSpell.spell = Spell.getSpellById(1750);
                  this._castingSpell.spellRank = this._castingSpell.spell.getSpellLevel(1);
               }
               return true;
               break;
            case param1 is GameActionFightDispellableEffectMessage:
               _loc55_ = param1 as GameActionFightDispellableEffectMessage;
               if(_loc55_.actionId == ActionIdConverter.ACTION_CHARACTER_UPDATE_BOOST)
               {
                  _loc56_ = new CastingSpell(false);
               }
               else
               {
                  _loc56_ = new CastingSpell(this._castingSpell == null);
               }
               if(this._castingSpell)
               {
                  _loc56_.castingSpellId = this._castingSpell.castingSpellId;
                  if(this._castingSpell.spell.id == _loc55_.effect.spellId)
                  {
                     _loc56_.spellRank = this._castingSpell.spellRank;
                  }
               }
               _loc56_.spell = Spell.getSpellById(_loc55_.effect.spellId);
               _loc56_.casterId = _loc55_.sourceId;
               _loc57_ = _loc55_.effect;
               _loc58_ = BuffManager.makeBuffFromEffect(_loc57_,_loc56_,_loc55_.actionId);
               if(_loc58_ is StateBuff)
               {
                  _loc90_ = _loc58_ as StateBuff;
                  if(_loc90_.actionId == 952)
                  {
                     _loc91_ = new FightLeavingStateStep(_loc90_.targetId,_loc90_.stateId);
                  }
                  else
                  {
                     _loc91_ = new FightEnteringStateStep(_loc90_.targetId,_loc90_.stateId,_loc90_.effects.durationString);
                  }
                  if(_loc56_ != null)
                  {
                     _loc91_.castingSpellId = _loc56_.castingSpellId;
                  }
                  this._stepsBuffer.push(_loc91_);
               }
               switch(true)
               {
                  case _loc57_ is FightTemporaryBoostEffect:
                     _loc92_ = int(_loc55_.actionId);
                     if(_loc92_ != ActionIdConverter.ACTION_CHARACTER_MAKE_INVISIBLE && _loc92_ != ActionIdConverter.ACTION_CHARACTER_UPDATE_BOOST && _loc92_ != ActionIdConverter.ACTION_CHARACTER_CHANGE_LOOK && _loc92_ != ActionIdConverter.ACTION_CHARACTER_CHANGE_COLOR && _loc92_ != ActionIdConverter.ACTION_CHARACTER_ADD_APPEARANCE && _loc92_ != ActionIdConverter.ACTION_FIGHT_SET_STATE)
                     {
                        this.pushTemporaryBoostStep(_loc55_.effect.targetId,_loc58_.effects.description,_loc58_.effects.duration,_loc58_.effects.durationString);
                        break;
                     }
               }
               this.pushDisplayBuffStep(_loc58_);
               return true;
            case param1 is GameActionFightModifyEffectsDurationMessage:
               _loc59_ = param1 as GameActionFightModifyEffectsDurationMessage;
               this.pushModifyEffectsDurationStep(_loc59_.sourceId,_loc59_.targetId,_loc59_.delta);
               return false;
            case param1 is GameActionFightCarryCharacterMessage:
               _loc60_ = param1 as GameActionFightCarryCharacterMessage;
               if(_loc60_.cellId != -1)
               {
                  this.pushCarryCharacterStep(_loc60_.sourceId,_loc60_.targetId,_loc60_.cellId);
               }
               return false;
            case param1 is GameActionFightThrowCharacterMessage:
               _loc61_ = param1 as GameActionFightThrowCharacterMessage;
               this.pushThrowCharacterStep(_loc61_.sourceId,_loc61_.targetId,_loc61_.cellId);
               return false;
            case param1 is GameActionFightDropCharacterMessage:
               _loc62_ = param1 as GameActionFightDropCharacterMessage;
               this.pushThrowCharacterStep(_loc62_.sourceId,_loc62_.targetId,_loc62_.cellId);
               return false;
            case param1 is GameActionFightInvisibleDetectedMessage:
               _loc63_ = param1 as GameActionFightInvisibleDetectedMessage;
               this.pushFightInvisibleTemporarilyDetectedStep(_loc63_.sourceId,_loc63_.cellId);
               FightEntitiesFrame.getCurrentInstance().setLastKnownEntityPosition(_loc63_.targetId,_loc63_.cellId);
               FightEntitiesFrame.getCurrentInstance().setLastKnownEntityMovementPoint(_loc63_.targetId,0);
               return true;
            case param1 is AbstractGameActionMessage:
               _log.error("Unsupported game action " + param1 + " ! This action was discarded.");
               return true;
         }
         return false;
      }
      
      public function execute(param1:Function = null) : void
      {
         var _loc2_:BinaryScript = null;
         var _loc3_:SpellFxRunner = null;
         this._sequencer = new SerialSequencer(FIGHT_SEQUENCERS_CATEGORY);
         if(this._parent)
         {
            _log.info("Process sub sequence");
            this._parent.addSubSequence(this._sequencer);
         }
         else
         {
            _log.info("Execute sequence");
         }
         if(this._fxScriptId > 0)
         {
            _loc2_ = DofusEmbedScript.getScript(this._fxScriptId);
            _loc3_ = new SpellFxRunner(this);
            this._scriptStarted = getTimer();
            ScriptExec.exec(_loc2_,_loc3_,true,new Callback(this.executeBuffer,param1,true,true),new Callback(this.executeBuffer,param1,true,false));
         }
         else
         {
            this.executeBuffer(param1,false);
         }
      }
      
      private function executeBuffer(param1:Function, param2:Boolean, param3:Boolean = false) : void
      {
         var _loc8_:ISequencable = null;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:Array = null;
         var _loc13_:Array = null;
         var _loc14_:Boolean = false;
         var _loc15_:Dictionary = null;
         var _loc16_:Dictionary = null;
         var _loc17_:Dictionary = null;
         var _loc18_:Dictionary = null;
         var _loc19_:Dictionary = null;
         var _loc20_:int = 0;
         var _loc21_:* = undefined;
         var _loc22_:* = undefined;
         var _loc23_:WaitAnimationEventStep = null;
         var _loc24_:uint = 0;
         var _loc25_:PlayAnimationStep = null;
         var _loc26_:FightDeathStep = null;
         var _loc27_:FightActionPointsVariationStep = null;
         var _loc28_:FightShieldPointsVariationStep = null;
         var _loc29_:FightLifeVariationStep = null;
         var _loc30_:int = 0;
         var _loc31_:int = 0;
         var _loc32_:* = undefined;
         var _loc33_:uint = 0;
         if(param2)
         {
            _loc24_ = uint(getTimer() - this._scriptStarted);
            if(!param3)
            {
               _log.warn("Script failed during a fight sequence, but still took " + _loc24_ + "ms.");
            }
            else
            {
               _log.info("Script successfuly executed in " + _loc24_ + "ms.");
            }
         }
         var _loc4_:Array = [];
         var _loc5_:Dictionary = new Dictionary(true);
         var _loc6_:Dictionary = new Dictionary(true);
         var _loc7_:Dictionary = new Dictionary(true);
         var _loc9_:Boolean = false;
         for each(_loc8_ in this._stepsBuffer)
         {
            switch(true)
            {
               case _loc8_ is FightMarkTriggeredStep:
                  _loc9_ = true;
                  break;
            }
         }
         _loc10_ = Boolean(OptionManager.getOptionManager("dofus")["allowHitAnim"]);
         _loc11_ = Boolean(OptionManager.getOptionManager("dofus")["allowSpellEffects"]);
         _loc12_ = [];
         _loc13_ = [];
         _loc15_ = new Dictionary();
         _loc16_ = new Dictionary(true);
         _loc17_ = new Dictionary(true);
         _loc18_ = new Dictionary(true);
         _loc19_ = new Dictionary(true);
         _loc20_ = int(this._stepsBuffer.length);
         while(--_loc20_ >= 0)
         {
            if(_loc14_ && Boolean(_loc8_))
            {
               _loc8_.clear();
            }
            _loc14_ = true;
            _loc8_ = this._stepsBuffer[_loc20_];
            switch(true)
            {
               case _loc8_ is PlayAnimationStep:
                  _loc25_ = _loc8_ as PlayAnimationStep;
                  if(_loc25_.animation.indexOf(AnimationEnum.ANIM_HIT) != -1)
                  {
                     if(!_loc10_)
                     {
                        continue;
                     }
                     _loc25_.waitEvent = _loc9_;
                     if(_loc25_.target == null)
                     {
                        continue;
                     }
                     if(_loc5_[EntitiesManager.getInstance().getEntityID(_loc25_.target as IEntity)])
                     {
                        continue;
                     }
                     if(_loc6_[_loc25_.target])
                     {
                        continue;
                     }
                     _loc6_[_loc25_.target] = true;
                  }
                  if(this._castingSpell.casterId < 0)
                  {
                     if(_loc15_[_loc25_.target])
                     {
                        _loc4_.unshift(_loc15_[_loc25_.target]);
                        delete _loc15_[_loc25_.target];
                     }
                     if(_loc25_.animation.indexOf(AnimationEnum.ANIM_ATTAQUE_BASE) != -1)
                     {
                        _loc15_[_loc25_.target] = new WaitAnimationEventStep(_loc25_);
                     }
                  }
                  break;
               case _loc8_ is FightDeathStep:
                  _loc26_ = _loc8_ as FightDeathStep;
                  _loc5_[_loc26_.entityId] = true;
                  break;
               case _loc8_ is FightActionPointsVariationStep:
                  _loc27_ = _loc8_ as FightActionPointsVariationStep;
                  if(!_loc27_.voluntarlyUsed)
                  {
                     break;
                  }
                  _loc12_.push(_loc27_);
                  _loc14_ = false;
                  continue;
               case _loc8_ is FightShieldPointsVariationStep:
                  _loc28_ = _loc8_ as FightShieldPointsVariationStep;
                  if(_loc18_[_loc28_.target] == null)
                  {
                     _loc18_[_loc28_.target] = 0;
                  }
                  _loc18_[_loc28_.target] += _loc28_.value;
                  _loc19_[_loc28_.target] = _loc28_;
                  break;
               case _loc8_ is FightLifeVariationStep:
                  _loc29_ = _loc8_ as FightLifeVariationStep;
                  if(_loc29_.delta < 0)
                  {
                     _loc7_[_loc29_.target] = _loc29_;
                  }
                  if(_loc16_[_loc29_.target] == null)
                  {
                     _loc16_[_loc29_.target] = 0;
                  }
                  _loc16_[_loc29_.target] += _loc29_.delta;
                  _loc17_[_loc29_.target] = _loc29_;
                  break;
               case _loc8_ is AddGfxEntityStep:
               case _loc8_ is AddGfxInLineStep:
               case _loc8_ is ParableGfxMovementStep:
               case _loc8_ is AddWorldEntityStep:
                  if(_loc11_)
                  {
                     break;
                  }
                  continue;
            }
            _loc14_ = false;
            _loc4_.unshift(_loc8_);
         }
         for each(_loc21_ in _loc4_)
         {
            if(_loc21_ is FightLifeVariationStep && _loc16_[_loc21_.target] == 0 && _loc18_[_loc21_.target] != null)
            {
               _loc21_.skipTextEvent = true;
            }
         }
         for(_loc22_ in _loc16_)
         {
            if(_loc22_ != "null" && _loc16_[_loc22_] != 0)
            {
               _loc30_ = int(_loc4_.indexOf(_loc17_[_loc22_]));
               _loc4_.splice(_loc30_,0,new FightLossAnimStep(_loc22_,_loc16_[_loc22_],FightLifeVariationStep.COLOR));
            }
            _loc17_[_loc22_] = -1;
            _loc16_[_loc22_] = 0;
         }
         for(_loc22_ in _loc18_)
         {
            if(_loc22_ != "null" && _loc18_[_loc22_] != 0)
            {
               _loc31_ = int(_loc4_.indexOf(_loc19_[_loc22_]));
               _loc4_.splice(_loc31_,0,new FightLossAnimStep(_loc22_,_loc18_[_loc22_],FightShieldPointsVariationStep.COLOR));
            }
            _loc19_[_loc22_] = -1;
            _loc18_[_loc22_] = 0;
         }
         for each(_loc23_ in _loc15_)
         {
            _loc13_.push(_loc23_);
         }
         if(_loc10_)
         {
            for(_loc32_ in _loc7_)
            {
               if(!_loc6_[_loc32_])
               {
                  _loc33_ = 0;
                  while(_loc33_ < _loc4_.length)
                  {
                     if(_loc4_[_loc33_] == _loc7_[_loc32_])
                     {
                        _loc4_.splice(_loc33_,0,new PlayAnimationStep(_loc32_ as TiphonSprite,AnimationEnum.ANIM_HIT,true,false));
                        break;
                     }
                     _loc33_++;
                  }
               }
            }
         }
         _loc4_ = _loc12_.concat(_loc4_).concat(_loc13_);
         for each(_loc8_ in _loc4_)
         {
            this._sequencer.addStep(_loc8_);
         }
         this.clearBuffer();
         if(param1 != null && !this._parent)
         {
            this._sequenceEndCallback = param1;
            this._sequencer.addEventListener(SequencerEvent.SEQUENCE_END,this.onSequenceEnd);
         }
         _lastCastingSpell = this._castingSpell;
         this._scriptInit = true;
         if(!this._parent)
         {
            if(!this._subSequenceWaitingCount)
            {
               this._sequencer.start();
            }
            else
            {
               _log.warn("Waiting sub sequence init end (" + this._subSequenceWaitingCount + " seq)");
            }
         }
         else
         {
            if(param1 != null)
            {
               param1();
            }
            this._parent.subSequenceInitDone();
         }
      }
      
      private function onSequenceEnd(param1:SequencerEvent) : void
      {
         this._sequencer.removeEventListener(SequencerEvent.SEQUENCE_END,this.onSequenceEnd);
         this._sequenceEndCallback();
      }
      
      private function subSequenceInitDone() : void
      {
         --this._subSequenceWaitingCount;
         if(!this.isWaiting && this._sequencer && !this._sequencer.running)
         {
            _log.warn("Sub sequence init end -- Run main sequence");
            this._sequencer.start();
         }
      }
      
      private function pushMovementStep(param1:int, param2:MovementPath) : void
      {
         this._stepsBuffer.push(new CallbackStep(new Callback(deleteTooltip,param1)));
         var _loc3_:FightEntityMovementStep = new FightEntityMovementStep(param1,param2);
         if(this.castingSpell != null)
         {
            _loc3_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc3_);
      }
      
      private function pushTeleportStep(param1:int, param2:int) : void
      {
         var _loc3_:FightTeleportStep = null;
         this._stepsBuffer.push(new CallbackStep(new Callback(deleteTooltip,param1)));
         if(param2 != -1)
         {
            _loc3_ = new FightTeleportStep(param1,MapPoint.fromCellId(param2));
            if(this.castingSpell != null)
            {
               _loc3_.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc3_);
         }
      }
      
      private function pushExchangePositionsStep(param1:int, param2:int, param3:int, param4:int) : void
      {
         this._stepsBuffer.push(new CallbackStep(new Callback(deleteTooltip,param1)));
         this._stepsBuffer.push(new CallbackStep(new Callback(deleteTooltip,param3)));
         var _loc5_:FightExchangePositionsStep = new FightExchangePositionsStep(param1,param2,param3,param4);
         if(this.castingSpell != null)
         {
            _loc5_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc5_);
      }
      
      private function pushSlideStep(param1:int, param2:int, param3:int) : void
      {
         if(param2 < 0 || param3 < 0)
         {
            return;
         }
         this._stepsBuffer.push(new CallbackStep(new Callback(deleteTooltip,param1)));
         var _loc4_:FightEntitySlideStep = new FightEntitySlideStep(param1,MapPoint.fromCellId(param2),MapPoint.fromCellId(param3));
         if(this.castingSpell != null)
         {
            _loc4_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc4_);
      }
      
      private function pushSummonStep(param1:int, param2:GameFightFighterInformations) : void
      {
         var _loc3_:FightSummonStep = new FightSummonStep(param1,param2);
         if(this.castingSpell != null)
         {
            _loc3_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc3_);
      }
      
      private function pushVisibilityStep(param1:int, param2:Boolean) : void
      {
         var _loc3_:FightVisibilityStep = new FightVisibilityStep(param1,param2);
         if(this.castingSpell != null)
         {
            _loc3_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc3_);
      }
      
      private function pushMarkCellsStep(param1:int, param2:int, param3:Vector.<GameActionMarkedCell>, param4:int) : void
      {
         var _loc5_:FightMarkCellsStep = new FightMarkCellsStep(param1,param2,this._castingSpell.spellRank,param3,param4);
         if(this.castingSpell != null)
         {
            _loc5_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc5_);
      }
      
      private function pushUnmarkCellsStep(param1:int) : void
      {
         var _loc2_:FightUnmarkCellsStep = new FightUnmarkCellsStep(param1);
         if(this.castingSpell != null)
         {
            _loc2_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc2_);
      }
      
      private function pushChangeLookStep(param1:int, param2:EntityLook) : void
      {
         var _loc3_:FightChangeLookStep = new FightChangeLookStep(param1,EntityLookAdapter.fromNetwork(param2));
         if(this.castingSpell != null)
         {
            _loc3_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc3_);
      }
      
      private function pushChangeVisibilityStep(param1:int, param2:int) : void
      {
         var _loc3_:FightChangeVisibilityStep = new FightChangeVisibilityStep(param1,param2);
         if(this.castingSpell != null)
         {
            _loc3_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc3_);
      }
      
      private function pushPointsVariationStep(param1:int, param2:uint, param3:int) : void
      {
         var _loc4_:IFightStep = null;
         switch(param2)
         {
            case ActionIdConverter.ACTION_CHARACTER_ACTION_POINTS_USE:
               _loc4_ = new FightActionPointsVariationStep(param1,param3,true);
               break;
            case ActionIdConverter.ACTION_CHARACTER_ACTION_POINTS_LOST:
            case ActionIdConverter.ACTION_CHARACTER_ACTION_POINTS_WIN:
               _loc4_ = new FightActionPointsVariationStep(param1,param3,false);
               break;
            case ActionIdConverter.ACTION_CHARACTER_MOVEMENT_POINTS_USE:
               _loc4_ = new FightMovementPointsVariationStep(param1,param3,true);
               break;
            case ActionIdConverter.ACTION_CHARACTER_MOVEMENT_POINTS_LOST:
            case ActionIdConverter.ACTION_CHARACTER_MOVEMENT_POINTS_WIN:
               _loc4_ = new FightMovementPointsVariationStep(param1,param3,false);
               break;
            default:
               _log.warn("Points variation with unsupported action (" + param2 + "), skipping.");
               return;
         }
         if(this.castingSpell != null)
         {
            _loc4_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc4_);
      }
      
      private function pushUpdateFighterStatsStep(param1:CharacterCharacteristicsInformations) : void
      {
         var _loc2_:FightFighterStatsUpdateStep = new FightFighterStatsUpdateStep(param1);
         if(this.castingSpell != null)
         {
            _loc2_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc2_);
      }
      
      private function pushShieldPointsVariationStep(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:FightShieldPointsVariationStep = new FightShieldPointsVariationStep(param1,param2,param3);
         if(this.castingSpell != null)
         {
            _loc4_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc4_);
      }
      
      private function pushTemporaryBoostStep(param1:int, param2:String, param3:int, param4:String) : void
      {
         var _loc5_:FightTemporaryBoostStep = new FightTemporaryBoostStep(param1,param2,param3,param4);
         if(this.castingSpell != null)
         {
            _loc5_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc5_);
      }
      
      private function pushPointsLossDodgeStep(param1:int, param2:uint, param3:int) : void
      {
         var _loc4_:IFightStep = null;
         switch(param2)
         {
            case ActionIdConverter.ACTION_FIGHT_SPELL_DODGED_PA:
               _loc4_ = new FightActionPointsLossDodgeStep(param1,param3);
               break;
            case ActionIdConverter.ACTION_FIGHT_SPELL_DODGED_PM:
               _loc4_ = new FightMovementPointsLossDodgeStep(param1,param3);
               break;
            default:
               _log.warn("Points dodge with unsupported action (" + param2 + "), skipping.");
               return;
         }
         if(this.castingSpell != null)
         {
            _loc4_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc4_);
      }
      
      private function pushLifePointsVariationStep(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:FightLifeVariationStep = new FightLifeVariationStep(param1,param2,param3,param4);
         if(this.castingSpell != null)
         {
            _loc5_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc5_);
      }
      
      private function pushDeathStep(param1:int, param2:Boolean = true) : void
      {
         var _loc3_:FightDeathStep = new FightDeathStep(param1,param2);
         if(this.castingSpell != null)
         {
            _loc3_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc3_);
      }
      
      private function pushVanishStep(param1:int, param2:int) : void
      {
         var _loc3_:FightVanishStep = new FightVanishStep(param1,param2);
         if(this.castingSpell != null)
         {
            _loc3_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc3_);
      }
      
      private function pushDispellStep(param1:int) : void
      {
         var _loc2_:FightDispellStep = new FightDispellStep(param1);
         if(this.castingSpell != null)
         {
            _loc2_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc2_);
      }
      
      private function pushDispellEffectStep(param1:int, param2:int) : void
      {
         var _loc3_:FightDispellEffectStep = new FightDispellEffectStep(param1,param2);
         if(this.castingSpell != null)
         {
            _loc3_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc3_);
      }
      
      private function pushDispellSpellStep(param1:int, param2:int) : void
      {
         var _loc3_:FightDispellSpellStep = new FightDispellSpellStep(param1,param2);
         if(this.castingSpell != null)
         {
            _loc3_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc3_);
      }
      
      private function pushSpellCooldownVariationStep(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:FightSpellCooldownVariationStep = new FightSpellCooldownVariationStep(param1,param2,param3,param4);
         if(this.castingSpell != null)
         {
            _loc5_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc5_);
      }
      
      private function pushSpellImmunityStep(param1:int) : void
      {
         var _loc2_:FightSpellImmunityStep = new FightSpellImmunityStep(param1);
         if(this.castingSpell != null)
         {
            _loc2_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc2_);
      }
      
      private function pushInvisibleObstacleStep(param1:int, param2:int) : void
      {
         var _loc3_:FightInvisibleObstacleStep = new FightInvisibleObstacleStep(param1,param2);
         if(this.castingSpell != null)
         {
            _loc3_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc3_);
      }
      
      private function pushKillStep(param1:int, param2:int) : void
      {
         var _loc3_:FightKillStep = new FightKillStep(param1,param2);
         if(this.castingSpell != null)
         {
            _loc3_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc3_);
      }
      
      private function pushReducedDamagesStep(param1:int, param2:int) : void
      {
         var _loc3_:FightReducedDamagesStep = new FightReducedDamagesStep(param1,param2);
         if(this.castingSpell != null)
         {
            _loc3_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc3_);
      }
      
      private function pushReflectedDamagesStep(param1:int) : void
      {
         var _loc2_:FightReflectedDamagesStep = new FightReflectedDamagesStep(param1);
         if(this.castingSpell != null)
         {
            _loc2_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc2_);
      }
      
      private function pushReflectedSpellStep(param1:int) : void
      {
         var _loc2_:FightReflectedSpellStep = new FightReflectedSpellStep(param1);
         if(this.castingSpell != null)
         {
            _loc2_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc2_);
      }
      
      private function pushSpellCastStep(param1:int, param2:int, param3:int, param4:int, param5:uint, param6:uint) : void
      {
         var _loc7_:FightSpellCastStep = new FightSpellCastStep(param1,param2,param3,param4,param5,param6);
         if(this.castingSpell != null)
         {
            _loc7_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc7_);
      }
      
      private function pushCloseCombatStep(param1:int, param2:uint, param3:uint) : void
      {
         var _loc4_:FightCloseCombatStep = new FightCloseCombatStep(param1,param2,param3);
         if(this.castingSpell != null)
         {
            _loc4_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc4_);
      }
      
      private function pushStealKamasStep(param1:int, param2:int, param3:uint) : void
      {
         var _loc4_:FightStealingKamasStep = new FightStealingKamasStep(param1,param2,param3);
         if(this.castingSpell != null)
         {
            _loc4_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc4_);
      }
      
      private function pushTackledStep(param1:int) : void
      {
         var _loc2_:FightTackledStep = new FightTackledStep(param1);
         if(this.castingSpell != null)
         {
            _loc2_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc2_);
      }
      
      private function pushMarkTriggeredStep(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:FightMarkTriggeredStep = new FightMarkTriggeredStep(param1,param2,param3);
         if(this.castingSpell != null)
         {
            _loc4_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc4_);
      }
      
      private function pushDisplayBuffStep(param1:BasicBuff) : void
      {
         var _loc2_:FightDisplayBuffStep = new FightDisplayBuffStep(param1);
         if(this.castingSpell != null)
         {
            _loc2_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc2_);
      }
      
      private function pushModifyEffectsDurationStep(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:FightModifyEffectsDurationStep = new FightModifyEffectsDurationStep(param1,param2,param3);
         if(this.castingSpell != null)
         {
            _loc4_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc4_);
      }
      
      private function pushCarryCharacterStep(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:FightCarryCharacterStep = new FightCarryCharacterStep(param1,param2,param3);
         if(this.castingSpell != null)
         {
            _loc4_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc4_);
         this._stepsBuffer.push(new CallbackStep(new Callback(deleteTooltip,param2)));
      }
      
      private function pushThrowCharacterStep(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:FightThrowCharacterStep = new FightThrowCharacterStep(param1,param2,param3);
         if(this.castingSpell != null)
         {
            _loc4_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc4_);
      }
      
      private function pushFightInvisibleTemporarilyDetectedStep(param1:int, param2:uint) : void
      {
         var _loc3_:AnimatedCharacter = DofusEntities.getEntity(param1) as AnimatedCharacter;
         var _loc4_:FightInvisibleTemporarilyDetectedStep = new FightInvisibleTemporarilyDetectedStep(_loc3_,param2);
         if(this.castingSpell != null)
         {
            _loc4_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc4_);
      }
      
      private function clearBuffer() : void
      {
         this._stepsBuffer = new Vector.<ISequencable>(0,false);
      }
   }
}

