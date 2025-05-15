package com.ankamagames.berilia.types.graphic
{
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.html.HTMLLoader;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class TimeoutHTMLLoader extends HTMLLoader
   {
      private static var INSTANCE_CACHE:Dictionary = new Dictionary();
      
      public static const TIMEOUT:String = "TimeoutHTMLLoader_timeout";
      
      private var _fromCache:Boolean;
      
      private var _timer:Timer;
      
      private var _uid:String;
      
      public function TimeoutHTMLLoader()
      {
         super();
         addEventListener(Event["LOCATION_CHANGE"],this.onLocationChange);
      }
      
      public static function getLoader(param1:String = null) : TimeoutHTMLLoader
      {
         var _loc2_:TimeoutHTMLLoader = null;
         if(param1 != null && Boolean(INSTANCE_CACHE[param1]))
         {
            _loc2_ = INSTANCE_CACHE[param1];
            _loc2_._fromCache = true;
            _loc2_._timer.reset();
            _loc2_._timer.start();
            return _loc2_;
         }
         _loc2_ = new TimeoutHTMLLoader();
         _loc2_._uid = param1;
         if(param1)
         {
            INSTANCE_CACHE[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      public static function resetCache() : void
      {
         INSTANCE_CACHE = new Dictionary();
      }
      
      public function set life(param1:Number) : void
      {
         this._timer = new Timer(param1 * 60 * 1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimeOut);
      }
      
      public function get fromCache() : Boolean
      {
         return this._fromCache;
      }
      
      private function onLocationChange(param1:Event) : void
      {
         if(this._timer)
         {
            this._timer.reset();
            this._timer.start();
         }
      }
      
      private function onTimeOut(param1:Event) : void
      {
         this._timer.stop();
         dispatchEvent(new Event(TIMEOUT));
         if(!this._timer.running && Boolean(this._uid))
         {
            delete INSTANCE_CACHE[this._uid];
            this._timer.removeEventListener(TimerEvent.TIMER,this.onTimeOut);
         }
      }
   }
}

