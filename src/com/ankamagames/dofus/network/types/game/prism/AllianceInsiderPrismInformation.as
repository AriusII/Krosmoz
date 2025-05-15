package com.ankamagames.dofus.network.types.game.prism
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class AllianceInsiderPrismInformation extends PrismInformation implements INetworkType
   {
      public static const protocolId:uint = 431;
      
      public var lastTimeSlotModificationDate:uint = 0;
      
      public var lastTimeSlotModificationAuthorGuildId:uint = 0;
      
      public var lastTimeSlotModificationAuthorId:uint = 0;
      
      public var lastTimeSlotModificationAuthorName:String = "";
      
      public var hasTeleporterModule:Boolean = false;
      
      public function AllianceInsiderPrismInformation()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 431;
      }
      
      public function initAllianceInsiderPrismInformation(param1:uint = 0, param2:uint = 1, param3:uint = 0, param4:uint = 0, param5:uint = 0, param6:uint = 0, param7:uint = 0, param8:String = "", param9:Boolean = false) : AllianceInsiderPrismInformation
      {
         super.initPrismInformation(param1,param2,param3,param4);
         this.lastTimeSlotModificationDate = param5;
         this.lastTimeSlotModificationAuthorGuildId = param6;
         this.lastTimeSlotModificationAuthorId = param7;
         this.lastTimeSlotModificationAuthorName = param8;
         this.hasTeleporterModule = param9;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.lastTimeSlotModificationDate = 0;
         this.lastTimeSlotModificationAuthorGuildId = 0;
         this.lastTimeSlotModificationAuthorId = 0;
         this.lastTimeSlotModificationAuthorName = "";
         this.hasTeleporterModule = false;
      }
      
      override public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_AllianceInsiderPrismInformation(param1);
      }
      
      public function serializeAs_AllianceInsiderPrismInformation(param1:IDataOutput) : void
      {
         super.serializeAs_PrismInformation(param1);
         if(this.lastTimeSlotModificationDate < 0)
         {
            throw new Error("Forbidden value (" + this.lastTimeSlotModificationDate + ") on element lastTimeSlotModificationDate.");
         }
         param1.writeInt(this.lastTimeSlotModificationDate);
         if(this.lastTimeSlotModificationAuthorGuildId < 0)
         {
            throw new Error("Forbidden value (" + this.lastTimeSlotModificationAuthorGuildId + ") on element lastTimeSlotModificationAuthorGuildId.");
         }
         param1.writeInt(this.lastTimeSlotModificationAuthorGuildId);
         if(this.lastTimeSlotModificationAuthorId < 0)
         {
            throw new Error("Forbidden value (" + this.lastTimeSlotModificationAuthorId + ") on element lastTimeSlotModificationAuthorId.");
         }
         param1.writeInt(this.lastTimeSlotModificationAuthorId);
         param1.writeUTF(this.lastTimeSlotModificationAuthorName);
         param1.writeBoolean(this.hasTeleporterModule);
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_AllianceInsiderPrismInformation(param1);
      }
      
      public function deserializeAs_AllianceInsiderPrismInformation(param1:IDataInput) : void
      {
         super.deserialize(param1);
         this.lastTimeSlotModificationDate = param1.readInt();
         if(this.lastTimeSlotModificationDate < 0)
         {
            throw new Error("Forbidden value (" + this.lastTimeSlotModificationDate + ") on element of AllianceInsiderPrismInformation.lastTimeSlotModificationDate.");
         }
         this.lastTimeSlotModificationAuthorGuildId = param1.readInt();
         if(this.lastTimeSlotModificationAuthorGuildId < 0)
         {
            throw new Error("Forbidden value (" + this.lastTimeSlotModificationAuthorGuildId + ") on element of AllianceInsiderPrismInformation.lastTimeSlotModificationAuthorGuildId.");
         }
         this.lastTimeSlotModificationAuthorId = param1.readInt();
         if(this.lastTimeSlotModificationAuthorId < 0)
         {
            throw new Error("Forbidden value (" + this.lastTimeSlotModificationAuthorId + ") on element of AllianceInsiderPrismInformation.lastTimeSlotModificationAuthorId.");
         }
         this.lastTimeSlotModificationAuthorName = param1.readUTF();
         this.hasTeleporterModule = param1.readBoolean();
      }
   }
}

