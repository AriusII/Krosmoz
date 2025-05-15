package com.ankamagames.dofus.network.types.game.data.items.effects
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class ObjectEffectMount extends ObjectEffect implements INetworkType
   {
      public static const protocolId:uint = 179;
      
      public var mountId:uint = 0;
      
      public var date:Number = 0;
      
      public var modelId:uint = 0;
      
      public function ObjectEffectMount()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 179;
      }
      
      public function initObjectEffectMount(param1:uint = 0, param2:uint = 0, param3:Number = 0, param4:uint = 0) : ObjectEffectMount
      {
         super.initObjectEffect(param1);
         this.mountId = param2;
         this.date = param3;
         this.modelId = param4;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.mountId = 0;
         this.date = 0;
         this.modelId = 0;
      }
      
      override public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_ObjectEffectMount(param1);
      }
      
      public function serializeAs_ObjectEffectMount(param1:IDataOutput) : void
      {
         super.serializeAs_ObjectEffect(param1);
         if(this.mountId < 0)
         {
            throw new Error("Forbidden value (" + this.mountId + ") on element mountId.");
         }
         param1.writeInt(this.mountId);
         param1.writeDouble(this.date);
         if(this.modelId < 0)
         {
            throw new Error("Forbidden value (" + this.modelId + ") on element modelId.");
         }
         param1.writeShort(this.modelId);
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_ObjectEffectMount(param1);
      }
      
      public function deserializeAs_ObjectEffectMount(param1:IDataInput) : void
      {
         super.deserialize(param1);
         this.mountId = param1.readInt();
         if(this.mountId < 0)
         {
            throw new Error("Forbidden value (" + this.mountId + ") on element of ObjectEffectMount.mountId.");
         }
         this.date = param1.readDouble();
         this.modelId = param1.readShort();
         if(this.modelId < 0)
         {
            throw new Error("Forbidden value (" + this.modelId + ") on element of ObjectEffectMount.modelId.");
         }
      }
   }
}

