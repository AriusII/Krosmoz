package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.dofus.network.types.game.mount.MountClientData;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class ExchangeStartOkMountMessage extends ExchangeStartOkMountWithOutPaddockMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5979;
      
      private var _isInitialized:Boolean = false;
      
      public var paddockedMountsDescription:Vector.<MountClientData> = new Vector.<MountClientData>();
      
      public function ExchangeStartOkMountMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5979;
      }
      
      public function initExchangeStartOkMountMessage(param1:Vector.<MountClientData> = null, param2:Vector.<MountClientData> = null) : ExchangeStartOkMountMessage
      {
         super.initExchangeStartOkMountWithOutPaddockMessage(param1);
         this.paddockedMountsDescription = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.paddockedMountsDescription = new Vector.<MountClientData>();
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
         this.serializeAs_ExchangeStartOkMountMessage(param1);
      }
      
      public function serializeAs_ExchangeStartOkMountMessage(param1:IDataOutput) : void
      {
         super.serializeAs_ExchangeStartOkMountWithOutPaddockMessage(param1);
         param1.writeShort(this.paddockedMountsDescription.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.paddockedMountsDescription.length)
         {
            (this.paddockedMountsDescription[_loc2_] as MountClientData).serializeAs_MountClientData(param1);
            _loc2_++;
         }
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_ExchangeStartOkMountMessage(param1);
      }
      
      public function deserializeAs_ExchangeStartOkMountMessage(param1:IDataInput) : void
      {
         var _loc4_:MountClientData = null;
         super.deserialize(param1);
         var _loc2_:uint = uint(param1.readUnsignedShort());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new MountClientData();
            _loc4_.deserialize(param1);
            this.paddockedMountsDescription.push(_loc4_);
            _loc3_++;
         }
      }
   }
}

