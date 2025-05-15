package com.ankamagames.dofus.network.messages.game.alliance
{
   import com.ankamagames.dofus.network.types.game.guild.GuildEmblem;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class AllianceModificationEmblemValidMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6447;
      
      private var _isInitialized:Boolean = false;
      
      public var Alliancemblem:GuildEmblem = new GuildEmblem();
      
      public function AllianceModificationEmblemValidMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6447;
      }
      
      public function initAllianceModificationEmblemValidMessage(param1:GuildEmblem = null) : AllianceModificationEmblemValidMessage
      {
         this.Alliancemblem = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.Alliancemblem = new GuildEmblem();
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
         this.serializeAs_AllianceModificationEmblemValidMessage(param1);
      }
      
      public function serializeAs_AllianceModificationEmblemValidMessage(param1:IDataOutput) : void
      {
         this.Alliancemblem.serializeAs_GuildEmblem(param1);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_AllianceModificationEmblemValidMessage(param1);
      }
      
      public function deserializeAs_AllianceModificationEmblemValidMessage(param1:IDataInput) : void
      {
         this.Alliancemblem = new GuildEmblem();
         this.Alliancemblem.deserialize(param1);
      }
   }
}

