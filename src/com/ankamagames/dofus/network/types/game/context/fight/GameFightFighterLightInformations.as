package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.jerakine.network.utils.BooleanByteWrapper;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class GameFightFighterLightInformations implements INetworkType
   {
      public static const protocolId:uint = 413;
      
      public var id:int = 0;
      
      public var name:String = "";
      
      public var level:uint = 0;
      
      public var breed:int = 0;
      
      public var sex:Boolean = false;
      
      public var alive:Boolean = false;
      
      public function GameFightFighterLightInformations()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 413;
      }
      
      public function initGameFightFighterLightInformations(param1:int = 0, param2:String = "", param3:uint = 0, param4:int = 0, param5:Boolean = false, param6:Boolean = false) : GameFightFighterLightInformations
      {
         this.id = param1;
         this.name = param2;
         this.level = param3;
         this.breed = param4;
         this.sex = param5;
         this.alive = param6;
         return this;
      }
      
      public function reset() : void
      {
         this.id = 0;
         this.name = "";
         this.level = 0;
         this.breed = 0;
         this.sex = false;
         this.alive = false;
      }
      
      public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_GameFightFighterLightInformations(param1);
      }
      
      public function serializeAs_GameFightFighterLightInformations(param1:IDataOutput) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = BooleanByteWrapper.setFlag(_loc2_,0,this.sex);
         _loc2_ = BooleanByteWrapper.setFlag(_loc2_,1,this.alive);
         param1.writeByte(_loc2_);
         param1.writeInt(this.id);
         param1.writeUTF(this.name);
         if(this.level < 0)
         {
            throw new Error("Forbidden value (" + this.level + ") on element level.");
         }
         param1.writeShort(this.level);
         param1.writeByte(this.breed);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_GameFightFighterLightInformations(param1);
      }
      
      public function deserializeAs_GameFightFighterLightInformations(param1:IDataInput) : void
      {
         var _loc2_:uint = uint(param1.readByte());
         this.sex = BooleanByteWrapper.getFlag(_loc2_,0);
         this.alive = BooleanByteWrapper.getFlag(_loc2_,1);
         this.id = param1.readInt();
         this.name = param1.readUTF();
         this.level = param1.readShort();
         if(this.level < 0)
         {
            throw new Error("Forbidden value (" + this.level + ") on element of GameFightFighterLightInformations.level.");
         }
         this.breed = param1.readByte();
      }
   }
}

