package com.ankamagames.dofus.network.types.game.prism
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.AllianceInformations;
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class AlliancePrismInformation extends PrismInformation implements INetworkType
   {
      public static const protocolId:uint = 427;
      
      public var alliance:AllianceInformations = new AllianceInformations();
      
      public function AlliancePrismInformation()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 427;
      }
      
      public function initAlliancePrismInformation(param1:uint = 0, param2:uint = 1, param3:uint = 0, param4:uint = 0, param5:AllianceInformations = null) : AlliancePrismInformation
      {
         super.initPrismInformation(param1,param2,param3,param4);
         this.alliance = param5;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.alliance = new AllianceInformations();
      }
      
      override public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_AlliancePrismInformation(param1);
      }
      
      public function serializeAs_AlliancePrismInformation(param1:IDataOutput) : void
      {
         super.serializeAs_PrismInformation(param1);
         this.alliance.serializeAs_AllianceInformations(param1);
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_AlliancePrismInformation(param1);
      }
      
      public function deserializeAs_AlliancePrismInformation(param1:IDataInput) : void
      {
         super.deserialize(param1);
         this.alliance = new AllianceInformations();
         this.alliance.deserialize(param1);
      }
   }
}

