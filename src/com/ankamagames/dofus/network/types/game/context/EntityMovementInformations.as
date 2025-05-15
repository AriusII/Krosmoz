package com.ankamagames.dofus.network.types.game.context
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class EntityMovementInformations implements INetworkType
   {
      public static const protocolId:uint = 63;
      
      public var id:int = 0;
      
      public var steps:Vector.<int> = new Vector.<int>();
      
      public function EntityMovementInformations()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 63;
      }
      
      public function initEntityMovementInformations(param1:int = 0, param2:Vector.<int> = null) : EntityMovementInformations
      {
         this.id = param1;
         this.steps = param2;
         return this;
      }
      
      public function reset() : void
      {
         this.id = 0;
         this.steps = new Vector.<int>();
      }
      
      public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_EntityMovementInformations(param1);
      }
      
      public function serializeAs_EntityMovementInformations(param1:IDataOutput) : void
      {
         param1.writeInt(this.id);
         param1.writeShort(this.steps.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.steps.length)
         {
            param1.writeByte(this.steps[_loc2_]);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_EntityMovementInformations(param1);
      }
      
      public function deserializeAs_EntityMovementInformations(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         this.id = param1.readInt();
         var _loc2_:uint = uint(param1.readUnsignedShort());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = int(param1.readByte());
            this.steps.push(_loc4_);
            _loc3_++;
         }
      }
   }
}

