package com.ankamagames.dofus.network.messages.game.context.roleplay.houses
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class HouseSellRequestMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5697;
      
      private var _isInitialized:Boolean = false;
      
      public var amount:uint = 0;
      
      public function HouseSellRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5697;
      }
      
      public function initHouseSellRequestMessage(param1:uint = 0) : HouseSellRequestMessage
      {
         this.amount = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.amount = 0;
         this._isInitialized = false;
      }
      
      override public function pack(param1:IDataOutput) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         this.serialize(_loc2_);
         writePacket(param1,this.getMessageId(),_loc2_);
      }
      
      override public function unpack(param1:IDataInput, param2:uint) : void
      {
         this.deserialize(param1);
      }
      
      public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_HouseSellRequestMessage(param1);
      }
      
      public function serializeAs_HouseSellRequestMessage(param1:IDataOutput) : void
      {
         if(this.amount < 0)
         {
            throw new Error("Forbidden value (" + this.amount + ") on element amount.");
         }
         param1.writeInt(this.amount);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_HouseSellRequestMessage(param1);
      }
      
      public function deserializeAs_HouseSellRequestMessage(param1:IDataInput) : void
      {
         this.amount = param1.readInt();
         if(this.amount < 0)
         {
            throw new Error("Forbidden value (" + this.amount + ") on element of HouseSellRequestMessage.amount.");
         }
      }
   }
}

