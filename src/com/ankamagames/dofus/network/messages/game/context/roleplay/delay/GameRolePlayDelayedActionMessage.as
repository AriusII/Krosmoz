package com.ankamagames.dofus.network.messages.game.context.roleplay.delay
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class GameRolePlayDelayedActionMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6153;
      
      private var _isInitialized:Boolean = false;
      
      public var delayedCharacterId:int = 0;
      
      public var delayTypeId:uint = 0;
      
      public var delayEndTime:Number = 0;
      
      public function GameRolePlayDelayedActionMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6153;
      }
      
      public function initGameRolePlayDelayedActionMessage(param1:int = 0, param2:uint = 0, param3:Number = 0) : GameRolePlayDelayedActionMessage
      {
         this.delayedCharacterId = param1;
         this.delayTypeId = param2;
         this.delayEndTime = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.delayedCharacterId = 0;
         this.delayTypeId = 0;
         this.delayEndTime = 0;
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
         this.serializeAs_GameRolePlayDelayedActionMessage(param1);
      }
      
      public function serializeAs_GameRolePlayDelayedActionMessage(param1:IDataOutput) : void
      {
         param1.writeInt(this.delayedCharacterId);
         param1.writeByte(this.delayTypeId);
         if(this.delayEndTime < 0)
         {
            throw new Error("Forbidden value (" + this.delayEndTime + ") on element delayEndTime.");
         }
         param1.writeDouble(this.delayEndTime);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_GameRolePlayDelayedActionMessage(param1);
      }
      
      public function deserializeAs_GameRolePlayDelayedActionMessage(param1:IDataInput) : void
      {
         this.delayedCharacterId = param1.readInt();
         this.delayTypeId = param1.readByte();
         if(this.delayTypeId < 0)
         {
            throw new Error("Forbidden value (" + this.delayTypeId + ") on element of GameRolePlayDelayedActionMessage.delayTypeId.");
         }
         this.delayEndTime = param1.readDouble();
         if(this.delayEndTime < 0)
         {
            throw new Error("Forbidden value (" + this.delayEndTime + ") on element of GameRolePlayDelayedActionMessage.delayEndTime.");
         }
      }
   }
}

