package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class ExchangeReplyTaxVendorMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5787;
      
      private var _isInitialized:Boolean = false;
      
      public var objectValue:uint = 0;
      
      public var totalTaxValue:uint = 0;
      
      public function ExchangeReplyTaxVendorMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5787;
      }
      
      public function initExchangeReplyTaxVendorMessage(param1:uint = 0, param2:uint = 0) : ExchangeReplyTaxVendorMessage
      {
         this.objectValue = param1;
         this.totalTaxValue = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.objectValue = 0;
         this.totalTaxValue = 0;
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
         this.serializeAs_ExchangeReplyTaxVendorMessage(param1);
      }
      
      public function serializeAs_ExchangeReplyTaxVendorMessage(param1:IDataOutput) : void
      {
         if(this.objectValue < 0)
         {
            throw new Error("Forbidden value (" + this.objectValue + ") on element objectValue.");
         }
         param1.writeInt(this.objectValue);
         if(this.totalTaxValue < 0)
         {
            throw new Error("Forbidden value (" + this.totalTaxValue + ") on element totalTaxValue.");
         }
         param1.writeInt(this.totalTaxValue);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_ExchangeReplyTaxVendorMessage(param1);
      }
      
      public function deserializeAs_ExchangeReplyTaxVendorMessage(param1:IDataInput) : void
      {
         this.objectValue = param1.readInt();
         if(this.objectValue < 0)
         {
            throw new Error("Forbidden value (" + this.objectValue + ") on element of ExchangeReplyTaxVendorMessage.objectValue.");
         }
         this.totalTaxValue = param1.readInt();
         if(this.totalTaxValue < 0)
         {
            throw new Error("Forbidden value (" + this.totalTaxValue + ") on element of ExchangeReplyTaxVendorMessage.totalTaxValue.");
         }
      }
   }
}

