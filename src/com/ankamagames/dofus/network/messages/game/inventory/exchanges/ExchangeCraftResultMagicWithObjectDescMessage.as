package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItemNotInContainer;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class ExchangeCraftResultMagicWithObjectDescMessage extends ExchangeCraftResultWithObjectDescMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6188;
      
      private var _isInitialized:Boolean = false;
      
      public var magicPoolStatus:int = 0;
      
      public function ExchangeCraftResultMagicWithObjectDescMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6188;
      }
      
      public function initExchangeCraftResultMagicWithObjectDescMessage(param1:uint = 0, param2:ObjectItemNotInContainer = null, param3:int = 0) : ExchangeCraftResultMagicWithObjectDescMessage
      {
         super.initExchangeCraftResultWithObjectDescMessage(param1,param2);
         this.magicPoolStatus = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.magicPoolStatus = 0;
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
         this.serializeAs_ExchangeCraftResultMagicWithObjectDescMessage(param1);
      }
      
      public function serializeAs_ExchangeCraftResultMagicWithObjectDescMessage(param1:IDataOutput) : void
      {
         super.serializeAs_ExchangeCraftResultWithObjectDescMessage(param1);
         param1.writeByte(this.magicPoolStatus);
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_ExchangeCraftResultMagicWithObjectDescMessage(param1);
      }
      
      public function deserializeAs_ExchangeCraftResultMagicWithObjectDescMessage(param1:IDataInput) : void
      {
         super.deserialize(param1);
         this.magicPoolStatus = param1.readByte();
      }
   }
}

