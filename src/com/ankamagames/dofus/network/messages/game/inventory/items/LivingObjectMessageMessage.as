package com.ankamagames.dofus.network.messages.game.inventory.items
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class LivingObjectMessageMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6065;
      
      private var _isInitialized:Boolean = false;
      
      public var msgId:uint = 0;
      
      public var timeStamp:uint = 0;
      
      public var owner:String = "";
      
      public var objectGenericId:uint = 0;
      
      public function LivingObjectMessageMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6065;
      }
      
      public function initLivingObjectMessageMessage(param1:uint = 0, param2:uint = 0, param3:String = "", param4:uint = 0) : LivingObjectMessageMessage
      {
         this.msgId = param1;
         this.timeStamp = param2;
         this.owner = param3;
         this.objectGenericId = param4;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.msgId = 0;
         this.timeStamp = 0;
         this.owner = "";
         this.objectGenericId = 0;
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
         this.serializeAs_LivingObjectMessageMessage(param1);
      }
      
      public function serializeAs_LivingObjectMessageMessage(param1:IDataOutput) : void
      {
         if(this.msgId < 0)
         {
            throw new Error("Forbidden value (" + this.msgId + ") on element msgId.");
         }
         param1.writeShort(this.msgId);
         if(this.timeStamp < 0 || this.timeStamp > 4294967295)
         {
            throw new Error("Forbidden value (" + this.timeStamp + ") on element timeStamp.");
         }
         param1.writeUnsignedInt(this.timeStamp);
         param1.writeUTF(this.owner);
         if(this.objectGenericId < 0 || this.objectGenericId > 4294967295)
         {
            throw new Error("Forbidden value (" + this.objectGenericId + ") on element objectGenericId.");
         }
         param1.writeUnsignedInt(this.objectGenericId);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_LivingObjectMessageMessage(param1);
      }
      
      public function deserializeAs_LivingObjectMessageMessage(param1:IDataInput) : void
      {
         this.msgId = param1.readShort();
         if(this.msgId < 0)
         {
            throw new Error("Forbidden value (" + this.msgId + ") on element of LivingObjectMessageMessage.msgId.");
         }
         this.timeStamp = param1.readUnsignedInt();
         if(this.timeStamp < 0 || this.timeStamp > 4294967295)
         {
            throw new Error("Forbidden value (" + this.timeStamp + ") on element of LivingObjectMessageMessage.timeStamp.");
         }
         this.owner = param1.readUTF();
         this.objectGenericId = param1.readUnsignedInt();
         if(this.objectGenericId < 0 || this.objectGenericId > 4294967295)
         {
            throw new Error("Forbidden value (" + this.objectGenericId + ") on element of LivingObjectMessageMessage.objectGenericId.");
         }
      }
   }
}

