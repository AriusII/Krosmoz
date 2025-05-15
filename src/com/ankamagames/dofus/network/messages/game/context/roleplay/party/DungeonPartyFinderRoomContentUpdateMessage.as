package com.ankamagames.dofus.network.messages.game.context.roleplay.party
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.party.DungeonPartyFinderPlayer;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class DungeonPartyFinderRoomContentUpdateMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6250;
      
      private var _isInitialized:Boolean = false;
      
      public var dungeonId:uint = 0;
      
      public var addedPlayers:Vector.<DungeonPartyFinderPlayer> = new Vector.<DungeonPartyFinderPlayer>();
      
      public var removedPlayersIds:Vector.<uint> = new Vector.<uint>();
      
      public function DungeonPartyFinderRoomContentUpdateMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6250;
      }
      
      public function initDungeonPartyFinderRoomContentUpdateMessage(param1:uint = 0, param2:Vector.<DungeonPartyFinderPlayer> = null, param3:Vector.<uint> = null) : DungeonPartyFinderRoomContentUpdateMessage
      {
         this.dungeonId = param1;
         this.addedPlayers = param2;
         this.removedPlayersIds = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.dungeonId = 0;
         this.addedPlayers = new Vector.<DungeonPartyFinderPlayer>();
         this.removedPlayersIds = new Vector.<uint>();
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
         this.serializeAs_DungeonPartyFinderRoomContentUpdateMessage(param1);
      }
      
      public function serializeAs_DungeonPartyFinderRoomContentUpdateMessage(param1:IDataOutput) : void
      {
         if(this.dungeonId < 0)
         {
            throw new Error("Forbidden value (" + this.dungeonId + ") on element dungeonId.");
         }
         param1.writeShort(this.dungeonId);
         param1.writeShort(this.addedPlayers.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.addedPlayers.length)
         {
            (this.addedPlayers[_loc2_] as DungeonPartyFinderPlayer).serializeAs_DungeonPartyFinderPlayer(param1);
            _loc2_++;
         }
         param1.writeShort(this.removedPlayersIds.length);
         var _loc3_:uint = 0;
         while(_loc3_ < this.removedPlayersIds.length)
         {
            if(this.removedPlayersIds[_loc3_] < 0)
            {
               throw new Error("Forbidden value (" + this.removedPlayersIds[_loc3_] + ") on element 3 (starting at 1) of removedPlayersIds.");
            }
            param1.writeInt(this.removedPlayersIds[_loc3_]);
            _loc3_++;
         }
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_DungeonPartyFinderRoomContentUpdateMessage(param1);
      }
      
      public function deserializeAs_DungeonPartyFinderRoomContentUpdateMessage(param1:IDataInput) : void
      {
         var _loc6_:DungeonPartyFinderPlayer = null;
         var _loc7_:uint = 0;
         this.dungeonId = param1.readShort();
         if(this.dungeonId < 0)
         {
            throw new Error("Forbidden value (" + this.dungeonId + ") on element of DungeonPartyFinderRoomContentUpdateMessage.dungeonId.");
         }
         var _loc2_:uint = uint(param1.readUnsignedShort());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc6_ = new DungeonPartyFinderPlayer();
            _loc6_.deserialize(param1);
            this.addedPlayers.push(_loc6_);
            _loc3_++;
         }
         var _loc4_:uint = uint(param1.readUnsignedShort());
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc7_ = uint(param1.readInt());
            if(_loc7_ < 0)
            {
               throw new Error("Forbidden value (" + _loc7_ + ") on elements of removedPlayersIds.");
            }
            this.removedPlayersIds.push(_loc7_);
            _loc5_++;
         }
      }
   }
}

