package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class FightResultListEntry implements INetworkType
   {
      public static const protocolId:uint = 16;
      
      public var outcome:uint = 0;
      
      public var rewards:FightLoot = new FightLoot();
      
      public function FightResultListEntry()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 16;
      }
      
      public function initFightResultListEntry(param1:uint = 0, param2:FightLoot = null) : FightResultListEntry
      {
         this.outcome = param1;
         this.rewards = param2;
         return this;
      }
      
      public function reset() : void
      {
         this.outcome = 0;
         this.rewards = new FightLoot();
      }
      
      public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_FightResultListEntry(param1);
      }
      
      public function serializeAs_FightResultListEntry(param1:IDataOutput) : void
      {
         param1.writeShort(this.outcome);
         this.rewards.serializeAs_FightLoot(param1);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_FightResultListEntry(param1);
      }
      
      public function deserializeAs_FightResultListEntry(param1:IDataInput) : void
      {
         this.outcome = param1.readShort();
         if(this.outcome < 0)
         {
            throw new Error("Forbidden value (" + this.outcome + ") on element of FightResultListEntry.outcome.");
         }
         this.rewards = new FightLoot();
         this.rewards.deserialize(param1);
      }
   }
}

