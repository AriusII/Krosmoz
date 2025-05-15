package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class MonsterInGroupInformations extends MonsterInGroupLightInformations implements INetworkType
   {
      public static const protocolId:uint = 144;
      
      public var look:EntityLook = new EntityLook();
      
      public function MonsterInGroupInformations()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 144;
      }
      
      public function initMonsterInGroupInformations(param1:int = 0, param2:uint = 0, param3:EntityLook = null) : MonsterInGroupInformations
      {
         super.initMonsterInGroupLightInformations(param1,param2);
         this.look = param3;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.look = new EntityLook();
      }
      
      override public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_MonsterInGroupInformations(param1);
      }
      
      public function serializeAs_MonsterInGroupInformations(param1:IDataOutput) : void
      {
         super.serializeAs_MonsterInGroupLightInformations(param1);
         this.look.serializeAs_EntityLook(param1);
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_MonsterInGroupInformations(param1);
      }
      
      public function deserializeAs_MonsterInGroupInformations(param1:IDataInput) : void
      {
         super.deserialize(param1);
         this.look = new EntityLook();
         this.look.deserialize(param1);
      }
   }
}

