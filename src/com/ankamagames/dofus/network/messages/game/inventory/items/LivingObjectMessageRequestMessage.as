package com.ankamagames.dofus.network.messages.game.inventory.items
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class LivingObjectMessageRequestMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6066;
      
      private var _isInitialized:Boolean = false;
      
      public var msgId:uint = 0;
      
      public var parameters:Vector.<String> = new Vector.<String>();
      
      public var livingObject:uint = 0;
      
      public function LivingObjectMessageRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6066;
      }
      
      public function initLivingObjectMessageRequestMessage(param1:uint = 0, param2:Vector.<String> = null, param3:uint = 0) : LivingObjectMessageRequestMessage
      {
         this.msgId = param1;
         this.parameters = param2;
         this.livingObject = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.msgId = 0;
         this.parameters = new Vector.<String>();
         this.livingObject = 0;
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
         this.serializeAs_LivingObjectMessageRequestMessage(param1);
      }
      
      public function serializeAs_LivingObjectMessageRequestMessage(param1:IDataOutput) : void
      {
         if(this.msgId < 0)
         {
            throw new Error("Forbidden value (" + this.msgId + ") on element msgId.");
         }
         param1.writeShort(this.msgId);
         param1.writeShort(this.parameters.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.parameters.length)
         {
            param1.writeUTF(this.parameters[_loc2_]);
            _loc2_++;
         }
         if(this.livingObject < 0 || this.livingObject > 4294967295)
         {
            throw new Error("Forbidden value (" + this.livingObject + ") on element livingObject.");
         }
         param1.writeUnsignedInt(this.livingObject);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_LivingObjectMessageRequestMessage(param1);
      }
      
      public function deserializeAs_LivingObjectMessageRequestMessage(param1:IDataInput) : void
      {
         var _loc4_:String = null;
         this.msgId = param1.readShort();
         if(this.msgId < 0)
         {
            throw new Error("Forbidden value (" + this.msgId + ") on element of LivingObjectMessageRequestMessage.msgId.");
         }
         var _loc2_:uint = uint(param1.readUnsignedShort());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.readUTF();
            this.parameters.push(_loc4_);
            _loc3_++;
         }
         this.livingObject = param1.readUnsignedInt();
         if(this.livingObject < 0 || this.livingObject > 4294967295)
         {
            throw new Error("Forbidden value (" + this.livingObject + ") on element of LivingObjectMessageRequestMessage.livingObject.");
         }
      }
   }
}

