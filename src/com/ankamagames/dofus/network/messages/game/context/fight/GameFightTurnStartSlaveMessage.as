package com.ankamagames.dofus.network.messages.game.context.fight
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class GameFightTurnStartSlaveMessage extends GameFightTurnStartMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6213;
      
      private var _isInitialized:Boolean = false;
      
      public var idSummoner:int = 0;
      
      public function GameFightTurnStartSlaveMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6213;
      }
      
      public function initGameFightTurnStartSlaveMessage(param1:int = 0, param2:uint = 0, param3:int = 0) : GameFightTurnStartSlaveMessage
      {
         super.initGameFightTurnStartMessage(param1,param2);
         this.idSummoner = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.idSummoner = 0;
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
         this.serializeAs_GameFightTurnStartSlaveMessage(param1);
      }
      
      public function serializeAs_GameFightTurnStartSlaveMessage(param1:IDataOutput) : void
      {
         super.serializeAs_GameFightTurnStartMessage(param1);
         param1.writeInt(this.idSummoner);
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_GameFightTurnStartSlaveMessage(param1);
      }
      
      public function deserializeAs_GameFightTurnStartSlaveMessage(param1:IDataInput) : void
      {
         super.deserialize(param1);
         this.idSummoner = param1.readInt();
      }
   }
}

