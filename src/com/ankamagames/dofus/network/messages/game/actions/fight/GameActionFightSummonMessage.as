package com.ankamagames.dofus.network.messages.game.actions.fight
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.messages.game.actions.AbstractGameActionMessage;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class GameActionFightSummonMessage extends AbstractGameActionMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5825;
      
      private var _isInitialized:Boolean = false;
      
      public var summon:GameFightFighterInformations = new GameFightFighterInformations();
      
      public function GameActionFightSummonMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5825;
      }
      
      public function initGameActionFightSummonMessage(param1:uint = 0, param2:int = 0, param3:GameFightFighterInformations = null) : GameActionFightSummonMessage
      {
         super.initAbstractGameActionMessage(param1,param2);
         this.summon = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.summon = new GameFightFighterInformations();
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
         this.serializeAs_GameActionFightSummonMessage(param1);
      }
      
      public function serializeAs_GameActionFightSummonMessage(param1:IDataOutput) : void
      {
         super.serializeAs_AbstractGameActionMessage(param1);
         param1.writeShort(this.summon.getTypeId());
         this.summon.serialize(param1);
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_GameActionFightSummonMessage(param1);
      }
      
      public function deserializeAs_GameActionFightSummonMessage(param1:IDataInput) : void
      {
         super.deserialize(param1);
         var _loc2_:uint = uint(param1.readUnsignedShort());
         this.summon = ProtocolTypeManager.getInstance(GameFightFighterInformations,_loc2_);
         this.summon.deserialize(param1);
      }
   }
}

