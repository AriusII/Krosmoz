package com.ankamagames.dofus.network.messages.game.context.mount
{
   import com.ankamagames.dofus.network.types.game.paddock.PaddockItem;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class GameDataPaddockObjectListAddMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5992;
      
      private var _isInitialized:Boolean = false;
      
      public var paddockItemDescription:Vector.<PaddockItem> = new Vector.<PaddockItem>();
      
      public function GameDataPaddockObjectListAddMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5992;
      }
      
      public function initGameDataPaddockObjectListAddMessage(param1:Vector.<PaddockItem> = null) : GameDataPaddockObjectListAddMessage
      {
         this.paddockItemDescription = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.paddockItemDescription = new Vector.<PaddockItem>();
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
         this.serializeAs_GameDataPaddockObjectListAddMessage(param1);
      }
      
      public function serializeAs_GameDataPaddockObjectListAddMessage(param1:IDataOutput) : void
      {
         param1.writeShort(this.paddockItemDescription.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.paddockItemDescription.length)
         {
            (this.paddockItemDescription[_loc2_] as PaddockItem).serializeAs_PaddockItem(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_GameDataPaddockObjectListAddMessage(param1);
      }
      
      public function deserializeAs_GameDataPaddockObjectListAddMessage(param1:IDataInput) : void
      {
         var _loc4_:PaddockItem = null;
         var _loc2_:uint = uint(param1.readUnsignedShort());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new PaddockItem();
            _loc4_.deserialize(param1);
            this.paddockItemDescription.push(_loc4_);
            _loc3_++;
         }
      }
   }
}

