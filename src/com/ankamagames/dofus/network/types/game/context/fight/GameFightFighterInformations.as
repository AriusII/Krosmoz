package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.context.EntityDispositionInformations;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class GameFightFighterInformations extends GameContextActorInformations implements INetworkType
   {
      public static const protocolId:uint = 143;
      
      public var teamId:uint = 2;
      
      public var alive:Boolean = false;
      
      public var stats:GameFightMinimalStats = new GameFightMinimalStats();
      
      public function GameFightFighterInformations()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 143;
      }
      
      public function initGameFightFighterInformations(param1:int = 0, param2:EntityLook = null, param3:EntityDispositionInformations = null, param4:uint = 2, param5:Boolean = false, param6:GameFightMinimalStats = null) : GameFightFighterInformations
      {
         super.initGameContextActorInformations(param1,param2,param3);
         this.teamId = param4;
         this.alive = param5;
         this.stats = param6;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.teamId = 2;
         this.alive = false;
         this.stats = new GameFightMinimalStats();
      }
      
      override public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_GameFightFighterInformations(param1);
      }
      
      public function serializeAs_GameFightFighterInformations(param1:IDataOutput) : void
      {
         super.serializeAs_GameContextActorInformations(param1);
         param1.writeByte(this.teamId);
         param1.writeBoolean(this.alive);
         param1.writeShort(this.stats.getTypeId());
         this.stats.serialize(param1);
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_GameFightFighterInformations(param1);
      }
      
      public function deserializeAs_GameFightFighterInformations(param1:IDataInput) : void
      {
         super.deserialize(param1);
         this.teamId = param1.readByte();
         if(this.teamId < 0)
         {
            throw new Error("Forbidden value (" + this.teamId + ") on element of GameFightFighterInformations.teamId.");
         }
         this.alive = param1.readBoolean();
         var _loc2_:uint = uint(param1.readUnsignedShort());
         this.stats = ProtocolTypeManager.getInstance(GameFightMinimalStats,_loc2_);
         this.stats.deserialize(param1);
      }
   }
}

