package com.ankamagames.dofus.network.messages.game.context.roleplay
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class MapRunningFightDetailsRequestMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5750;
      
      private var _isInitialized:Boolean = false;
      
      public var fightId:uint = 0;
      
      public function MapRunningFightDetailsRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5750;
      }
      
      public function initMapRunningFightDetailsRequestMessage(param1:uint = 0) : MapRunningFightDetailsRequestMessage
      {
         this.fightId = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.fightId = 0;
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
         this.serializeAs_MapRunningFightDetailsRequestMessage(param1);
      }
      
      public function serializeAs_MapRunningFightDetailsRequestMessage(param1:IDataOutput) : void
      {
         if(this.fightId < 0)
         {
            throw new Error("Forbidden value (" + this.fightId + ") on element fightId.");
         }
         param1.writeInt(this.fightId);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_MapRunningFightDetailsRequestMessage(param1);
      }
      
      public function deserializeAs_MapRunningFightDetailsRequestMessage(param1:IDataInput) : void
      {
         this.fightId = param1.readInt();
         if(this.fightId < 0)
         {
            throw new Error("Forbidden value (" + this.fightId + ") on element of MapRunningFightDetailsRequestMessage.fightId.");
         }
      }
   }
}

