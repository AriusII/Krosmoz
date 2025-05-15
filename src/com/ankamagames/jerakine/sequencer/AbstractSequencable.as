package com.ankamagames.jerakine.sequencer
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.misc.FightProfiler;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   
   public class AbstractSequencable extends EventDispatcher implements ISequencable
   {
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AbstractSequencable));
      
      private var _aListener:Array = new Array();
      
      private var _timeOut:Timer;
      
      private var _castingSpellId:int = -1;
      
      public function AbstractSequencable()
      {
         super();
      }
      
      public function start() : void
      {
      }
      
      public function addListener(param1:ISequencableListener) : void
      {
         if(!this._timeOut)
         {
            this._timeOut = new Timer(5000,1);
            this._timeOut.addEventListener(TimerEvent.TIMER,this.onTimeOut);
            this._timeOut.start();
         }
         this._aListener.push(param1);
      }
      
      protected function executeCallbacks() : void
      {
         var _loc1_:ISequencableListener = null;
         FightProfiler.getInstance().stop();
         if(this._timeOut)
         {
            this._timeOut.removeEventListener(TimerEvent.TIMER,this.onTimeOut);
            this._timeOut.reset();
            this._timeOut = null;
         }
         for each(_loc1_ in this._aListener)
         {
            if(_loc1_)
            {
               _loc1_.stepFinished();
            }
         }
      }
      
      public function removeListener(param1:ISequencableListener) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this._aListener.length)
         {
            if(this._aListener[_loc2_] == param1)
            {
               this._aListener = this._aListener.slice(0,_loc2_).concat(this._aListener.slice(_loc2_ + 1,this._aListener.length));
               break;
            }
            _loc2_++;
         }
      }
      
      override public function toString() : String
      {
         return getQualifiedClassName(this);
      }
      
      public function clear() : void
      {
         if(this._timeOut)
         {
            this._timeOut.stop();
         }
         this._timeOut = null;
         this._aListener = null;
      }
      
      public function get castingSpellId() : int
      {
         return this._castingSpellId;
      }
      
      public function set castingSpellId(param1:int) : void
      {
         this._castingSpellId = param1;
      }
      
      protected function onTimeOut(param1:TimerEvent) : void
      {
         this.executeCallbacks();
         _log.error("Time out sur la step " + this);
      }
   }
}

