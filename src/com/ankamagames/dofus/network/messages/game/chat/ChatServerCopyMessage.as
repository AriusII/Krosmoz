package com.ankamagames.dofus.network.messages.game.chat
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class ChatServerCopyMessage extends ChatAbstractServerMessage implements INetworkMessage
   {
      public static const protocolId:uint = 882;
      
      private var _isInitialized:Boolean = false;
      
      public var receiverId:uint = 0;
      
      [Transient]
      public var receiverName:String = "";
      
      public function ChatServerCopyMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 882;
      }
      
      public function initChatServerCopyMessage(param1:uint = 0, param2:String = "", param3:uint = 0, param4:String = "", param5:uint = 0, param6:String = "") : ChatServerCopyMessage
      {
         super.initChatAbstractServerMessage(param1,param2,param3,param4);
         this.receiverId = param5;
         this.receiverName = param6;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.receiverId = 0;
         this.receiverName = "";
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
         this.serializeAs_ChatServerCopyMessage(param1);
      }
      
      public function serializeAs_ChatServerCopyMessage(param1:IDataOutput) : void
      {
         super.serializeAs_ChatAbstractServerMessage(param1);
         if(this.receiverId < 0)
         {
            throw new Error("Forbidden value (" + this.receiverId + ") on element receiverId.");
         }
         param1.writeInt(this.receiverId);
         param1.writeUTF(this.receiverName);
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_ChatServerCopyMessage(param1);
      }
      
      public function deserializeAs_ChatServerCopyMessage(param1:IDataInput) : void
      {
         super.deserialize(param1);
         this.receiverId = param1.readInt();
         if(this.receiverId < 0)
         {
            throw new Error("Forbidden value (" + this.receiverId + ") on element of ChatServerCopyMessage.receiverId.");
         }
         this.receiverName = param1.readUTF();
      }
   }
}

