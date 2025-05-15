package com.ankamagames.dofus.network.messages.game.context.fight.challenge
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class ChallengeInfoMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6022;
      
      private var _isInitialized:Boolean = false;
      
      public var challengeId:uint = 0;
      
      public var targetId:int = 0;
      
      public var xpBonus:uint = 0;
      
      public var dropBonus:uint = 0;
      
      public function ChallengeInfoMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6022;
      }
      
      public function initChallengeInfoMessage(param1:uint = 0, param2:int = 0, param3:uint = 0, param4:uint = 0) : ChallengeInfoMessage
      {
         this.challengeId = param1;
         this.targetId = param2;
         this.xpBonus = param3;
         this.dropBonus = param4;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.challengeId = 0;
         this.targetId = 0;
         this.xpBonus = 0;
         this.dropBonus = 0;
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
         this.serializeAs_ChallengeInfoMessage(param1);
      }
      
      public function serializeAs_ChallengeInfoMessage(param1:IDataOutput) : void
      {
         if(this.challengeId < 0)
         {
            throw new Error("Forbidden value (" + this.challengeId + ") on element challengeId.");
         }
         param1.writeShort(this.challengeId);
         param1.writeInt(this.targetId);
         if(this.xpBonus < 0)
         {
            throw new Error("Forbidden value (" + this.xpBonus + ") on element xpBonus.");
         }
         param1.writeInt(this.xpBonus);
         if(this.dropBonus < 0)
         {
            throw new Error("Forbidden value (" + this.dropBonus + ") on element dropBonus.");
         }
         param1.writeInt(this.dropBonus);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_ChallengeInfoMessage(param1);
      }
      
      public function deserializeAs_ChallengeInfoMessage(param1:IDataInput) : void
      {
         this.challengeId = param1.readShort();
         if(this.challengeId < 0)
         {
            throw new Error("Forbidden value (" + this.challengeId + ") on element of ChallengeInfoMessage.challengeId.");
         }
         this.targetId = param1.readInt();
         this.xpBonus = param1.readInt();
         if(this.xpBonus < 0)
         {
            throw new Error("Forbidden value (" + this.xpBonus + ") on element of ChallengeInfoMessage.xpBonus.");
         }
         this.dropBonus = param1.readInt();
         if(this.dropBonus < 0)
         {
            throw new Error("Forbidden value (" + this.dropBonus + ") on element of ChallengeInfoMessage.dropBonus.");
         }
      }
   }
}

