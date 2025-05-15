package com.ankamagames.berilia.managers
{
   import com.ankamagames.berilia.types.event.InstanceEvent;
   import com.ankamagames.berilia.utils.errors.BeriliaError;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.display.DisplayObject;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class UIEventManager
   {
      private static var _self:UIEventManager;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(UIEventManager));
      
      private var _dInstanceIndex:Dictionary = new Dictionary(true);
      
      public function UIEventManager()
      {
         super();
         if(_self != null)
         {
            throw new BeriliaError("UIEventManager is a singleton and should not be instanciated directly.");
         }
      }
      
      public static function getInstance() : UIEventManager
      {
         if(_self == null)
         {
            _self = new UIEventManager();
         }
         return _self;
      }
      
      public function get instances() : Dictionary
      {
         return this._dInstanceIndex;
      }
      
      public function registerInstance(param1:InstanceEvent) : void
      {
         this._dInstanceIndex[param1.instance] = param1;
      }
      
      public function isRegisteredInstance(param1:DisplayObject, param2:* = null) : Boolean
      {
         return Boolean(this._dInstanceIndex[param1]) && Boolean(this._dInstanceIndex[param1].events[getQualifiedClassName(param2)]);
      }
      
      public function removeInstance(param1:*) : void
      {
         delete this._dInstanceIndex[param1];
      }
   }
}

