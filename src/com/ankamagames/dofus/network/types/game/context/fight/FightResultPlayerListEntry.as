package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class FightResultPlayerListEntry extends FightResultFighterListEntry implements INetworkType
   {
      public static const protocolId:uint = 24;
      
      public var level:uint = 0;
      
      public var additional:Vector.<FightResultAdditionalData> = new Vector.<FightResultAdditionalData>();
      
      public function FightResultPlayerListEntry()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 24;
      }
      
      public function initFightResultPlayerListEntry(param1:uint = 0, param2:FightLoot = null, param3:int = 0, param4:Boolean = false, param5:uint = 0, param6:Vector.<FightResultAdditionalData> = null) : FightResultPlayerListEntry
      {
         super.initFightResultFighterListEntry(param1,param2,param3,param4);
         this.level = param5;
         this.additional = param6;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.level = 0;
         this.additional = new Vector.<FightResultAdditionalData>();
      }
      
      override public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_FightResultPlayerListEntry(param1);
      }
      
      public function serializeAs_FightResultPlayerListEntry(param1:IDataOutput) : void
      {
         super.serializeAs_FightResultFighterListEntry(param1);
         if(this.level < 1 || this.level > 200)
         {
            throw new Error("Forbidden value (" + this.level + ") on element level.");
         }
         param1.writeByte(this.level);
         param1.writeShort(this.additional.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.additional.length)
         {
            param1.writeShort((this.additional[_loc2_] as FightResultAdditionalData).getTypeId());
            (this.additional[_loc2_] as FightResultAdditionalData).serialize(param1);
            _loc2_++;
         }
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_FightResultPlayerListEntry(param1);
      }
      
      public function deserializeAs_FightResultPlayerListEntry(param1:IDataInput) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:FightResultAdditionalData = null;
         super.deserialize(param1);
         this.level = param1.readUnsignedByte();
         if(this.level < 1 || this.level > 200)
         {
            throw new Error("Forbidden value (" + this.level + ") on element of FightResultPlayerListEntry.level.");
         }
         var _loc2_:uint = uint(param1.readUnsignedShort());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = uint(param1.readUnsignedShort());
            _loc5_ = ProtocolTypeManager.getInstance(FightResultAdditionalData,_loc4_);
            _loc5_.deserialize(param1);
            this.additional.push(_loc5_);
            _loc3_++;
         }
      }
   }
}

