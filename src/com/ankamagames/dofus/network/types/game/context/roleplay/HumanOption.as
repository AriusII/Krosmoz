package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class HumanOption implements INetworkType
   {
      public static const protocolId:uint = 406;
      
      public function HumanOption()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 406;
      }
      
      public function initHumanOption() : HumanOption
      {
         return this;
      }
      
      public function reset() : void
      {
      }
      
      public function serialize(param1:IDataOutput) : void
      {
      }
      
      public function serializeAs_HumanOption(param1:IDataOutput) : void
      {
      }
      
      public function deserialize(param1:IDataInput) : void
      {
      }
      
      public function deserializeAs_HumanOption(param1:IDataInput) : void
      {
      }
   }
}

