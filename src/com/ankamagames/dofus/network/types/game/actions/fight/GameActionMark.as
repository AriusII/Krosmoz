package com.ankamagames.dofus.network.types.game.actions.fight
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class GameActionMark implements INetworkType
   {
      public static const protocolId:uint = 351;
      
      public var markAuthorId:int = 0;
      
      public var markSpellId:uint = 0;
      
      public var markId:int = 0;
      
      public var markType:int = 0;
      
      public var cells:Vector.<GameActionMarkedCell> = new Vector.<GameActionMarkedCell>();
      
      public function GameActionMark()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 351;
      }
      
      public function initGameActionMark(param1:int = 0, param2:uint = 0, param3:int = 0, param4:int = 0, param5:Vector.<GameActionMarkedCell> = null) : GameActionMark
      {
         this.markAuthorId = param1;
         this.markSpellId = param2;
         this.markId = param3;
         this.markType = param4;
         this.cells = param5;
         return this;
      }
      
      public function reset() : void
      {
         this.markAuthorId = 0;
         this.markSpellId = 0;
         this.markId = 0;
         this.markType = 0;
         this.cells = new Vector.<GameActionMarkedCell>();
      }
      
      public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_GameActionMark(param1);
      }
      
      public function serializeAs_GameActionMark(param1:IDataOutput) : void
      {
         param1.writeInt(this.markAuthorId);
         if(this.markSpellId < 0)
         {
            throw new Error("Forbidden value (" + this.markSpellId + ") on element markSpellId.");
         }
         param1.writeInt(this.markSpellId);
         param1.writeShort(this.markId);
         param1.writeByte(this.markType);
         param1.writeShort(this.cells.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.cells.length)
         {
            (this.cells[_loc2_] as GameActionMarkedCell).serializeAs_GameActionMarkedCell(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_GameActionMark(param1);
      }
      
      public function deserializeAs_GameActionMark(param1:IDataInput) : void
      {
         var _loc4_:GameActionMarkedCell = null;
         this.markAuthorId = param1.readInt();
         this.markSpellId = param1.readInt();
         if(this.markSpellId < 0)
         {
            throw new Error("Forbidden value (" + this.markSpellId + ") on element of GameActionMark.markSpellId.");
         }
         this.markId = param1.readShort();
         this.markType = param1.readByte();
         var _loc2_:uint = uint(param1.readUnsignedShort());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new GameActionMarkedCell();
            _loc4_.deserialize(param1);
            this.cells.push(_loc4_);
            _loc3_++;
         }
      }
   }
}

