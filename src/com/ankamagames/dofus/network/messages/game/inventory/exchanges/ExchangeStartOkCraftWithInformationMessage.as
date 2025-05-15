package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class ExchangeStartOkCraftWithInformationMessage extends ExchangeStartOkCraftMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5941;
      
      private var _isInitialized:Boolean = false;
      
      public var nbCase:uint = 0;
      
      public var skillId:uint = 0;
      
      public function ExchangeStartOkCraftWithInformationMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5941;
      }
      
      public function initExchangeStartOkCraftWithInformationMessage(param1:uint = 0, param2:uint = 0) : ExchangeStartOkCraftWithInformationMessage
      {
         this.nbCase = param1;
         this.skillId = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.nbCase = 0;
         this.skillId = 0;
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
      
      override public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_ExchangeStartOkCraftWithInformationMessage(param1);
      }
      
      public function serializeAs_ExchangeStartOkCraftWithInformationMessage(param1:IDataOutput) : void
      {
         super.serializeAs_ExchangeStartOkCraftMessage(param1);
         if(this.nbCase < 0)
         {
            throw new Error("Forbidden value (" + this.nbCase + ") on element nbCase.");
         }
         param1.writeByte(this.nbCase);
         if(this.skillId < 0)
         {
            throw new Error("Forbidden value (" + this.skillId + ") on element skillId.");
         }
         param1.writeInt(this.skillId);
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_ExchangeStartOkCraftWithInformationMessage(param1);
      }
      
      public function deserializeAs_ExchangeStartOkCraftWithInformationMessage(param1:IDataInput) : void
      {
         super.deserialize(param1);
         this.nbCase = param1.readByte();
         if(this.nbCase < 0)
         {
            throw new Error("Forbidden value (" + this.nbCase + ") on element of ExchangeStartOkCraftWithInformationMessage.nbCase.");
         }
         this.skillId = param1.readInt();
         if(this.skillId < 0)
         {
            throw new Error("Forbidden value (" + this.skillId + ") on element of ExchangeStartOkCraftWithInformationMessage.skillId.");
         }
      }
   }
}

