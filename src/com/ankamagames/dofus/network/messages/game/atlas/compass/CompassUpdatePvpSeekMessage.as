package com.ankamagames.dofus.network.messages.game.atlas.compass
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class CompassUpdatePvpSeekMessage extends CompassUpdateMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6013;
      
      private var _isInitialized:Boolean = false;
      
      public var memberId:uint = 0;
      
      public var memberName:String = "";
      
      public function CompassUpdatePvpSeekMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6013;
      }
      
      public function initCompassUpdatePvpSeekMessage(param1:uint = 0, param2:int = 0, param3:int = 0, param4:uint = 0, param5:String = "") : CompassUpdatePvpSeekMessage
      {
         super.initCompassUpdateMessage(param1,param2,param3);
         this.memberId = param4;
         this.memberName = param5;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.memberId = 0;
         this.memberName = "";
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
         this.serializeAs_CompassUpdatePvpSeekMessage(param1);
      }
      
      public function serializeAs_CompassUpdatePvpSeekMessage(param1:IDataOutput) : void
      {
         super.serializeAs_CompassUpdateMessage(param1);
         if(this.memberId < 0)
         {
            throw new Error("Forbidden value (" + this.memberId + ") on element memberId.");
         }
         param1.writeInt(this.memberId);
         param1.writeUTF(this.memberName);
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_CompassUpdatePvpSeekMessage(param1);
      }
      
      public function deserializeAs_CompassUpdatePvpSeekMessage(param1:IDataInput) : void
      {
         super.deserialize(param1);
         this.memberId = param1.readInt();
         if(this.memberId < 0)
         {
            throw new Error("Forbidden value (" + this.memberId + ") on element of CompassUpdatePvpSeekMessage.memberId.");
         }
         this.memberName = param1.readUTF();
      }
   }
}

