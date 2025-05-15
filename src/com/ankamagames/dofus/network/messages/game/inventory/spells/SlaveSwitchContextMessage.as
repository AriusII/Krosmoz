package com.ankamagames.dofus.network.messages.game.inventory.spells
{
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.network.types.game.data.items.SpellItem;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class SlaveSwitchContextMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6214;
      
      private var _isInitialized:Boolean = false;
      
      public var summonerId:int = 0;
      
      public var slaveId:int = 0;
      
      public var slaveSpells:Vector.<SpellItem> = new Vector.<SpellItem>();
      
      public var slaveStats:CharacterCharacteristicsInformations = new CharacterCharacteristicsInformations();
      
      public function SlaveSwitchContextMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6214;
      }
      
      public function initSlaveSwitchContextMessage(param1:int = 0, param2:int = 0, param3:Vector.<SpellItem> = null, param4:CharacterCharacteristicsInformations = null) : SlaveSwitchContextMessage
      {
         this.summonerId = param1;
         this.slaveId = param2;
         this.slaveSpells = param3;
         this.slaveStats = param4;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.summonerId = 0;
         this.slaveId = 0;
         this.slaveSpells = new Vector.<SpellItem>();
         this.slaveStats = new CharacterCharacteristicsInformations();
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
         this.serializeAs_SlaveSwitchContextMessage(param1);
      }
      
      public function serializeAs_SlaveSwitchContextMessage(param1:IDataOutput) : void
      {
         param1.writeInt(this.summonerId);
         param1.writeInt(this.slaveId);
         param1.writeShort(this.slaveSpells.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.slaveSpells.length)
         {
            (this.slaveSpells[_loc2_] as SpellItem).serializeAs_SpellItem(param1);
            _loc2_++;
         }
         this.slaveStats.serializeAs_CharacterCharacteristicsInformations(param1);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_SlaveSwitchContextMessage(param1);
      }
      
      public function deserializeAs_SlaveSwitchContextMessage(param1:IDataInput) : void
      {
         var _loc4_:SpellItem = null;
         this.summonerId = param1.readInt();
         this.slaveId = param1.readInt();
         var _loc2_:uint = uint(param1.readUnsignedShort());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new SpellItem();
            _loc4_.deserialize(param1);
            this.slaveSpells.push(_loc4_);
            _loc3_++;
         }
         this.slaveStats = new CharacterCharacteristicsInformations();
         this.slaveStats.deserialize(param1);
      }
   }
}

