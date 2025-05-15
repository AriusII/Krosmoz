package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class ExchangeGoldPaymentForCraftMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5833;
      
      private var _isInitialized:Boolean = false;
      
      public var onlySuccess:Boolean = false;
      
      public var goldSum:uint = 0;
      
      public function ExchangeGoldPaymentForCraftMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5833;
      }
      
      public function initExchangeGoldPaymentForCraftMessage(param1:Boolean = false, param2:uint = 0) : ExchangeGoldPaymentForCraftMessage
      {
         this.onlySuccess = param1;
         this.goldSum = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.onlySuccess = false;
         this.goldSum = 0;
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
         this.serializeAs_ExchangeGoldPaymentForCraftMessage(param1);
      }
      
      public function serializeAs_ExchangeGoldPaymentForCraftMessage(param1:IDataOutput) : void
      {
         param1.writeBoolean(this.onlySuccess);
         if(this.goldSum < 0)
         {
            throw new Error("Forbidden value (" + this.goldSum + ") on element goldSum.");
         }
         param1.writeInt(this.goldSum);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_ExchangeGoldPaymentForCraftMessage(param1);
      }
      
      public function deserializeAs_ExchangeGoldPaymentForCraftMessage(param1:IDataInput) : void
      {
         this.onlySuccess = param1.readBoolean();
         this.goldSum = param1.readInt();
         if(this.goldSum < 0)
         {
            throw new Error("Forbidden value (" + this.goldSum + ") on element of ExchangeGoldPaymentForCraftMessage.goldSum.");
         }
      }
   }
}

