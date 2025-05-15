package com.ankamagames.dofus.network.messages.game.approach
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class AuthenticationTicketMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 110;
      
      private var _isInitialized:Boolean = false;
      
      public var lang:String = "";
      
      public var ticket:String = "";
      
      public function AuthenticationTicketMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 110;
      }
      
      public function initAuthenticationTicketMessage(param1:String = "", param2:String = "") : AuthenticationTicketMessage
      {
         this.lang = param1;
         this.ticket = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.lang = "";
         this.ticket = "";
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
         this.serializeAs_AuthenticationTicketMessage(param1);
      }
      
      public function serializeAs_AuthenticationTicketMessage(param1:IDataOutput) : void
      {
         param1.writeUTF(this.lang);
         param1.writeUTF(this.ticket);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_AuthenticationTicketMessage(param1);
      }
      
      public function deserializeAs_AuthenticationTicketMessage(param1:IDataInput) : void
      {
         this.lang = param1.readUTF();
         this.ticket = param1.readUTF();
      }
   }
}

