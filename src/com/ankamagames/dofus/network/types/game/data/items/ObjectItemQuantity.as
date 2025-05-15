package com.ankamagames.dofus.network.types.game.data.items
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class ObjectItemQuantity extends Item implements INetworkType
   {
      public static const protocolId:uint = 119;
      
      public var objectUID:uint = 0;
      
      public var quantity:uint = 0;
      
      public function ObjectItemQuantity()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 119;
      }
      
      public function initObjectItemQuantity(param1:uint = 0, param2:uint = 0) : ObjectItemQuantity
      {
         this.objectUID = param1;
         this.quantity = param2;
         return this;
      }
      
      override public function reset() : void
      {
         this.objectUID = 0;
         this.quantity = 0;
      }
      
      override public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_ObjectItemQuantity(param1);
      }
      
      public function serializeAs_ObjectItemQuantity(param1:IDataOutput) : void
      {
         super.serializeAs_Item(param1);
         if(this.objectUID < 0)
         {
            throw new Error("Forbidden value (" + this.objectUID + ") on element objectUID.");
         }
         param1.writeInt(this.objectUID);
         if(this.quantity < 0)
         {
            throw new Error("Forbidden value (" + this.quantity + ") on element quantity.");
         }
         param1.writeInt(this.quantity);
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_ObjectItemQuantity(param1);
      }
      
      public function deserializeAs_ObjectItemQuantity(param1:IDataInput) : void
      {
         super.deserialize(param1);
         this.objectUID = param1.readInt();
         if(this.objectUID < 0)
         {
            throw new Error("Forbidden value (" + this.objectUID + ") on element of ObjectItemQuantity.objectUID.");
         }
         this.quantity = param1.readInt();
         if(this.quantity < 0)
         {
            throw new Error("Forbidden value (" + this.quantity + ") on element of ObjectItemQuantity.quantity.");
         }
      }
   }
}

