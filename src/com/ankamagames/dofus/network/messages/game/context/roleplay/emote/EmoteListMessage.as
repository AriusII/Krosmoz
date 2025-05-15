package com.ankamagames.dofus.network.messages.game.context.roleplay.emote
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class EmoteListMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5689;
      
      private var _isInitialized:Boolean = false;
      
      public var emoteIds:Vector.<uint> = new Vector.<uint>();
      
      public function EmoteListMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5689;
      }
      
      public function initEmoteListMessage(param1:Vector.<uint> = null) : EmoteListMessage
      {
         this.emoteIds = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.emoteIds = new Vector.<uint>();
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
         this.serializeAs_EmoteListMessage(param1);
      }
      
      public function serializeAs_EmoteListMessage(param1:IDataOutput) : void
      {
         param1.writeShort(this.emoteIds.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.emoteIds.length)
         {
            if(this.emoteIds[_loc2_] < 0)
            {
               throw new Error("Forbidden value (" + this.emoteIds[_loc2_] + ") on element 1 (starting at 1) of emoteIds.");
            }
            param1.writeByte(this.emoteIds[_loc2_]);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_EmoteListMessage(param1);
      }
      
      public function deserializeAs_EmoteListMessage(param1:IDataInput) : void
      {
         var _loc4_:uint = 0;
         var _loc2_:uint = uint(param1.readUnsignedShort());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = uint(param1.readByte());
            if(_loc4_ < 0)
            {
               throw new Error("Forbidden value (" + _loc4_ + ") on elements of emoteIds.");
            }
            this.emoteIds.push(_loc4_);
            _loc3_++;
         }
      }
   }
}

