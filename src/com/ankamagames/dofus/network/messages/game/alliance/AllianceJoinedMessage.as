package com.ankamagames.dofus.network.messages.game.alliance
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.AllianceInformations;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class AllianceJoinedMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6402;
      
      private var _isInitialized:Boolean = false;
      
      public var allianceInfo:AllianceInformations = new AllianceInformations();
      
      public var enabled:Boolean = false;
      
      public function AllianceJoinedMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6402;
      }
      
      public function initAllianceJoinedMessage(param1:AllianceInformations = null, param2:Boolean = false) : AllianceJoinedMessage
      {
         this.allianceInfo = param1;
         this.enabled = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.allianceInfo = new AllianceInformations();
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
         this.serializeAs_AllianceJoinedMessage(param1);
      }
      
      public function serializeAs_AllianceJoinedMessage(param1:IDataOutput) : void
      {
         this.allianceInfo.serializeAs_AllianceInformations(param1);
         param1.writeBoolean(this.enabled);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_AllianceJoinedMessage(param1);
      }
      
      public function deserializeAs_AllianceJoinedMessage(param1:IDataInput) : void
      {
         this.allianceInfo = new AllianceInformations();
         this.allianceInfo.deserialize(param1);
         this.enabled = param1.readBoolean();
      }
   }
}

