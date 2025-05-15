package com.ankamagames.dofus.network.messages.game.atlas.compass
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class CompassUpdateMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5591;
      
      private var _isInitialized:Boolean = false;
      
      public var type:uint = 0;
      
      public var worldX:int = 0;
      
      public var worldY:int = 0;
      
      public function CompassUpdateMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5591;
      }
      
      public function initCompassUpdateMessage(param1:uint = 0, param2:int = 0, param3:int = 0) : CompassUpdateMessage
      {
         this.type = param1;
         this.worldX = param2;
         this.worldY = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.type = 0;
         this.worldX = 0;
         this.worldY = 0;
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
         this.serializeAs_CompassUpdateMessage(param1);
      }
      
      public function serializeAs_CompassUpdateMessage(param1:IDataOutput) : void
      {
         param1.writeByte(this.type);
         if(this.worldX < -255 || this.worldX > 255)
         {
            throw new Error("Forbidden value (" + this.worldX + ") on element worldX.");
         }
         param1.writeShort(this.worldX);
         if(this.worldY < -255 || this.worldY > 255)
         {
            throw new Error("Forbidden value (" + this.worldY + ") on element worldY.");
         }
         param1.writeShort(this.worldY);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_CompassUpdateMessage(param1);
      }
      
      public function deserializeAs_CompassUpdateMessage(param1:IDataInput) : void
      {
         this.type = param1.readByte();
         if(this.type < 0)
         {
            throw new Error("Forbidden value (" + this.type + ") on element of CompassUpdateMessage.type.");
         }
         this.worldX = param1.readShort();
         if(this.worldX < -255 || this.worldX > 255)
         {
            throw new Error("Forbidden value (" + this.worldX + ") on element of CompassUpdateMessage.worldX.");
         }
         this.worldY = param1.readShort();
         if(this.worldY < -255 || this.worldY > 255)
         {
            throw new Error("Forbidden value (" + this.worldY + ") on element of CompassUpdateMessage.worldY.");
         }
      }
   }
}

