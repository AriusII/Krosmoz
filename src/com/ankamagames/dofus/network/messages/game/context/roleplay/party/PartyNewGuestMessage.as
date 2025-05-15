package com.ankamagames.dofus.network.messages.game.context.roleplay.party
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.party.PartyGuestInformations;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class PartyNewGuestMessage extends AbstractPartyEventMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6260;
      
      private var _isInitialized:Boolean = false;
      
      public var guest:PartyGuestInformations = new PartyGuestInformations();
      
      public function PartyNewGuestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6260;
      }
      
      public function initPartyNewGuestMessage(param1:uint = 0, param2:PartyGuestInformations = null) : PartyNewGuestMessage
      {
         super.initAbstractPartyEventMessage(param1);
         this.guest = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.guest = new PartyGuestInformations();
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
         this.serializeAs_PartyNewGuestMessage(param1);
      }
      
      public function serializeAs_PartyNewGuestMessage(param1:IDataOutput) : void
      {
         super.serializeAs_AbstractPartyEventMessage(param1);
         this.guest.serializeAs_PartyGuestInformations(param1);
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_PartyNewGuestMessage(param1);
      }
      
      public function deserializeAs_PartyNewGuestMessage(param1:IDataInput) : void
      {
         super.deserialize(param1);
         this.guest = new PartyGuestInformations();
         this.guest.deserialize(param1);
      }
   }
}

