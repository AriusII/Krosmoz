package com.ankamagames.dofus.network.messages.game.context.roleplay.quest
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.context.roleplay.quest.QuestActiveInformations;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class QuestStepInfoMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5625;
      
      private var _isInitialized:Boolean = false;
      
      public var infos:QuestActiveInformations = new QuestActiveInformations();
      
      public function QuestStepInfoMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5625;
      }
      
      public function initQuestStepInfoMessage(param1:QuestActiveInformations = null) : QuestStepInfoMessage
      {
         this.infos = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.infos = new QuestActiveInformations();
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
         this.serializeAs_QuestStepInfoMessage(param1);
      }
      
      public function serializeAs_QuestStepInfoMessage(param1:IDataOutput) : void
      {
         param1.writeShort(this.infos.getTypeId());
         this.infos.serialize(param1);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_QuestStepInfoMessage(param1);
      }
      
      public function deserializeAs_QuestStepInfoMessage(param1:IDataInput) : void
      {
         var _loc2_:uint = uint(param1.readUnsignedShort());
         this.infos = ProtocolTypeManager.getInstance(QuestActiveInformations,_loc2_);
         this.infos.deserialize(param1);
      }
   }
}

