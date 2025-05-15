package com.ankamagames.dofus.network.messages.connection
{
   import com.ankamagames.dofus.network.types.connection.GameServerInformations;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class ServerStatusUpdateMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 50;
      
      private var _isInitialized:Boolean = false;
      
      public var server:GameServerInformations = new GameServerInformations();
      
      public function ServerStatusUpdateMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 50;
      }
      
      public function initServerStatusUpdateMessage(param1:GameServerInformations = null) : ServerStatusUpdateMessage
      {
         this.server = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.server = new GameServerInformations();
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
         this.serializeAs_ServerStatusUpdateMessage(param1);
      }
      
      public function serializeAs_ServerStatusUpdateMessage(param1:IDataOutput) : void
      {
         this.server.serializeAs_GameServerInformations(param1);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_ServerStatusUpdateMessage(param1);
      }
      
      public function deserializeAs_ServerStatusUpdateMessage(param1:IDataInput) : void
      {
         this.server = new GameServerInformations();
         this.server.deserialize(param1);
      }
   }
}

