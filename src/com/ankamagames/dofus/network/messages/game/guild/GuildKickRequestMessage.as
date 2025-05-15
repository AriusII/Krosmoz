package com.ankamagames.dofus.network.messages.game.guild
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class GuildKickRequestMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5887;
      
      private var _isInitialized:Boolean = false;
      
      public var kickedId:uint = 0;
      
      public function GuildKickRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5887;
      }
      
      public function initGuildKickRequestMessage(param1:uint = 0) : GuildKickRequestMessage
      {
         this.kickedId = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.kickedId = 0;
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
         this.serializeAs_GuildKickRequestMessage(param1);
      }
      
      public function serializeAs_GuildKickRequestMessage(param1:IDataOutput) : void
      {
         if(this.kickedId < 0)
         {
            throw new Error("Forbidden value (" + this.kickedId + ") on element kickedId.");
         }
         param1.writeInt(this.kickedId);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_GuildKickRequestMessage(param1);
      }
      
      public function deserializeAs_GuildKickRequestMessage(param1:IDataInput) : void
      {
         this.kickedId = param1.readInt();
         if(this.kickedId < 0)
         {
            throw new Error("Forbidden value (" + this.kickedId + ") on element of GuildKickRequestMessage.kickedId.");
         }
      }
   }
}

