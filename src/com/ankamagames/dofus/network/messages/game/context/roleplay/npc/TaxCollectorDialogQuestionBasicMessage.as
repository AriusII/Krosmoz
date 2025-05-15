package com.ankamagames.dofus.network.messages.game.context.roleplay.npc
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.BasicGuildInformations;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class TaxCollectorDialogQuestionBasicMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5619;
      
      private var _isInitialized:Boolean = false;
      
      public var guildInfo:BasicGuildInformations = new BasicGuildInformations();
      
      public function TaxCollectorDialogQuestionBasicMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5619;
      }
      
      public function initTaxCollectorDialogQuestionBasicMessage(param1:BasicGuildInformations = null) : TaxCollectorDialogQuestionBasicMessage
      {
         this.guildInfo = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
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
         this.serializeAs_TaxCollectorDialogQuestionBasicMessage(param1);
      }
      
      public function serializeAs_TaxCollectorDialogQuestionBasicMessage(param1:IDataOutput) : void
      {
         this.guildInfo.serializeAs_BasicGuildInformations(param1);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_TaxCollectorDialogQuestionBasicMessage(param1);
      }
      
      public function deserializeAs_TaxCollectorDialogQuestionBasicMessage(param1:IDataInput) : void
      {
         this.guildInfo = new BasicGuildInformations();
         this.guildInfo.deserialize(param1);
      }
   }
}

