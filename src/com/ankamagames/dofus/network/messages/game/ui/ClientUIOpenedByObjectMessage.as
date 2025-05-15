package com.ankamagames.dofus.network.messages.game.ui
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class ClientUIOpenedByObjectMessage extends ClientUIOpenedMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6463;
      
      private var _isInitialized:Boolean = false;
      
      public var uid:uint = 0;
      
      public function ClientUIOpenedByObjectMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6463;
      }
      
      public function initClientUIOpenedByObjectMessage(param1:uint = 0, param2:uint = 0) : ClientUIOpenedByObjectMessage
      {
         super.initClientUIOpenedMessage(param1);
         this.uid = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.uid = 0;
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
         this.serializeAs_ClientUIOpenedByObjectMessage(param1);
      }
      
      public function serializeAs_ClientUIOpenedByObjectMessage(param1:IDataOutput) : void
      {
         super.serializeAs_ClientUIOpenedMessage(param1);
         if(this.uid < 0)
         {
            throw new Error("Forbidden value (" + this.uid + ") on element uid.");
         }
         param1.writeInt(this.uid);
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_ClientUIOpenedByObjectMessage(param1);
      }
      
      public function deserializeAs_ClientUIOpenedByObjectMessage(param1:IDataInput) : void
      {
         super.deserialize(param1);
         this.uid = param1.readInt();
         if(this.uid < 0)
         {
            throw new Error("Forbidden value (" + this.uid + ") on element of ClientUIOpenedByObjectMessage.uid.");
         }
      }
   }
}

