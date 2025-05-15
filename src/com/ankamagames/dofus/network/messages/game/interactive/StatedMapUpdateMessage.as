package com.ankamagames.dofus.network.messages.game.interactive
{
   import com.ankamagames.dofus.network.types.game.interactive.StatedElement;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class StatedMapUpdateMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5716;
      
      private var _isInitialized:Boolean = false;
      
      public var statedElements:Vector.<StatedElement> = new Vector.<StatedElement>();
      
      public function StatedMapUpdateMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5716;
      }
      
      public function initStatedMapUpdateMessage(param1:Vector.<StatedElement> = null) : StatedMapUpdateMessage
      {
         this.statedElements = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.statedElements = new Vector.<StatedElement>();
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
         this.serializeAs_StatedMapUpdateMessage(param1);
      }
      
      public function serializeAs_StatedMapUpdateMessage(param1:IDataOutput) : void
      {
         param1.writeShort(this.statedElements.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.statedElements.length)
         {
            (this.statedElements[_loc2_] as StatedElement).serializeAs_StatedElement(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_StatedMapUpdateMessage(param1);
      }
      
      public function deserializeAs_StatedMapUpdateMessage(param1:IDataInput) : void
      {
         var _loc4_:StatedElement = null;
         var _loc2_:uint = uint(param1.readUnsignedShort());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new StatedElement();
            _loc4_.deserialize(param1);
            this.statedElements.push(_loc4_);
            _loc3_++;
         }
      }
   }
}

