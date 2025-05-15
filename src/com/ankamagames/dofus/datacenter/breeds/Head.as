package com.ankamagames.dofus.datacenter.breeds
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.getQualifiedClassName;
   
   public class Head implements IDataCenter
   {
      public static const MODULE:String = "Heads";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Head));
      
      public var id:int;
      
      public var skins:String;
      
      public var assetId:String;
      
      public var breed:uint;
      
      public var gender:uint;
      
      public var label:String;
      
      public var order:uint;
      
      public function Head()
      {
         super();
      }
      
      public static function getHeadById(param1:int) : Head
      {
         return GameData.getObject(MODULE,param1) as Head;
      }
      
      public static function getHeads() : Array
      {
         return GameData.getObjects(MODULE);
      }
   }
}

