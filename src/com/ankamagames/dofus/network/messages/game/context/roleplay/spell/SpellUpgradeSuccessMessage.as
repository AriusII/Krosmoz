package com.ankamagames.dofus.network.messages.game.context.roleplay.spell
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class SpellUpgradeSuccessMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 1201;
      
      private var _isInitialized:Boolean = false;
      
      public var spellId:int = 0;
      
      public var spellLevel:uint = 0;
      
      public function SpellUpgradeSuccessMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 1201;
      }
      
      public function initSpellUpgradeSuccessMessage(param1:int = 0, param2:uint = 0) : SpellUpgradeSuccessMessage
      {
         this.spellId = param1;
         this.spellLevel = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.spellId = 0;
         this.spellLevel = 0;
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
         this.serializeAs_SpellUpgradeSuccessMessage(param1);
      }
      
      public function serializeAs_SpellUpgradeSuccessMessage(param1:IDataOutput) : void
      {
         param1.writeInt(this.spellId);
         if(this.spellLevel < 1 || this.spellLevel > 6)
         {
            throw new Error("Forbidden value (" + this.spellLevel + ") on element spellLevel.");
         }
         param1.writeByte(this.spellLevel);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_SpellUpgradeSuccessMessage(param1);
      }
      
      public function deserializeAs_SpellUpgradeSuccessMessage(param1:IDataInput) : void
      {
         this.spellId = param1.readInt();
         this.spellLevel = param1.readByte();
         if(this.spellLevel < 1 || this.spellLevel > 6)
         {
            throw new Error("Forbidden value (" + this.spellLevel + ") on element of SpellUpgradeSuccessMessage.spellLevel.");
         }
      }
   }
}

