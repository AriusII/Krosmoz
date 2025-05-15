package com.ankamagames.dofus.network.messages.game.character.status
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.character.status.PlayerStatus;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class PlayerStatusUpdateRequestMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6387;
      
      private var _isInitialized:Boolean = false;
      
      public var status:PlayerStatus = new PlayerStatus();
      
      public function PlayerStatusUpdateRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6387;
      }
      
      public function initPlayerStatusUpdateRequestMessage(param1:PlayerStatus = null) : PlayerStatusUpdateRequestMessage
      {
         this.status = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.status = new PlayerStatus();
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
         this.serializeAs_PlayerStatusUpdateRequestMessage(param1);
      }
      
      public function serializeAs_PlayerStatusUpdateRequestMessage(param1:IDataOutput) : void
      {
         param1.writeShort(this.status.getTypeId());
         this.status.serialize(param1);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_PlayerStatusUpdateRequestMessage(param1);
      }
      
      public function deserializeAs_PlayerStatusUpdateRequestMessage(param1:IDataInput) : void
      {
         var _loc2_:uint = uint(param1.readUnsignedShort());
         this.status = ProtocolTypeManager.getInstance(PlayerStatus,_loc2_);
         this.status.deserialize(param1);
      }
   }
}

