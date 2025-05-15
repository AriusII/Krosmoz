package com.ankamagames.dofus.network.messages.connection.search
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class AcquaintanceServerListMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6142;
      
      private var _isInitialized:Boolean = false;
      
      public var servers:Vector.<int> = new Vector.<int>();
      
      public function AcquaintanceServerListMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6142;
      }
      
      public function initAcquaintanceServerListMessage(param1:Vector.<int> = null) : AcquaintanceServerListMessage
      {
         this.servers = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.servers = new Vector.<int>();
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
         this.serializeAs_AcquaintanceServerListMessage(param1);
      }
      
      public function serializeAs_AcquaintanceServerListMessage(param1:IDataOutput) : void
      {
         param1.writeShort(this.servers.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.servers.length)
         {
            param1.writeShort(this.servers[_loc2_]);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_AcquaintanceServerListMessage(param1);
      }
      
      public function deserializeAs_AcquaintanceServerListMessage(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         var _loc2_:uint = uint(param1.readUnsignedShort());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = int(param1.readShort());
            this.servers.push(_loc4_);
            _loc3_++;
         }
      }
   }
}

