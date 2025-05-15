package com.ankamagames.dofus.network.messages.game.inventory.storage
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class StorageObjectsRemoveMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6035;
      
      private var _isInitialized:Boolean = false;
      
      public var objectUIDList:Vector.<uint> = new Vector.<uint>();
      
      public function StorageObjectsRemoveMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6035;
      }
      
      public function initStorageObjectsRemoveMessage(param1:Vector.<uint> = null) : StorageObjectsRemoveMessage
      {
         this.objectUIDList = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.objectUIDList = new Vector.<uint>();
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
         this.serializeAs_StorageObjectsRemoveMessage(param1);
      }
      
      public function serializeAs_StorageObjectsRemoveMessage(param1:IDataOutput) : void
      {
         param1.writeShort(this.objectUIDList.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.objectUIDList.length)
         {
            if(this.objectUIDList[_loc2_] < 0)
            {
               throw new Error("Forbidden value (" + this.objectUIDList[_loc2_] + ") on element 1 (starting at 1) of objectUIDList.");
            }
            param1.writeInt(this.objectUIDList[_loc2_]);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_StorageObjectsRemoveMessage(param1);
      }
      
      public function deserializeAs_StorageObjectsRemoveMessage(param1:IDataInput) : void
      {
         var _loc4_:uint = 0;
         var _loc2_:uint = uint(param1.readUnsignedShort());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = uint(param1.readInt());
            if(_loc4_ < 0)
            {
               throw new Error("Forbidden value (" + _loc4_ + ") on elements of objectUIDList.");
            }
            this.objectUIDList.push(_loc4_);
            _loc3_++;
         }
      }
   }
}

