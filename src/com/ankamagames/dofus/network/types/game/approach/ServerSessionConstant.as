package com.ankamagames.dofus.network.types.game.approach
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class ServerSessionConstant implements INetworkType
   {
      public static const protocolId:uint = 430;
      
      public var id:uint = 0;
      
      public function ServerSessionConstant()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 430;
      }
      
      public function initServerSessionConstant(param1:uint = 0) : ServerSessionConstant
      {
         this.id = param1;
         return this;
      }
      
      public function reset() : void
      {
         this.id = 0;
      }
      
      public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_ServerSessionConstant(param1);
      }
      
      public function serializeAs_ServerSessionConstant(param1:IDataOutput) : void
      {
         if(this.id < 0)
         {
            throw new Error("Forbidden value (" + this.id + ") on element id.");
         }
         param1.writeShort(this.id);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_ServerSessionConstant(param1);
      }
      
      public function deserializeAs_ServerSessionConstant(param1:IDataInput) : void
      {
         this.id = param1.readShort();
         if(this.id < 0)
         {
            throw new Error("Forbidden value (" + this.id + ") on element of ServerSessionConstant.id.");
         }
      }
   }
}

