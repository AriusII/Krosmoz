package com.ankamagames.dofus.network.messages.game.social
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class ContactLookErrorMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6045;
      
      private var _isInitialized:Boolean = false;
      
      public var requestId:uint = 0;
      
      public function ContactLookErrorMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6045;
      }
      
      public function initContactLookErrorMessage(param1:uint = 0) : ContactLookErrorMessage
      {
         this.requestId = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.requestId = 0;
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
         this.serializeAs_ContactLookErrorMessage(param1);
      }
      
      public function serializeAs_ContactLookErrorMessage(param1:IDataOutput) : void
      {
         if(this.requestId < 0)
         {
            throw new Error("Forbidden value (" + this.requestId + ") on element requestId.");
         }
         param1.writeInt(this.requestId);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_ContactLookErrorMessage(param1);
      }
      
      public function deserializeAs_ContactLookErrorMessage(param1:IDataInput) : void
      {
         this.requestId = param1.readInt();
         if(this.requestId < 0)
         {
            throw new Error("Forbidden value (" + this.requestId + ") on element of ContactLookErrorMessage.requestId.");
         }
      }
   }
}

