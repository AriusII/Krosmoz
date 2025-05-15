package com.ankamagames.dofus.logic.game.roleplay.managers
{
   import com.ankamagames.dofus.datacenter.monsters.AnimFunMonsterData;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.npcs.AnimFunNpcData;
   import com.ankamagames.dofus.datacenter.npcs.Npc;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.logic.game.roleplay.types.AnimFunTimer;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.jerakine.utils.prng.PRNG;
   import com.ankamagames.jerakine.utils.prng.ParkMillerCarta;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public final class AnimFunManager
   {
      private static var _self:AnimFunManager;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AnimFunManager));
      
      public static const ANIM_FUN_TIMER_MIN:int = 40000;
      
      public static const ANIM_FUN_TIMER_MAX:int = 80000;
      
      public static const FAST_ANIM_FUN_TIMER_MIN:int = 1000;
      
      public static const FAST_ANIM_FUN_TIMER_MAX:int = 5000;
      
      public static const ANIM_DELAY_SIZE:uint = 20;
      
      private var _animFunNpcData:AnimFunNpcData;
      
      private var _animFunMonsterData:AnimFunMonsterData;
      
      private var _timerList:Vector.<AnimFunTimer> = new Vector.<AnimFunTimer>();
      
      private var _animDelays:Array;
      
      private var _animDelaysSum:uint;
      
      private var _minDelay:int = 40000;
      
      private var _maxDelay:int = 80000;
      
      private var _mapId:int = -1;
      
      public function AnimFunManager()
      {
         super();
         if(_self)
         {
            throw new SingletonError();
         }
         this.fastDelay = false;
      }
      
      public static function getInstance() : AnimFunManager
      {
         if(!_self)
         {
            _self = new AnimFunManager();
         }
         return _self;
      }
      
      public function set fastDelay(param1:Boolean) : void
      {
         if(param1 != this.fastDelay)
         {
            if(param1)
            {
               this._minDelay = FAST_ANIM_FUN_TIMER_MIN;
               this._maxDelay = FAST_ANIM_FUN_TIMER_MAX;
            }
            else
            {
               this._minDelay = ANIM_FUN_TIMER_MAX;
               this._maxDelay = ANIM_FUN_TIMER_MAX;
            }
            if(this._mapId != -1)
            {
               this.initializeByMap(this._mapId);
            }
         }
      }
      
      public function get fastDelay() : Boolean
      {
         return this._minDelay == 1000;
      }
      
      public function initializeByMap(param1:uint) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _log.info("Initialize AnimFunManager for map " + param1);
         this._mapId = param1;
         var _loc2_:PRNG = new ParkMillerCarta();
         _loc2_.seed(param1 + 5435);
         this._animDelays = new Array();
         this._animDelaysSum = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < ANIM_DELAY_SIZE)
         {
            _loc4_ = _loc2_.nextIntR(this._minDelay,this._maxDelay);
            _loc5_ = _loc2_.nextInt();
            _loc6_ = _loc2_.nextInt();
            this._animDelays.push({
               "delay":_loc4_,
               "actor":_loc5_,
               "anim":_loc6_
            });
            this._animDelaysSum += _loc4_;
            _loc3_++;
         }
         this.stopAllTimer();
         this.initNextAnimFun();
      }
      
      public function get running() : Boolean
      {
         var _loc1_:AnimFunTimer = null;
         for each(_loc1_ in this._timerList)
         {
            if(_loc1_.running)
            {
               return true;
            }
         }
         return false;
      }
      
      public function restart() : void
      {
         if(!this.running)
         {
            this.initNextAnimFun();
         }
      }
      
      public function newAnimFunTimer(param1:int, param2:int, param3:int) : void
      {
         this._timerList.push(new AnimFunTimer(param1,param2,param3,this.onTimer));
      }
      
      public function stopAllTimer() : void
      {
         var _loc1_:int = int(this._timerList.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this._timerList[_loc2_].destroy();
            _loc2_++;
         }
         this._timerList = new Vector.<AnimFunTimer>();
      }
      
      private function onTimer(param1:AnimFunTimer) : void
      {
         var _loc2_:Object = null;
         var _loc4_:RoleplayEntitiesFrame = null;
         var _loc5_:TiphonSprite = null;
         var _loc6_:GameContextActorInformations = null;
         var _loc7_:SerialSequencer = null;
         var _loc8_:GameRolePlayGroupMonsterInformations = null;
         var _loc9_:Monster = null;
         var _loc10_:GameRolePlayNpcInformations = null;
         var _loc11_:Npc = null;
         _log.info("Timer reached, run animFun.");
         var _loc3_:int = int(this._timerList.indexOf(param1));
         if(_loc3_ != -1)
         {
            param1.destroy();
            this._timerList.splice(_loc3_,1);
         }
         if(this.getIsMapStatic())
         {
            _loc4_ = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
            if(!_loc4_)
            {
               return;
            }
            _loc5_ = DofusEntities.getEntity(param1.actorId) as TiphonSprite;
            if(!_loc5_)
            {
               return;
            }
            _loc6_ = _loc4_.getEntityInfos(param1.actorId);
            if(_loc6_ is GameRolePlayGroupMonsterInformations)
            {
               _loc8_ = _loc6_ as GameRolePlayGroupMonsterInformations;
               _loc9_ = Monster.getMonsterById(_loc8_.staticInfos.mainCreatureLightInfos.creatureGenericId);
               if(!_loc9_ || _loc9_.animFunList.length == 0)
               {
                  return;
               }
               _loc2_ = _loc9_.animFunList;
            }
            else
            {
               if(!(_loc6_ is GameRolePlayNpcInformations))
               {
                  return;
               }
               _loc10_ = _loc6_ as GameRolePlayNpcInformations;
               _loc11_ = Npc.getNpcById(_loc10_.npcId);
               if(!_loc11_)
               {
                  return;
               }
               _loc2_ = _loc11_.animFunList;
            }
            if(_loc4_.hasIcon(_loc6_.contextualId))
            {
               _loc4_.forceIconUpdate(_loc6_.contextualId);
            }
            _loc7_ = new SerialSequencer();
            _loc7_.addStep(new PlayAnimationStep(_loc5_,_loc2_[param1.animId].animName));
            _loc7_.start();
         }
         this.initNextAnimFun();
      }
      
      private function initNextAnimFun() : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this._animDelaysSum == 0)
         {
            _log.error("try to init a new animFun with a 0 delay sum");
            return;
         }
         var _loc1_:Number = TimeManager.getInstance().getTimestamp();
         _loc1_ %= this._animDelaysSum;
         for each(_loc2_ in this._animDelays)
         {
            if(_loc1_ <= _loc2_.delay)
            {
               _loc3_ = this.randomActor(_loc2_.actor);
               _loc4_ = this.randomAnim(_loc3_,_loc2_.anim);
               if(_loc3_ != 0)
               {
                  _log.info("waiting " + (_loc2_.delay - _loc1_) + " until next anim fun");
                  this.newAnimFunTimer(_loc3_,_loc2_.delay - _loc1_,_loc4_);
               }
               return;
            }
            _loc1_ -= _loc2_.delay;
         }
      }
      
      private function randomActor(param1:int) : int
      {
         var _loc5_:GameContextActorInformations = null;
         var _loc6_:Monster = null;
         var _loc7_:Npc = null;
         var _loc8_:int = 0;
         var _loc2_:RoleplayEntitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
         var _loc3_:Dictionary = _loc2_.getEntitiesDictionnary();
         var _loc4_:Array = new Array();
         for each(_loc5_ in _loc3_)
         {
            if(_loc5_ is GameRolePlayGroupMonsterInformations)
            {
               _loc6_ = Monster.getMonsterById((_loc5_ as GameRolePlayGroupMonsterInformations).staticInfos.mainCreatureLightInfos.creatureGenericId);
               if((Boolean(_loc6_)) && _loc6_.animFunList.length != 0)
               {
                  _loc4_.push(_loc5_);
               }
            }
            else if(_loc5_ is GameRolePlayNpcInformations)
            {
               _loc7_ = Npc.getNpcById((_loc5_ as GameRolePlayNpcInformations).npcId);
               if((Boolean(_loc7_)) && _loc7_.animFunList.length != 0)
               {
                  _loc4_.push(_loc5_);
               }
            }
         }
         if(_loc4_.length)
         {
            _loc8_ = param1 % _loc4_.length;
            return _loc4_[_loc8_].contextualId;
         }
         return 0;
      }
      
      private function randomAnim(param1:int, param2:int) : int
      {
         var _loc3_:Object = null;
         var _loc11_:GameRolePlayGroupMonsterInformations = null;
         var _loc12_:Monster = null;
         var _loc13_:GameRolePlayNpcInformations = null;
         var _loc14_:Npc = null;
         var _loc4_:RoleplayEntitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
         if(!_loc4_)
         {
            return 0;
         }
         var _loc5_:GameContextActorInformations = _loc4_.getEntityInfos(param1);
         if(_loc5_ is GameRolePlayGroupMonsterInformations)
         {
            _loc11_ = _loc5_ as GameRolePlayGroupMonsterInformations;
            _loc12_ = Monster.getMonsterById(_loc11_.staticInfos.mainCreatureLightInfos.creatureGenericId);
            if(!_loc12_)
            {
               return 0;
            }
            _loc3_ = _loc12_.animFunList;
         }
         else
         {
            if(!(_loc5_ is GameRolePlayNpcInformations))
            {
               return 0;
            }
            _loc13_ = _loc5_ as GameRolePlayNpcInformations;
            _loc14_ = Npc.getNpcById(_loc13_.npcId);
            if(!_loc14_)
            {
               return 0;
            }
            _loc3_ = _loc14_.animFunList;
         }
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = int(_loc3_.length);
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_)
         {
            _loc7_ += _loc3_[_loc9_].animWeight;
            _loc9_++;
         }
         var _loc10_:Number = param2 % _loc7_;
         _loc7_ = 0;
         _loc9_ = 0;
         while(_loc9_ < _loc8_)
         {
            _loc7_ += _loc3_[_loc9_].animWeight;
            if(_loc7_ > _loc10_)
            {
               return _loc9_;
            }
            _loc9_++;
         }
         return 0;
      }
      
      private function getIsMapStatic() : Boolean
      {
         var _loc4_:GameContextActorInformations = null;
         var _loc5_:AnimatedCharacter = null;
         var _loc1_:RoleplayEntitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
         var _loc2_:Dictionary = _loc1_.getEntitiesDictionnary();
         var _loc3_:Array = new Array();
         for each(_loc4_ in _loc2_)
         {
            _loc5_ = DofusEntities.getEntity(_loc4_.contextualId) as AnimatedCharacter;
            if((Boolean(_loc5_)) && _loc5_.isMoving)
            {
               return false;
            }
         }
         return true;
      }
   }
}

