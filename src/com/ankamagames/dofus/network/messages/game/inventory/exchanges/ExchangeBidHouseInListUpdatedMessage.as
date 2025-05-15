package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffect;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class ExchangeBidHouseInListUpdatedMessage extends ExchangeBidHouseInListAddedMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6337;
      
      private var _isInitialized:Boolean = false;
      
      public function ExchangeBidHouseInListUpdatedMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6337;
      }
      
      public function initExchangeBidHouseInListUpdatedMessage(param1:int = 0, param2:int = 0, param3:Vector.<ObjectEffect> = null, param4:Vector.<uint> = null) : ExchangeBidHouseInListUpdatedMessage
      {
         super.initExchangeBidHouseInListAddedMessage(param1,param2,param3,param4);
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
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
         this.serializeAs_ExchangeBidHouseInListUpdatedMessage(param1);
      }
      
      public function serializeAs_ExchangeBidHouseInListUpdatedMessage(param1:IDataOutput) : void
      {
         super.serializeAs_ExchangeBidHouseInListAddedMessage(param1);
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_ExchangeBidHouseInListUpdatedMessage(param1);
      }
      
      public function deserializeAs_ExchangeBidHouseInListUpdatedMessage(param1:IDataInput) : void
      {
         super.deserialize(param1);
      }
   }
}

