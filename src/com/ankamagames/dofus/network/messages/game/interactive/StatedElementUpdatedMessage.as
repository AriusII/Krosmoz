package com.ankamagames.dofus.network.messages.game.interactive
{
   import com.ankamagames.dofus.network.types.game.interactive.StatedElement;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class StatedElementUpdatedMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5709;
      
      private var _isInitialized:Boolean = false;
      
      public var statedElement:StatedElement = new StatedElement();
      
      public function StatedElementUpdatedMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5709;
      }
      
      public function initStatedElementUpdatedMessage(param1:StatedElement = null) : StatedElementUpdatedMessage
      {
         this.statedElement = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.statedElement = new StatedElement();
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
         this.serializeAs_StatedElementUpdatedMessage(param1);
      }
      
      public function serializeAs_StatedElementUpdatedMessage(param1:IDataOutput) : void
      {
         this.statedElement.serializeAs_StatedElement(param1);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_StatedElementUpdatedMessage(param1);
      }
      
      public function deserializeAs_StatedElementUpdatedMessage(param1:IDataInput) : void
      {
         this.statedElement = new StatedElement();
         this.statedElement.deserialize(param1);
      }
   }
}

