package com.ankamagames.dofus.network.types.game.achievement
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class AchievementRewardable implements INetworkType
   {
      public static const protocolId:uint = 412;
      
      public var id:uint = 0;
      
      public var finishedlevel:uint = 0;
      
      public function AchievementRewardable()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 412;
      }
      
      public function initAchievementRewardable(param1:uint = 0, param2:uint = 0) : AchievementRewardable
      {
         this.id = param1;
         this.finishedlevel = param2;
         return this;
      }
      
      public function reset() : void
      {
         this.id = 0;
         this.finishedlevel = 0;
      }
      
      public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_AchievementRewardable(param1);
      }
      
      public function serializeAs_AchievementRewardable(param1:IDataOutput) : void
      {
         if(this.id < 0)
         {
            throw new Error("Forbidden value (" + this.id + ") on element id.");
         }
         param1.writeShort(this.id);
         if(this.finishedlevel < 0 || this.finishedlevel > 200)
         {
            throw new Error("Forbidden value (" + this.finishedlevel + ") on element finishedlevel.");
         }
         param1.writeShort(this.finishedlevel);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_AchievementRewardable(param1);
      }
      
      public function deserializeAs_AchievementRewardable(param1:IDataInput) : void
      {
         this.id = param1.readShort();
         if(this.id < 0)
         {
            throw new Error("Forbidden value (" + this.id + ") on element of AchievementRewardable.id.");
         }
         this.finishedlevel = param1.readShort();
         if(this.finishedlevel < 0 || this.finishedlevel > 200)
         {
            throw new Error("Forbidden value (" + this.finishedlevel + ") on element of AchievementRewardable.finishedlevel.");
         }
      }
   }
}

