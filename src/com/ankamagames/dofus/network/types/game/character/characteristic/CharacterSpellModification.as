package com.ankamagames.dofus.network.types.game.character.characteristic
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class CharacterSpellModification implements INetworkType
   {
      public static const protocolId:uint = 215;
      
      public var modificationType:uint = 0;
      
      public var spellId:uint = 0;
      
      public var value:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public function CharacterSpellModification()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 215;
      }
      
      public function initCharacterSpellModification(param1:uint = 0, param2:uint = 0, param3:CharacterBaseCharacteristic = null) : CharacterSpellModification
      {
         this.modificationType = param1;
         this.spellId = param2;
         this.value = param3;
         return this;
      }
      
      public function reset() : void
      {
         this.modificationType = 0;
         this.spellId = 0;
         this.value = new CharacterBaseCharacteristic();
      }
      
      public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_CharacterSpellModification(param1);
      }
      
      public function serializeAs_CharacterSpellModification(param1:IDataOutput) : void
      {
         param1.writeByte(this.modificationType);
         if(this.spellId < 0)
         {
            throw new Error("Forbidden value (" + this.spellId + ") on element spellId.");
         }
         param1.writeShort(this.spellId);
         this.value.serializeAs_CharacterBaseCharacteristic(param1);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_CharacterSpellModification(param1);
      }
      
      public function deserializeAs_CharacterSpellModification(param1:IDataInput) : void
      {
         this.modificationType = param1.readByte();
         if(this.modificationType < 0)
         {
            throw new Error("Forbidden value (" + this.modificationType + ") on element of CharacterSpellModification.modificationType.");
         }
         this.spellId = param1.readShort();
         if(this.spellId < 0)
         {
            throw new Error("Forbidden value (" + this.spellId + ") on element of CharacterSpellModification.spellId.");
         }
         this.value = new CharacterBaseCharacteristic();
         this.value.deserialize(param1);
      }
   }
}

