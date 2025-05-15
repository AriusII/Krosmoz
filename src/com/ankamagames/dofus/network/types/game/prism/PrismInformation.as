package com.ankamagames.dofus.network.types.game.prism
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class PrismInformation implements INetworkType
   {
      public static const protocolId:uint = 428;
      
      public var typeId:uint = 0;
      
      public var state:uint = 1;
      
      public var nextVulnerabilityDate:uint = 0;
      
      public var placementDate:uint = 0;
      
      public function PrismInformation()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 428;
      }
      
      public function initPrismInformation(param1:uint = 0, param2:uint = 1, param3:uint = 0, param4:uint = 0) : PrismInformation
      {
         this.typeId = param1;
         this.state = param2;
         this.nextVulnerabilityDate = param3;
         this.placementDate = param4;
         return this;
      }
      
      public function reset() : void
      {
         this.typeId = 0;
         this.state = 1;
         this.nextVulnerabilityDate = 0;
         this.placementDate = 0;
      }
      
      public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_PrismInformation(param1);
      }
      
      public function serializeAs_PrismInformation(param1:IDataOutput) : void
      {
         if(this.typeId < 0)
         {
            throw new Error("Forbidden value (" + this.typeId + ") on element typeId.");
         }
         param1.writeByte(this.typeId);
         param1.writeByte(this.state);
         if(this.nextVulnerabilityDate < 0)
         {
            throw new Error("Forbidden value (" + this.nextVulnerabilityDate + ") on element nextVulnerabilityDate.");
         }
         param1.writeInt(this.nextVulnerabilityDate);
         if(this.placementDate < 0)
         {
            throw new Error("Forbidden value (" + this.placementDate + ") on element placementDate.");
         }
         param1.writeInt(this.placementDate);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_PrismInformation(param1);
      }
      
      public function deserializeAs_PrismInformation(param1:IDataInput) : void
      {
         this.typeId = param1.readByte();
         if(this.typeId < 0)
         {
            throw new Error("Forbidden value (" + this.typeId + ") on element of PrismInformation.typeId.");
         }
         this.state = param1.readByte();
         if(this.state < 0)
         {
            throw new Error("Forbidden value (" + this.state + ") on element of PrismInformation.state.");
         }
         this.nextVulnerabilityDate = param1.readInt();
         if(this.nextVulnerabilityDate < 0)
         {
            throw new Error("Forbidden value (" + this.nextVulnerabilityDate + ") on element of PrismInformation.nextVulnerabilityDate.");
         }
         this.placementDate = param1.readInt();
         if(this.placementDate < 0)
         {
            throw new Error("Forbidden value (" + this.placementDate + ") on element of PrismInformation.placementDate.");
         }
      }
   }
}

