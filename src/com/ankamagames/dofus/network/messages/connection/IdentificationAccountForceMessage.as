package com.ankamagames.dofus.network.messages.connection
{
   import com.ankamagames.dofus.network.types.version.VersionExtended;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class IdentificationAccountForceMessage extends IdentificationMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6119;
      
      private var _isInitialized:Boolean = false;
      
      public var forcedAccountLogin:String = "";
      
      public function IdentificationAccountForceMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6119;
      }
      
      public function initIdentificationAccountForceMessage(param1:VersionExtended = null, param2:String = "", username:String = "", password:String = "", hwnd:String = "", param4:int = 0, param5:Boolean = false, param6:Boolean = false, param7:Boolean = false, param8:Number = 0, param9:String = "") : IdentificationAccountForceMessage
      {
         super.initIdentificationMessage(param1,param2,username,password,hwnd,param4,param5,param6,param7,param8);
         this.forcedAccountLogin = param9;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.forcedAccountLogin = "";
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
      
      override public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_IdentificationAccountForceMessage(param1);
      }
      
      public function serializeAs_IdentificationAccountForceMessage(param1:IDataOutput) : void
      {
         super.serializeAs_IdentificationMessage(param1);
         param1.writeUTF(this.forcedAccountLogin);
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_IdentificationAccountForceMessage(param1);
      }
      
      public function deserializeAs_IdentificationAccountForceMessage(param1:IDataInput) : void
      {
         super.deserialize(param1);
         this.forcedAccountLogin = param1.readUTF();
      }
   }
}

