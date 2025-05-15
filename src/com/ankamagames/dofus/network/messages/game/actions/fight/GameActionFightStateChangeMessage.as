package com.ankamagames.dofus.network.messages.game.actions.fight
{
   import com.ankamagames.dofus.network.messages.game.actions.AbstractGameActionMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class GameActionFightStateChangeMessage extends AbstractGameActionMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5569;
      
      private var _isInitialized:Boolean = false;
      
      public var targetId:int = 0;
      
      public var stateId:int = 0;
      
      public var active:Boolean = false;
      
      public function GameActionFightStateChangeMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5569;
      }
      
      public function initGameActionFightStateChangeMessage(param1:uint = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:Boolean = false) : GameActionFightStateChangeMessage
      {
         super.initAbstractGameActionMessage(param1,param2);
         this.targetId = param3;
         this.stateId = param4;
         this.active = param5;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.targetId = 0;
         this.stateId = 0;
         this.active = false;
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
         this.serializeAs_GameActionFightStateChangeMessage(param1);
      }
      
      public function serializeAs_GameActionFightStateChangeMessage(param1:IDataOutput) : void
      {
         super.serializeAs_AbstractGameActionMessage(param1);
         param1.writeInt(this.targetId);
         param1.writeShort(this.stateId);
         param1.writeBoolean(this.active);
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_GameActionFightStateChangeMessage(param1);
      }
      
      public function deserializeAs_GameActionFightStateChangeMessage(param1:IDataInput) : void
      {
         super.deserialize(param1);
         this.targetId = param1.readInt();
         this.stateId = param1.readShort();
         this.active = param1.readBoolean();
      }
   }
}

