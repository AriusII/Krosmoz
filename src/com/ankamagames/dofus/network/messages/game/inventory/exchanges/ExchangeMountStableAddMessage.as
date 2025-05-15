package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.dofus.network.types.game.mount.MountClientData;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class ExchangeMountStableAddMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5971;
      
      private var _isInitialized:Boolean = false;
      
      public var mountDescription:MountClientData = new MountClientData();
      
      public function ExchangeMountStableAddMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5971;
      }
      
      public function initExchangeMountStableAddMessage(param1:MountClientData = null) : ExchangeMountStableAddMessage
      {
         this.mountDescription = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.mountDescription = new MountClientData();
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
         this.serializeAs_ExchangeMountStableAddMessage(param1);
      }
      
      public function serializeAs_ExchangeMountStableAddMessage(param1:IDataOutput) : void
      {
         this.mountDescription.serializeAs_MountClientData(param1);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_ExchangeMountStableAddMessage(param1);
      }
      
      public function deserializeAs_ExchangeMountStableAddMessage(param1:IDataInput) : void
      {
         this.mountDescription = new MountClientData();
         this.mountDescription.deserialize(param1);
      }
   }
}

