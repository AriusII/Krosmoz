package com.ankamagames.dofus.network.messages.game.context.roleplay.fight
{
   import com.ankamagames.dofus.network.types.game.context.fight.FightCommonInformations;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class GameRolePlayShowChallengeMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 301;
      
      private var _isInitialized:Boolean = false;
      
      public var commonsInfos:FightCommonInformations = new FightCommonInformations();
      
      public function GameRolePlayShowChallengeMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 301;
      }
      
      public function initGameRolePlayShowChallengeMessage(param1:FightCommonInformations = null) : GameRolePlayShowChallengeMessage
      {
         this.commonsInfos = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.commonsInfos = new FightCommonInformations();
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
         this.serializeAs_GameRolePlayShowChallengeMessage(param1);
      }
      
      public function serializeAs_GameRolePlayShowChallengeMessage(param1:IDataOutput) : void
      {
         this.commonsInfos.serializeAs_FightCommonInformations(param1);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_GameRolePlayShowChallengeMessage(param1);
      }
      
      public function deserializeAs_GameRolePlayShowChallengeMessage(param1:IDataInput) : void
      {
         this.commonsInfos = new FightCommonInformations();
         this.commonsInfos.deserialize(param1);
      }
   }
}

