package com.ankamagames.dofus.network.types.game.context
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.AllianceInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GuildInformations;
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class TaxCollectorStaticExtendedInformations extends TaxCollectorStaticInformations implements INetworkType
   {
      public static const protocolId:uint = 440;
      
      public var allianceIdentity:AllianceInformations = new AllianceInformations();
      
      public function TaxCollectorStaticExtendedInformations()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 440;
      }
      
      public function initTaxCollectorStaticExtendedInformations(param1:uint = 0, param2:uint = 0, param3:GuildInformations = null, param4:AllianceInformations = null) : TaxCollectorStaticExtendedInformations
      {
         super.initTaxCollectorStaticInformations(param1,param2,param3);
         this.allianceIdentity = param4;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.allianceIdentity = new AllianceInformations();
      }
      
      override public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_TaxCollectorStaticExtendedInformations(param1);
      }
      
      public function serializeAs_TaxCollectorStaticExtendedInformations(param1:IDataOutput) : void
      {
         super.serializeAs_TaxCollectorStaticInformations(param1);
         this.allianceIdentity.serializeAs_AllianceInformations(param1);
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_TaxCollectorStaticExtendedInformations(param1);
      }
      
      public function deserializeAs_TaxCollectorStaticExtendedInformations(param1:IDataInput) : void
      {
         super.deserialize(param1);
         this.allianceIdentity = new AllianceInformations();
         this.allianceIdentity.deserialize(param1);
      }
   }
}

