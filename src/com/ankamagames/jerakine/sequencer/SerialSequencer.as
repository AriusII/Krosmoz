package com.ankamagames.jerakine.sequencer
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.events.SequencerEvent;
   import com.ankamagames.jerakine.utils.misc.FightProfiler;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class SerialSequencer extends EventDispatcher implements ISequencer, IEventDispatcher
   {
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(SerialSequencer));
      
      public static const DEFAULT_SEQUENCER_NAME:String = "SerialSequencerDefault";
      
      private static var SEQUENCERS:Array = [];
      
      private var _aStep:Array = new Array();
      
      private var _currentStep:ISequencable;
      
      private var _running:Boolean = false;
      
      private var _type:String;
      
      private var _activeSubSequenceCount:uint;
      
      public function SerialSequencer(param1:String = "SerialSequencerDefault")
      {
         super();
         if(!SEQUENCERS[param1])
         {
            SEQUENCERS[param1] = new Dictionary(true);
         }
         SEQUENCERS[param1][this] = true;
      }
      
      public static function clearByType(param1:String) : void
      {
         var _loc2_:Object = null;
         for(_loc2_ in SEQUENCERS[param1])
         {
            SerialSequencer(_loc2_).clear();
         }
         delete SEQUENCERS[param1];
      }
      
      public function get currentStep() : ISequencable
      {
         return this._currentStep;
      }
      
      public function get length() : uint
      {
         return this._aStep.length;
      }
      
      public function get running() : Boolean
      {
         return this._running;
      }
      
      public function get steps() : Array
      {
         return this._aStep;
      }
      
      public function addStep(param1:ISequencable) : void
      {
         this._aStep.push(param1);
      }
      
      public function start() : void
      {
         if(!this._running)
         {
            this._running = this._aStep.length != 0;
            if(this._running)
            {
               this.execute();
            }
            else
            {
               dispatchEvent(new SequencerEvent(SequencerEvent.SEQUENCE_END,false,false,this));
            }
         }
      }
      
      public function clear() : void
      {
         var _loc1_:ISequencable = null;
         if(this._currentStep)
         {
            this._currentStep.clear();
            this._currentStep = null;
         }
         for each(_loc1_ in this._aStep)
         {
            _loc1_.clear();
         }
         this._aStep = new Array();
      }
      
      override public function toString() : String
      {
         var _loc1_:String = "";
         var _loc2_:uint = 0;
         while(_loc2_ < this._aStep.length)
         {
            _loc1_ += this._aStep[_loc2_].toString() + "\n";
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function execute() : void
      {
         this._currentStep = this._aStep.shift();
         if(!this._currentStep)
         {
            return;
         }
         FightProfiler.getInstance().start();
         this._currentStep.addListener(this);
         try
         {
            if(this._currentStep is ISubSequenceSequencable)
            {
               ++this._activeSubSequenceCount;
               ISubSequenceSequencable(this._currentStep).addEventListener(SequencerEvent.SEQUENCE_END,this.onSubSequenceEnd);
            }
            this._currentStep.start();
         }
         catch(e:Error)
         {
            if(_currentStep is ISubSequenceSequencable)
            {
               --_activeSubSequenceCount;
               ISubSequenceSequencable(_currentStep).removeEventListener(SequencerEvent.SEQUENCE_END,onSubSequenceEnd);
            }
            _log.error("Exception sur la step " + _currentStep + " : \n" + e.getStackTrace());
            stepFinished();
         }
      }
      
      public function stepFinished() : void
      {
         if(this._running)
         {
            this._running = this._aStep.length != 0;
            if(!this._running)
            {
               if(!this._activeSubSequenceCount)
               {
                  dispatchEvent(new SequencerEvent(SequencerEvent.SEQUENCE_END,false,false,this));
               }
               else
               {
                  this._running = true;
               }
            }
            else
            {
               this.execute();
            }
         }
      }
      
      private function onSubSequenceEnd(param1:SequencerEvent) : void
      {
         --this._activeSubSequenceCount;
         if(!this._activeSubSequenceCount)
         {
            this._running = false;
            dispatchEvent(new SequencerEvent(SequencerEvent.SEQUENCE_END,false,false,this));
         }
      }
   }
}

