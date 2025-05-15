package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class ExchangeBidHouseTypeMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5803;
      
      private var _isInitialized:Boolean = false;
      
      public var type:uint = 0;
      
      public function ExchangeBidHouseTypeMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5803;
      }
      
      public function initExchangeBidHouseTypeMessage(param1:uint = 0) : ExchangeBidHouseTypeMessage
      {
         this.type = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.type = 0;
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
         this.serializeAs_ExchangeBidHouseTypeMessage(param1);
      }
      
      public function serializeAs_ExchangeBidHouseTypeMessage(param1:IDataOutput) : void
      {
         if(this.type < 0)
         {
            throw new Error("Forbidden value (" + this.type + ") on element type.");
         }
         param1.writeInt(this.type);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_ExchangeBidHouseTypeMessage(param1);
      }
      
      public function deserializeAs_ExchangeBidHouseTypeMessage(param1:IDataInput) : void
      {
         this.type = param1.readInt();
         if(this.type < 0)
         {
            throw new Error("Forbidden value (" + this.type + ") on element of ExchangeBidHouseTypeMessage.type.");
         }
      }
   }
}

