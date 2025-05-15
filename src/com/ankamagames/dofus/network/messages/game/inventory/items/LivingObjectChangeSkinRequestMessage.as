package com.ankamagames.dofus.network.messages.game.inventory.items
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class LivingObjectChangeSkinRequestMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5725;
      
      private var _isInitialized:Boolean = false;
      
      public var livingUID:uint = 0;
      
      public var livingPosition:uint = 0;
      
      public var skinId:uint = 0;
      
      public function LivingObjectChangeSkinRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5725;
      }
      
      public function initLivingObjectChangeSkinRequestMessage(param1:uint = 0, param2:uint = 0, param3:uint = 0) : LivingObjectChangeSkinRequestMessage
      {
         this.livingUID = param1;
         this.livingPosition = param2;
         this.skinId = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.livingUID = 0;
         this.livingPosition = 0;
         this.skinId = 0;
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
         this.serializeAs_LivingObjectChangeSkinRequestMessage(param1);
      }
      
      public function serializeAs_LivingObjectChangeSkinRequestMessage(param1:IDataOutput) : void
      {
         if(this.livingUID < 0)
         {
            throw new Error("Forbidden value (" + this.livingUID + ") on element livingUID.");
         }
         param1.writeInt(this.livingUID);
         if(this.livingPosition < 0 || this.livingPosition > 255)
         {
            throw new Error("Forbidden value (" + this.livingPosition + ") on element livingPosition.");
         }
         param1.writeByte(this.livingPosition);
         if(this.skinId < 0)
         {
            throw new Error("Forbidden value (" + this.skinId + ") on element skinId.");
         }
         param1.writeInt(this.skinId);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_LivingObjectChangeSkinRequestMessage(param1);
      }
      
      public function deserializeAs_LivingObjectChangeSkinRequestMessage(param1:IDataInput) : void
      {
         this.livingUID = param1.readInt();
         if(this.livingUID < 0)
         {
            throw new Error("Forbidden value (" + this.livingUID + ") on element of LivingObjectChangeSkinRequestMessage.livingUID.");
         }
         this.livingPosition = param1.readUnsignedByte();
         if(this.livingPosition < 0 || this.livingPosition > 255)
         {
            throw new Error("Forbidden value (" + this.livingPosition + ") on element of LivingObjectChangeSkinRequestMessage.livingPosition.");
         }
         this.skinId = param1.readInt();
         if(this.skinId < 0)
         {
            throw new Error("Forbidden value (" + this.skinId + ") on element of LivingObjectChangeSkinRequestMessage.skinId.");
         }
      }
   }
}

