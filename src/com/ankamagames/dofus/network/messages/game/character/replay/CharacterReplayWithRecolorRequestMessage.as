package com.ankamagames.dofus.network.messages.game.character.replay
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class CharacterReplayWithRecolorRequestMessage extends CharacterReplayRequestMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6111;
      
      private var _isInitialized:Boolean = false;
      
      public var indexedColor:Vector.<int> = new Vector.<int>();
      
      public function CharacterReplayWithRecolorRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6111;
      }
      
      public function initCharacterReplayWithRecolorRequestMessage(param1:uint = 0, param2:Vector.<int> = null) : CharacterReplayWithRecolorRequestMessage
      {
         super.initCharacterReplayRequestMessage(param1);
         this.indexedColor = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.indexedColor = new Vector.<int>();
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
         this.serializeAs_CharacterReplayWithRecolorRequestMessage(param1);
      }
      
      public function serializeAs_CharacterReplayWithRecolorRequestMessage(param1:IDataOutput) : void
      {
         super.serializeAs_CharacterReplayRequestMessage(param1);
         param1.writeShort(this.indexedColor.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.indexedColor.length)
         {
            param1.writeInt(this.indexedColor[_loc2_]);
            _loc2_++;
         }
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_CharacterReplayWithRecolorRequestMessage(param1);
      }
      
      public function deserializeAs_CharacterReplayWithRecolorRequestMessage(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         super.deserialize(param1);
         var _loc2_:uint = uint(param1.readUnsignedShort());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = int(param1.readInt());
            this.indexedColor.push(_loc4_);
            _loc3_++;
         }
      }
   }
}

