package com.ankamagames.dofus.network.messages.game.guild
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.BasicGuildInformations;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class GuildInvitedMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5552;
      
      private var _isInitialized:Boolean = false;
      
      public var recruterId:uint = 0;
      
      public var recruterName:String = "";
      
      public var guildInfo:BasicGuildInformations = new BasicGuildInformations();
      
      public function GuildInvitedMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5552;
      }
      
      public function initGuildInvitedMessage(param1:uint = 0, param2:String = "", param3:BasicGuildInformations = null) : GuildInvitedMessage
      {
         this.recruterId = param1;
         this.recruterName = param2;
         this.guildInfo = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.recruterId = 0;
         this.recruterName = "";
         this.guildInfo = new BasicGuildInformations();
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
         this.serializeAs_GuildInvitedMessage(param1);
      }
      
      public function serializeAs_GuildInvitedMessage(param1:IDataOutput) : void
      {
         if(this.recruterId < 0)
         {
            throw new Error("Forbidden value (" + this.recruterId + ") on element recruterId.");
         }
         param1.writeInt(this.recruterId);
         param1.writeUTF(this.recruterName);
         this.guildInfo.serializeAs_BasicGuildInformations(param1);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_GuildInvitedMessage(param1);
      }
      
      public function deserializeAs_GuildInvitedMessage(param1:IDataInput) : void
      {
         this.recruterId = param1.readInt();
         if(this.recruterId < 0)
         {
            throw new Error("Forbidden value (" + this.recruterId + ") on element of GuildInvitedMessage.recruterId.");
         }
         this.recruterName = param1.readUTF();
         this.guildInfo = new BasicGuildInformations();
         this.guildInfo.deserialize(param1);
      }
   }
}

