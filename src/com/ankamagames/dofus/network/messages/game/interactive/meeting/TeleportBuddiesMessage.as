package com.ankamagames.dofus.network.messages.game.interactive.meeting
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class TeleportBuddiesMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6289;
      
      private var _isInitialized:Boolean = false;
      
      public var dungeonId:uint = 0;
      
      public function TeleportBuddiesMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6289;
      }
      
      public function initTeleportBuddiesMessage(param1:uint = 0) : TeleportBuddiesMessage
      {
         this.dungeonId = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.dungeonId = 0;
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
         this.serializeAs_TeleportBuddiesMessage(param1);
      }
      
      public function serializeAs_TeleportBuddiesMessage(param1:IDataOutput) : void
      {
         if(this.dungeonId < 0)
         {
            throw new Error("Forbidden value (" + this.dungeonId + ") on element dungeonId.");
         }
         param1.writeShort(this.dungeonId);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_TeleportBuddiesMessage(param1);
      }
      
      public function deserializeAs_TeleportBuddiesMessage(param1:IDataInput) : void
      {
         this.dungeonId = param1.readShort();
         if(this.dungeonId < 0)
         {
            throw new Error("Forbidden value (" + this.dungeonId + ") on element of TeleportBuddiesMessage.dungeonId.");
         }
      }
   }
}

