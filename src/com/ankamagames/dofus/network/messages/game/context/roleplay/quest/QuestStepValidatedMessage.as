package com.ankamagames.dofus.network.messages.game.context.roleplay.quest
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class QuestStepValidatedMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6099;
      
      private var _isInitialized:Boolean = false;
      
      public var questId:uint = 0;
      
      public var stepId:uint = 0;
      
      public function QuestStepValidatedMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6099;
      }
      
      public function initQuestStepValidatedMessage(param1:uint = 0, param2:uint = 0) : QuestStepValidatedMessage
      {
         this.questId = param1;
         this.stepId = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.questId = 0;
         this.stepId = 0;
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
         this.serializeAs_QuestStepValidatedMessage(param1);
      }
      
      public function serializeAs_QuestStepValidatedMessage(param1:IDataOutput) : void
      {
         if(this.questId < 0 || this.questId > 65535)
         {
            throw new Error("Forbidden value (" + this.questId + ") on element questId.");
         }
         param1.writeShort(this.questId);
         if(this.stepId < 0 || this.stepId > 65535)
         {
            throw new Error("Forbidden value (" + this.stepId + ") on element stepId.");
         }
         param1.writeShort(this.stepId);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_QuestStepValidatedMessage(param1);
      }
      
      public function deserializeAs_QuestStepValidatedMessage(param1:IDataInput) : void
      {
         this.questId = param1.readUnsignedShort();
         if(this.questId < 0 || this.questId > 65535)
         {
            throw new Error("Forbidden value (" + this.questId + ") on element of QuestStepValidatedMessage.questId.");
         }
         this.stepId = param1.readUnsignedShort();
         if(this.stepId < 0 || this.stepId > 65535)
         {
            throw new Error("Forbidden value (" + this.stepId + ") on element of QuestStepValidatedMessage.stepId.");
         }
      }
   }
}

