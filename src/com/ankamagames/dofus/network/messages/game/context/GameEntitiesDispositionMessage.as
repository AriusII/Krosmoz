package com.ankamagames.dofus.network.messages.game.context
{
   import com.ankamagames.dofus.network.types.game.context.IdentifiedEntityDispositionInformations;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class GameEntitiesDispositionMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5696;
      
      private var _isInitialized:Boolean = false;
      
      public var dispositions:Vector.<IdentifiedEntityDispositionInformations> = new Vector.<IdentifiedEntityDispositionInformations>();
      
      public function GameEntitiesDispositionMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5696;
      }
      
      public function initGameEntitiesDispositionMessage(param1:Vector.<IdentifiedEntityDispositionInformations> = null) : GameEntitiesDispositionMessage
      {
         this.dispositions = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.dispositions = new Vector.<IdentifiedEntityDispositionInformations>();
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
         this.serializeAs_GameEntitiesDispositionMessage(param1);
      }
      
      public function serializeAs_GameEntitiesDispositionMessage(param1:IDataOutput) : void
      {
         param1.writeShort(this.dispositions.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.dispositions.length)
         {
            (this.dispositions[_loc2_] as IdentifiedEntityDispositionInformations).serializeAs_IdentifiedEntityDispositionInformations(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_GameEntitiesDispositionMessage(param1);
      }
      
      public function deserializeAs_GameEntitiesDispositionMessage(param1:IDataInput) : void
      {
         var _loc4_:IdentifiedEntityDispositionInformations = null;
         var _loc2_:uint = uint(param1.readUnsignedShort());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new IdentifiedEntityDispositionInformations();
            _loc4_.deserialize(param1);
            this.dispositions.push(_loc4_);
            _loc3_++;
         }
      }
   }
}

