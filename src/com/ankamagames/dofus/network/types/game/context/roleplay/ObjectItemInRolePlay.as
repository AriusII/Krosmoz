package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class ObjectItemInRolePlay implements INetworkType
   {
      public static const protocolId:uint = 198;
      
      public var cellId:uint = 0;
      
      public var objectGID:uint = 0;
      
      public function ObjectItemInRolePlay()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 198;
      }
      
      public function initObjectItemInRolePlay(param1:uint = 0, param2:uint = 0) : ObjectItemInRolePlay
      {
         this.cellId = param1;
         this.objectGID = param2;
         return this;
      }
      
      public function reset() : void
      {
         this.cellId = 0;
         this.objectGID = 0;
      }
      
      public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_ObjectItemInRolePlay(param1);
      }
      
      public function serializeAs_ObjectItemInRolePlay(param1:IDataOutput) : void
      {
         if(this.cellId < 0 || this.cellId > 559)
         {
            throw new Error("Forbidden value (" + this.cellId + ") on element cellId.");
         }
         param1.writeShort(this.cellId);
         if(this.objectGID < 0)
         {
            throw new Error("Forbidden value (" + this.objectGID + ") on element objectGID.");
         }
         param1.writeShort(this.objectGID);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_ObjectItemInRolePlay(param1);
      }
      
      public function deserializeAs_ObjectItemInRolePlay(param1:IDataInput) : void
      {
         this.cellId = param1.readShort();
         if(this.cellId < 0 || this.cellId > 559)
         {
            throw new Error("Forbidden value (" + this.cellId + ") on element of ObjectItemInRolePlay.cellId.");
         }
         this.objectGID = param1.readShort();
         if(this.objectGID < 0)
         {
            throw new Error("Forbidden value (" + this.objectGID + ") on element of ObjectItemInRolePlay.objectGID.");
         }
      }
   }
}

