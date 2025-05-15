package com.ankamagames.dofus.logic.game.common.managers
{
   public class FlagManager
   {
      private static var _self:FlagManager;
      
      private var _phoenixs:Array = new Array();
      
      public function FlagManager()
      {
         super();
      }
      
      public static function getInstance() : FlagManager
      {
         if(!_self)
         {
            _self = new FlagManager();
         }
         return _self;
      }
      
      public function get phoenixs() : Array
      {
         return this._phoenixs;
      }
      
      public function set phoenixs(param1:Array) : void
      {
         this._phoenixs = param1;
      }
   }
}

