package com.ankamagames.dofus.network.messages.game.context.roleplay.spell
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class SpellItemBoostMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6011;
      
      private var _isInitialized:Boolean = false;
      
      public var statId:uint = 0;
      
      public var spellId:uint = 0;
      
      public var value:int = 0;
      
      public function SpellItemBoostMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6011;
      }
      
      public function initSpellItemBoostMessage(param1:uint = 0, param2:uint = 0, param3:int = 0) : SpellItemBoostMessage
      {
         this.statId = param1;
         this.spellId = param2;
         this.value = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.statId = 0;
         this.spellId = 0;
         this.value = 0;
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
         this.serializeAs_SpellItemBoostMessage(param1);
      }
      
      public function serializeAs_SpellItemBoostMessage(param1:IDataOutput) : void
      {
         if(this.statId < 0)
         {
            throw new Error("Forbidden value (" + this.statId + ") on element statId.");
         }
         param1.writeInt(this.statId);
         if(this.spellId < 0)
         {
            throw new Error("Forbidden value (" + this.spellId + ") on element spellId.");
         }
         param1.writeShort(this.spellId);
         param1.writeShort(this.value);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_SpellItemBoostMessage(param1);
      }
      
      public function deserializeAs_SpellItemBoostMessage(param1:IDataInput) : void
      {
         this.statId = param1.readInt();
         if(this.statId < 0)
         {
            throw new Error("Forbidden value (" + this.statId + ") on element of SpellItemBoostMessage.statId.");
         }
         this.spellId = param1.readShort();
         if(this.spellId < 0)
         {
            throw new Error("Forbidden value (" + this.spellId + ") on element of SpellItemBoostMessage.spellId.");
         }
         this.value = param1.readShort();
      }
   }
}

