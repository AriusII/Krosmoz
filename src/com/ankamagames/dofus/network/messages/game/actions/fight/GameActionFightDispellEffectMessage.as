package com.ankamagames.dofus.network.messages.game.actions.fight
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class GameActionFightDispellEffectMessage extends GameActionFightDispellMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6113;
      
      private var _isInitialized:Boolean = false;
      
      public var boostUID:uint = 0;
      
      public function GameActionFightDispellEffectMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6113;
      }
      
      public function initGameActionFightDispellEffectMessage(param1:uint = 0, param2:int = 0, param3:int = 0, param4:uint = 0) : GameActionFightDispellEffectMessage
      {
         super.initGameActionFightDispellMessage(param1,param2,param3);
         this.boostUID = param4;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.boostUID = 0;
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
         this.serializeAs_GameActionFightDispellEffectMessage(param1);
      }
      
      public function serializeAs_GameActionFightDispellEffectMessage(param1:IDataOutput) : void
      {
         super.serializeAs_GameActionFightDispellMessage(param1);
         if(this.boostUID < 0)
         {
            throw new Error("Forbidden value (" + this.boostUID + ") on element boostUID.");
         }
         param1.writeInt(this.boostUID);
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_GameActionFightDispellEffectMessage(param1);
      }
      
      public function deserializeAs_GameActionFightDispellEffectMessage(param1:IDataInput) : void
      {
         super.deserialize(param1);
         this.boostUID = param1.readInt();
         if(this.boostUID < 0)
         {
            throw new Error("Forbidden value (" + this.boostUID + ") on element of GameActionFightDispellEffectMessage.boostUID.");
         }
      }
   }
}

