package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class ExchangeOnHumanVendorRequestMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5772;
      
      private var _isInitialized:Boolean = false;
      
      public var humanVendorId:uint = 0;
      
      public var humanVendorCell:uint = 0;
      
      public function ExchangeOnHumanVendorRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5772;
      }
      
      public function initExchangeOnHumanVendorRequestMessage(param1:uint = 0, param2:uint = 0) : ExchangeOnHumanVendorRequestMessage
      {
         this.humanVendorId = param1;
         this.humanVendorCell = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.humanVendorId = 0;
         this.humanVendorCell = 0;
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
         this.serializeAs_ExchangeOnHumanVendorRequestMessage(param1);
      }
      
      public function serializeAs_ExchangeOnHumanVendorRequestMessage(param1:IDataOutput) : void
      {
         if(this.humanVendorId < 0)
         {
            throw new Error("Forbidden value (" + this.humanVendorId + ") on element humanVendorId.");
         }
         param1.writeInt(this.humanVendorId);
         if(this.humanVendorCell < 0)
         {
            throw new Error("Forbidden value (" + this.humanVendorCell + ") on element humanVendorCell.");
         }
         param1.writeInt(this.humanVendorCell);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_ExchangeOnHumanVendorRequestMessage(param1);
      }
      
      public function deserializeAs_ExchangeOnHumanVendorRequestMessage(param1:IDataInput) : void
      {
         this.humanVendorId = param1.readInt();
         if(this.humanVendorId < 0)
         {
            throw new Error("Forbidden value (" + this.humanVendorId + ") on element of ExchangeOnHumanVendorRequestMessage.humanVendorId.");
         }
         this.humanVendorCell = param1.readInt();
         if(this.humanVendorCell < 0)
         {
            throw new Error("Forbidden value (" + this.humanVendorCell + ") on element of ExchangeOnHumanVendorRequestMessage.humanVendorCell.");
         }
      }
   }
}

