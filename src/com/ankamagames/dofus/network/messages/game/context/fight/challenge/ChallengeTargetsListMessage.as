package com.ankamagames.dofus.network.messages.game.context.fight.challenge
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class ChallengeTargetsListMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5613;
      
      private var _isInitialized:Boolean = false;
      
      public var targetIds:Vector.<int> = new Vector.<int>();
      
      public var targetCells:Vector.<int> = new Vector.<int>();
      
      public function ChallengeTargetsListMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5613;
      }
      
      public function initChallengeTargetsListMessage(param1:Vector.<int> = null, param2:Vector.<int> = null) : ChallengeTargetsListMessage
      {
         this.targetIds = param1;
         this.targetCells = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.targetIds = new Vector.<int>();
         this.targetCells = new Vector.<int>();
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
         this.serializeAs_ChallengeTargetsListMessage(param1);
      }
      
      public function serializeAs_ChallengeTargetsListMessage(param1:IDataOutput) : void
      {
         param1.writeShort(this.targetIds.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.targetIds.length)
         {
            param1.writeInt(this.targetIds[_loc2_]);
            _loc2_++;
         }
         param1.writeShort(this.targetCells.length);
         var _loc3_:uint = 0;
         while(_loc3_ < this.targetCells.length)
         {
            if(this.targetCells[_loc3_] < -1 || this.targetCells[_loc3_] > 559)
            {
               throw new Error("Forbidden value (" + this.targetCells[_loc3_] + ") on element 2 (starting at 1) of targetCells.");
            }
            param1.writeShort(this.targetCells[_loc3_]);
            _loc3_++;
         }
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_ChallengeTargetsListMessage(param1);
      }
      
      public function deserializeAs_ChallengeTargetsListMessage(param1:IDataInput) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:uint = uint(param1.readUnsignedShort());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc6_ = int(param1.readInt());
            this.targetIds.push(_loc6_);
            _loc3_++;
         }
         var _loc4_:uint = uint(param1.readUnsignedShort());
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc7_ = int(param1.readShort());
            if(_loc7_ < -1 || _loc7_ > 559)
            {
               throw new Error("Forbidden value (" + _loc7_ + ") on elements of targetCells.");
            }
            this.targetCells.push(_loc7_);
            _loc5_++;
         }
      }
   }
}

