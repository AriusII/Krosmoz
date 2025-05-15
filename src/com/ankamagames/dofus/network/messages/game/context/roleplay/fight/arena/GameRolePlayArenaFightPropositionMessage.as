package com.ankamagames.dofus.network.messages.game.context.roleplay.fight.arena
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class GameRolePlayArenaFightPropositionMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6276;
      
      private var _isInitialized:Boolean = false;
      
      public var fightId:uint = 0;
      
      public var alliesId:Vector.<uint> = new Vector.<uint>();
      
      public var duration:uint = 0;
      
      public function GameRolePlayArenaFightPropositionMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6276;
      }
      
      public function initGameRolePlayArenaFightPropositionMessage(param1:uint = 0, param2:Vector.<uint> = null, param3:uint = 0) : GameRolePlayArenaFightPropositionMessage
      {
         this.fightId = param1;
         this.alliesId = param2;
         this.duration = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.fightId = 0;
         this.alliesId = new Vector.<uint>();
         this.duration = 0;
         this._isInitialized = false;
      }
      
      override public function pack(param1:IDataOutput) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         this.serialize(_loc2_);
         writePacket(param1,this.getMessageId(),_loc2_);
      }
      
      override public function unpack(param1:IDataInput, param2:uint) : void
      {
         this.deserialize(param1);
      }
      
      public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_GameRolePlayArenaFightPropositionMessage(param1);
      }
      
      public function serializeAs_GameRolePlayArenaFightPropositionMessage(param1:IDataOutput) : void
      {
         if(this.fightId < 0)
         {
            throw new Error("Forbidden value (" + this.fightId + ") on element fightId.");
         }
         param1.writeInt(this.fightId);
         param1.writeShort(this.alliesId.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.alliesId.length)
         {
            if(this.alliesId[_loc2_] < 0)
            {
               throw new Error("Forbidden value (" + this.alliesId[_loc2_] + ") on element 2 (starting at 1) of alliesId.");
            }
            param1.writeInt(this.alliesId[_loc2_]);
            _loc2_++;
         }
         if(this.duration < 0)
         {
            throw new Error("Forbidden value (" + this.duration + ") on element duration.");
         }
         param1.writeShort(this.duration);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_GameRolePlayArenaFightPropositionMessage(param1);
      }
      
      public function deserializeAs_GameRolePlayArenaFightPropositionMessage(param1:IDataInput) : void
      {
         var _loc4_:uint = 0;
         this.fightId = param1.readInt();
         if(this.fightId < 0)
         {
            throw new Error("Forbidden value (" + this.fightId + ") on element of GameRolePlayArenaFightPropositionMessage.fightId.");
         }
         var _loc2_:uint = uint(param1.readUnsignedShort());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = uint(param1.readInt());
            if(_loc4_ < 0)
            {
               throw new Error("Forbidden value (" + _loc4_ + ") on elements of alliesId.");
            }
            this.alliesId.push(_loc4_);
            _loc3_++;
         }
         this.duration = param1.readShort();
         if(this.duration < 0)
         {
            throw new Error("Forbidden value (" + this.duration + ") on element of GameRolePlayArenaFightPropositionMessage.duration.");
         }
      }
   }
}

