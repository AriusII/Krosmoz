package com.ankamagames.dofus.network.messages.game.actions.fight
{
   import com.ankamagames.dofus.network.messages.game.actions.AbstractGameActionMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class GameActionFightTackledMessage extends AbstractGameActionMessage implements INetworkMessage
   {
      public static const protocolId:uint = 1004;
      
      private var _isInitialized:Boolean = false;
      
      public var tacklersIds:Vector.<int> = new Vector.<int>();
      
      public function GameActionFightTackledMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 1004;
      }
      
      public function initGameActionFightTackledMessage(param1:uint = 0, param2:int = 0, param3:Vector.<int> = null) : GameActionFightTackledMessage
      {
         super.initAbstractGameActionMessage(param1,param2);
         this.tacklersIds = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.tacklersIds = new Vector.<int>();
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
      
      override public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_GameActionFightTackledMessage(param1);
      }
      
      public function serializeAs_GameActionFightTackledMessage(param1:IDataOutput) : void
      {
         super.serializeAs_AbstractGameActionMessage(param1);
         param1.writeShort(this.tacklersIds.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.tacklersIds.length)
         {
            param1.writeInt(this.tacklersIds[_loc2_]);
            _loc2_++;
         }
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_GameActionFightTackledMessage(param1);
      }
      
      public function deserializeAs_GameActionFightTackledMessage(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         super.deserialize(param1);
         var _loc2_:uint = uint(param1.readUnsignedShort());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = int(param1.readInt());
            this.tacklersIds.push(_loc4_);
            _loc3_++;
         }
      }
   }
}

