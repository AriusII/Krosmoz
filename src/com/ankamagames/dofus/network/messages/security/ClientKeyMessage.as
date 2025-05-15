package com.ankamagames.dofus.network.messages.security
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class ClientKeyMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5607;
      
      private var _isInitialized:Boolean = false;
      
      public var key:String = "";
      
      public function ClientKeyMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5607;
      }
      
      public function initClientKeyMessage(param1:String = "") : ClientKeyMessage
      {
         this.key = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.key = "";
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
         this.serializeAs_ClientKeyMessage(param1);
      }
      
      public function serializeAs_ClientKeyMessage(param1:IDataOutput) : void
      {
         param1.writeUTF(this.key);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_ClientKeyMessage(param1);
      }
      
      public function deserializeAs_ClientKeyMessage(param1:IDataInput) : void
      {
         this.key = param1.readUTF();
      }
   }
}

