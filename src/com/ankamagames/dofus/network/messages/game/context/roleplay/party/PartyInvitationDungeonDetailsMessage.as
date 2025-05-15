package com.ankamagames.dofus.network.messages.game.context.roleplay.party
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.party.PartyGuestInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.party.PartyInvitationMemberInformations;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class PartyInvitationDungeonDetailsMessage extends PartyInvitationDetailsMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6262;
      
      private var _isInitialized:Boolean = false;
      
      public var dungeonId:uint = 0;
      
      public var playersDungeonReady:Vector.<Boolean> = new Vector.<Boolean>();
      
      public function PartyInvitationDungeonDetailsMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6262;
      }
      
      public function initPartyInvitationDungeonDetailsMessage(param1:uint = 0, param2:uint = 0, param3:uint = 0, param4:String = "", param5:uint = 0, param6:Vector.<PartyInvitationMemberInformations> = null, param7:Vector.<PartyGuestInformations> = null, param8:uint = 0, param9:Vector.<Boolean> = null) : PartyInvitationDungeonDetailsMessage
      {
         super.initPartyInvitationDetailsMessage(param1,param2,param3,param4,param5,param6,param7);
         this.dungeonId = param8;
         this.playersDungeonReady = param9;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.dungeonId = 0;
         this.playersDungeonReady = new Vector.<Boolean>();
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
         this.serializeAs_PartyInvitationDungeonDetailsMessage(param1);
      }
      
      public function serializeAs_PartyInvitationDungeonDetailsMessage(param1:IDataOutput) : void
      {
         super.serializeAs_PartyInvitationDetailsMessage(param1);
         if(this.dungeonId < 0)
         {
            throw new Error("Forbidden value (" + this.dungeonId + ") on element dungeonId.");
         }
         param1.writeShort(this.dungeonId);
         param1.writeShort(this.playersDungeonReady.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.playersDungeonReady.length)
         {
            param1.writeBoolean(this.playersDungeonReady[_loc2_]);
            _loc2_++;
         }
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_PartyInvitationDungeonDetailsMessage(param1);
      }
      
      public function deserializeAs_PartyInvitationDungeonDetailsMessage(param1:IDataInput) : void
      {
         var _loc4_:Boolean = false;
         super.deserialize(param1);
         this.dungeonId = param1.readShort();
         if(this.dungeonId < 0)
         {
            throw new Error("Forbidden value (" + this.dungeonId + ") on element of PartyInvitationDungeonDetailsMessage.dungeonId.");
         }
         var _loc2_:uint = uint(param1.readUnsignedShort());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = Boolean(param1.readBoolean());
            this.playersDungeonReady.push(_loc4_);
            _loc3_++;
         }
      }
   }
}

