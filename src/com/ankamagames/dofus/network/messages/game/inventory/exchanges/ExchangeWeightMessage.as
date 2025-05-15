package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class ExchangeWeightMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5793;
      
      private var _isInitialized:Boolean = false;
      
      public var currentWeight:uint = 0;
      
      public var maxWeight:uint = 0;
      
      public function ExchangeWeightMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5793;
      }
      
      public function initExchangeWeightMessage(param1:uint = 0, param2:uint = 0) : ExchangeWeightMessage
      {
         this.currentWeight = param1;
         this.maxWeight = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.currentWeight = 0;
         this.maxWeight = 0;
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
         this.serializeAs_ExchangeWeightMessage(param1);
      }
      
      public function serializeAs_ExchangeWeightMessage(param1:IDataOutput) : void
      {
         if(this.currentWeight < 0)
         {
            throw new Error("Forbidden value (" + this.currentWeight + ") on element currentWeight.");
         }
         param1.writeInt(this.currentWeight);
         if(this.maxWeight < 0)
         {
            throw new Error("Forbidden value (" + this.maxWeight + ") on element maxWeight.");
         }
         param1.writeInt(this.maxWeight);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_ExchangeWeightMessage(param1);
      }
      
      public function deserializeAs_ExchangeWeightMessage(param1:IDataInput) : void
      {
         this.currentWeight = param1.readInt();
         if(this.currentWeight < 0)
         {
            throw new Error("Forbidden value (" + this.currentWeight + ") on element of ExchangeWeightMessage.currentWeight.");
         }
         this.maxWeight = param1.readInt();
         if(this.maxWeight < 0)
         {
            throw new Error("Forbidden value (" + this.maxWeight + ") on element of ExchangeWeightMessage.maxWeight.");
         }
      }
   }
}

