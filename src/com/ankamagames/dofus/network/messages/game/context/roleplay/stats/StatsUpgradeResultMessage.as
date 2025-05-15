package com.ankamagames.dofus.network.messages.game.context.roleplay.stats
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class StatsUpgradeResultMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5609;
      
      private var _isInitialized:Boolean = false;
      
      public var nbCharacBoost:uint = 0;
      
      public function StatsUpgradeResultMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5609;
      }
      
      public function initStatsUpgradeResultMessage(param1:uint = 0) : StatsUpgradeResultMessage
      {
         this.nbCharacBoost = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.nbCharacBoost = 0;
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
         this.serializeAs_StatsUpgradeResultMessage(param1);
      }
      
      public function serializeAs_StatsUpgradeResultMessage(param1:IDataOutput) : void
      {
         if(this.nbCharacBoost < 0)
         {
            throw new Error("Forbidden value (" + this.nbCharacBoost + ") on element nbCharacBoost.");
         }
         param1.writeShort(this.nbCharacBoost);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_StatsUpgradeResultMessage(param1);
      }
      
      public function deserializeAs_StatsUpgradeResultMessage(param1:IDataInput) : void
      {
         this.nbCharacBoost = param1.readShort();
         if(this.nbCharacBoost < 0)
         {
            throw new Error("Forbidden value (" + this.nbCharacBoost + ") on element of StatsUpgradeResultMessage.nbCharacBoost.");
         }
      }
   }
}

