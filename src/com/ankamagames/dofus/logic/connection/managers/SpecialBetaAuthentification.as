package com.ankamagames.dofus.logic.connection.managers
{
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.misc.utils.RpcServiceManager;
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.setTimeout;
   
   public class SpecialBetaAuthentification extends EventDispatcher
   {
      private static var BASE_URL:String = "http://api.ankama.";
      
      public static const STREAMING:String = "streaming";
      
      public static const MODULES:String = "modules";
      
      private var _rpc:RpcServiceManager;
      
      private var _haveAccess:Boolean = false;
      
      public function SpecialBetaAuthentification(param1:String, param2:String)
      {
         super();
         var _loc3_:* = BASE_URL;
         if(BuildInfos.BUILD_TYPE == BuildTypeEnum.RELEASE || BuildInfos.BUILD_TYPE == BuildTypeEnum.BETA || BuildInfos.BUILD_TYPE == BuildTypeEnum.ALPHA)
         {
            _loc3_ += "com";
         }
         else
         {
            _loc3_ += "lan";
         }
         var _loc4_:uint = uint.MAX_VALUE;
         switch(param2)
         {
            case STREAMING:
               _loc4_ = 1210;
               break;
            case MODULES:
               _loc4_ = 1127;
         }
         this._haveAccess = false;
         if(_loc4_ != uint.MAX_VALUE)
         {
            this._rpc = new RpcServiceManager(_loc3_ + "/forum/forum.json","json");
            this._rpc.addEventListener(Event.COMPLETE,this.onDataReceived);
            this._rpc.callMethod("IsAuthorized",["dofus","fr",param1,_loc4_]);
         }
         else
         {
            setTimeout(dispatchEvent,1,new Event(Event.INIT));
         }
      }
      
      public function get haveAccess() : Boolean
      {
         return this._haveAccess;
      }
      
      private function onDataReceived(param1:Event) : void
      {
         this._haveAccess = this._rpc.getAllResultData();
         dispatchEvent(new Event(Event.INIT));
      }
   }
}

