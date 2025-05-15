package com.ankamagames.dofus
{
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import com.ankamagames.jerakine.types.Version;
   
   public final class BuildInfos
   {
      public static var BUILD_VERSION:Version = new Version(2,14,0);
      
      public static var BUILD_TYPE:uint = BuildTypeEnum.RELEASE;
      
      public static var BUILD_REVISION:int = 35100;
      
      public static var BUILD_PATCH:int = 0;
      
      public static const BUILD_DATE:String = "May 14, 2025 - 22:00:00 CEST";
      
      public function BuildInfos()
      {
         super();
      }
   }
}

