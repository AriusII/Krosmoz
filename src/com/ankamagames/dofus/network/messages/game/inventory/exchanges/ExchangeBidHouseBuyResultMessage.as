package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class ExchangeBidHouseBuyResultMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6272;
      
      private var _isInitialized:Boolean = false;
      
      public var uid:uint = 0;
      
      public var bought:Boolean = false;
      
      public function ExchangeBidHouseBuyResultMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6272;
      }
      
      public function initExchangeBidHouseBuyResultMessage(param1:uint = 0, param2:Boolean = false) : ExchangeBidHouseBuyResultMessage
      {
         this.uid = param1;
         this.bought = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.uid = 0;
         this.bought = false;
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
         this.serializeAs_ExchangeBidHouseBuyResultMessage(param1);
      }
      
      public function serializeAs_ExchangeBidHouseBuyResultMessage(param1:IDataOutput) : void
      {
         if(this.uid < 0)
         {
            throw new Error("Forbidden value (" + this.uid + ") on element uid.");
         }
         param1.writeInt(this.uid);
         param1.writeBoolean(this.bought);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_ExchangeBidHouseBuyResultMessage(param1);
      }
      
      public function deserializeAs_ExchangeBidHouseBuyResultMessage(param1:IDataInput) : void
      {
         this.uid = param1.readInt();
         if(this.uid < 0)
         {
            throw new Error("Forbidden value (" + this.uid + ") on element of ExchangeBidHouseBuyResultMessage.uid.");
         }
         this.bought = param1.readBoolean();
      }
   }
}

