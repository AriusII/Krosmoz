package com.ankamagames.berilia.managers
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.types.data.Hook;
   import com.ankamagames.berilia.types.data.OldMessage;
   import com.ankamagames.berilia.types.event.HookLogEvent;
   import com.ankamagames.berilia.types.event.UiRenderEvent;
   import com.ankamagames.berilia.types.listener.GenericListener;
   import com.ankamagames.jerakine.logger.ModuleLogger;
   import com.ankamagames.jerakine.managers.ErrorManager;
   import com.ankamagames.jerakine.utils.benchmark.monitoring.FpsManager;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class KernelEventsManager extends GenericEventsManager
   {
      private static var _self:KernelEventsManager;
      
      private var _aLoadingUi:Array;
      
      private var _asyncErrorTimer:Timer;
      
      private var _asyncError:Vector.<Error>;
      
      private var _debugMode:Boolean = false;
      
      public function KernelEventsManager()
      {
         super();
         if(_self != null)
         {
            throw new SingletonError("KernelEventsManager is a singleton and should not be instanciated directly.");
         }
         this._aLoadingUi = new Array();
         Berilia.getInstance().addEventListener(UiRenderEvent.UIRenderComplete,this.processOldMessage);
         Berilia.getInstance().addEventListener(UiRenderEvent.UIRenderFailed,this.processOldMessage);
         this._asyncError = new Vector.<Error>();
         this._asyncErrorTimer = new Timer(1,1);
         this._asyncErrorTimer.addEventListener(TimerEvent.TIMER,this.throwAsyncError);
      }
      
      public static function getInstance() : KernelEventsManager
      {
         if(_self == null)
         {
            _self = new KernelEventsManager();
         }
         return _self;
      }
      
      public function disableAsyncError() : void
      {
         this._debugMode = true;
      }
      
      public function isRegisteredEvent(param1:String) : Boolean
      {
         return _aEvent[param1] != null;
      }
      
      public function processCallback(param1:Hook, ... rest) : void
      {
         var _loc6_:String = null;
         var _loc7_:GenericListener = null;
         FpsManager.getInstance().startTracking("hook",7108545);
         if(!UiModuleManager.getInstance().ready)
         {
            _log.warn("Hook " + param1.name + " discarded");
            return;
         }
         var _loc3_:Array = SecureCenter.secureContent(rest);
         var _loc4_:int = 0;
         var _loc5_:Array = Berilia.getInstance().loadingUi;
         for(_loc6_ in _loc5_)
         {
            _loc4_++;
            if(Berilia.getInstance().loadingUi[_loc6_])
            {
               if(this._aLoadingUi[_loc6_] == null)
               {
                  this._aLoadingUi[_loc6_] = new Array();
               }
               this._aLoadingUi[_loc6_].push(new OldMessage(param1,_loc3_));
            }
         }
         _log.logDirectly(new HookLogEvent(param1.name,[]));
         if(!_aEvent[param1.name])
         {
            return;
         }
         ModuleLogger.log(param1,rest);
         var _loc8_:Array = [];
         for each(_loc7_ in _aEvent[param1.name])
         {
            _loc8_.push(_loc7_);
         }
         for each(_loc7_ in _loc8_)
         {
            if(_loc7_)
            {
               if(_loc7_.listenerType == GenericListener.LISTENER_TYPE_UI && !Berilia.getInstance().getUi(_loc7_.listener))
               {
                  _log.info("L\'UI " + _loc7_.listener + " n\'existe plus pour recevoir le hook " + _loc7_.event);
               }
               else
               {
                  ErrorManager.tryFunction(_loc7_.getCallback(),_loc3_,"Une erreur est survenue lors du traitement du hook " + param1.name);
               }
            }
         }
         FpsManager.getInstance().stopTracking("hook");
      }
      
      private function processOldMessage(param1:UiRenderEvent) : void
      {
         var _loc2_:Hook = null;
         var _loc3_:Array = null;
         var _loc5_:String = null;
         var _loc6_:GenericListener = null;
         if(!this._aLoadingUi[param1.uiTarget.name])
         {
            return;
         }
         if(param1.type == UiRenderEvent.UIRenderFailed)
         {
            this._aLoadingUi[param1.uiTarget.name] = null;
            return;
         }
         var _loc4_:uint = 0;
         while(_loc4_ < this._aLoadingUi[param1.uiTarget.name].length)
         {
            _loc2_ = this._aLoadingUi[param1.uiTarget.name][_loc4_].hook;
            _loc3_ = this._aLoadingUi[param1.uiTarget.name][_loc4_].args;
            for(_loc5_ in _aEvent[_loc2_.name])
            {
               if(_aEvent[_loc2_.name][_loc5_])
               {
                  _loc6_ = _aEvent[_loc2_.name][_loc5_];
                  _log.trace("Renvoi de " + _loc2_.name + " vers " + _loc6_.listener);
                  if(_loc6_.listener == param1.uiTarget.name)
                  {
                     _loc6_.getCallback().apply(null,_loc3_);
                  }
                  if(_aEvent[_loc2_.name] == null)
                  {
                     break;
                  }
               }
            }
            _loc4_++;
         }
         delete this._aLoadingUi[param1.uiTarget.name];
      }
      
      private function throwAsyncError(param1:TimerEvent) : void
      {
         this._asyncErrorTimer.reset();
         if(!this._asyncError.length)
         {
            return;
         }
         throw this._asyncError.shift();
      }
   }
}

