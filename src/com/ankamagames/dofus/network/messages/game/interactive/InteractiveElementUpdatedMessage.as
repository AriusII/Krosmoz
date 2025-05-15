package com.ankamagames.dofus.network.messages.game.interactive
{
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class InteractiveElementUpdatedMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5708;
      
      private var _isInitialized:Boolean = false;
      
      public var interactiveElement:InteractiveElement = new InteractiveElement();
      
      public function InteractiveElementUpdatedMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5708;
      }
      
      public function initInteractiveElementUpdatedMessage(param1:InteractiveElement = null) : InteractiveElementUpdatedMessage
      {
         this.interactiveElement = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.interactiveElement = new InteractiveElement();
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
         this.serializeAs_InteractiveElementUpdatedMessage(param1);
      }
      
      public function serializeAs_InteractiveElementUpdatedMessage(param1:IDataOutput) : void
      {
         this.interactiveElement.serializeAs_InteractiveElement(param1);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_InteractiveElementUpdatedMessage(param1);
      }
      
      public function deserializeAs_InteractiveElementUpdatedMessage(param1:IDataInput) : void
      {
         this.interactiveElement = new InteractiveElement();
         this.interactiveElement.deserialize(param1);
      }
   }
}

