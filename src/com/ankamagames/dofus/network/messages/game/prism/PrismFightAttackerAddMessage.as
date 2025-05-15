package com.ankamagames.dofus.network.messages.game.prism
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.character.CharacterMinimalPlusLookInformations;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class PrismFightAttackerAddMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5893;
      
      private var _isInitialized:Boolean = false;
      
      public var subAreaId:uint = 0;
      
      public var fightId:Number = 0;
      
      public var attacker:CharacterMinimalPlusLookInformations = new CharacterMinimalPlusLookInformations();
      
      public function PrismFightAttackerAddMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5893;
      }
      
      public function initPrismFightAttackerAddMessage(param1:uint = 0, param2:Number = 0, param3:CharacterMinimalPlusLookInformations = null) : PrismFightAttackerAddMessage
      {
         this.subAreaId = param1;
         this.fightId = param2;
         this.attacker = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.subAreaId = 0;
         this.fightId = 0;
         this.attacker = new CharacterMinimalPlusLookInformations();
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
         this.serializeAs_PrismFightAttackerAddMessage(param1);
      }
      
      public function serializeAs_PrismFightAttackerAddMessage(param1:IDataOutput) : void
      {
         if(this.subAreaId < 0)
         {
            throw new Error("Forbidden value (" + this.subAreaId + ") on element subAreaId.");
         }
         param1.writeShort(this.subAreaId);
         param1.writeDouble(this.fightId);
         param1.writeShort(this.attacker.getTypeId());
         this.attacker.serialize(param1);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_PrismFightAttackerAddMessage(param1);
      }
      
      public function deserializeAs_PrismFightAttackerAddMessage(param1:IDataInput) : void
      {
         this.subAreaId = param1.readShort();
         if(this.subAreaId < 0)
         {
            throw new Error("Forbidden value (" + this.subAreaId + ") on element of PrismFightAttackerAddMessage.subAreaId.");
         }
         this.fightId = param1.readDouble();
         var _loc2_:uint = uint(param1.readUnsignedShort());
         this.attacker = ProtocolTypeManager.getInstance(CharacterMinimalPlusLookInformations,_loc2_);
         this.attacker.deserialize(param1);
      }
   }
}

