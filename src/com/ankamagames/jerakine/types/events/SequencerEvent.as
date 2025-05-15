package com.ankamagames.jerakine.types.events
{
   import com.ankamagames.jerakine.sequencer.ISequencer;
   import flash.events.Event;
   
   public class SequencerEvent extends Event
   {
      public static const SEQUENCE_END:String = "onSequenceEnd";
      
      private var _sequancer:ISequencer;
      
      public function SequencerEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:ISequencer = null)
      {
         super(param1,param2,param3);
         this._sequancer = param4;
      }
      
      public function get sequencer() : ISequencer
      {
         return this._sequancer;
      }
   }
}

