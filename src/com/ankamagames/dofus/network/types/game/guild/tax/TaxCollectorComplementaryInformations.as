package com.ankamagames.dofus.network.types.game.guild.tax
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class TaxCollectorComplementaryInformations implements INetworkType
   {
      public static const protocolId:uint = 448;
      
      public function TaxCollectorComplementaryInformations()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 448;
      }
      
      public function initTaxCollectorComplementaryInformations() : TaxCollectorComplementaryInformations
      {
         return this;
      }
      
      public function reset() : void
      {
      }
      
      public function serialize(param1:IDataOutput) : void
      {
      }
      
      public function serializeAs_TaxCollectorComplementaryInformations(param1:IDataOutput) : void
      {
      }
      
      public function deserialize(param1:IDataInput) : void
      {
      }
      
      public function deserializeAs_TaxCollectorComplementaryInformations(param1:IDataInput) : void
      {
      }
   }
}

