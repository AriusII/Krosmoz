package com.ankamagames.dofus.network.types.game.context.roleplay.quest
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class QuestActiveInformations implements INetworkType
   {
      public static const protocolId:uint = 381;
      
      public var questId:uint = 0;
      
      public function QuestActiveInformations()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 381;
      }
      
      public function initQuestActiveInformations(param1:uint = 0) : QuestActiveInformations
      {
         this.questId = param1;
         return this;
      }
      
      public function reset() : void
      {
         this.questId = 0;
      }
      
      public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_QuestActiveInformations(param1);
      }
      
      public function serializeAs_QuestActiveInformations(param1:IDataOutput) : void
      {
         if(this.questId < 0)
         {
            throw new Error("Forbidden value (" + this.questId + ") on element questId.");
         }
         param1.writeShort(this.questId);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_QuestActiveInformations(param1);
      }
      
      public function deserializeAs_QuestActiveInformations(param1:IDataInput) : void
      {
         this.questId = param1.readShort();
         if(this.questId < 0)
         {
            throw new Error("Forbidden value (" + this.questId + ") on element of QuestActiveInformations.questId.");
         }
      }
   }
}

