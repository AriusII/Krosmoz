package com.ankamagames.dofus.network.messages.web.krosmaster
{
   import com.ankamagames.dofus.network.types.web.krosmaster.KrosmasterFigure;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class KrosmasterInventoryMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6350;
      
      private var _isInitialized:Boolean = false;
      
      public var figures:Vector.<KrosmasterFigure> = new Vector.<KrosmasterFigure>();
      
      public function KrosmasterInventoryMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6350;
      }
      
      public function initKrosmasterInventoryMessage(param1:Vector.<KrosmasterFigure> = null) : KrosmasterInventoryMessage
      {
         this.figures = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.figures = new Vector.<KrosmasterFigure>();
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
         this.serializeAs_KrosmasterInventoryMessage(param1);
      }
      
      public function serializeAs_KrosmasterInventoryMessage(param1:IDataOutput) : void
      {
         param1.writeShort(this.figures.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.figures.length)
         {
            (this.figures[_loc2_] as KrosmasterFigure).serializeAs_KrosmasterFigure(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_KrosmasterInventoryMessage(param1);
      }
      
      public function deserializeAs_KrosmasterInventoryMessage(param1:IDataInput) : void
      {
         var _loc4_:KrosmasterFigure = null;
         var _loc2_:uint = uint(param1.readUnsignedShort());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new KrosmasterFigure();
            _loc4_.deserialize(param1);
            this.figures.push(_loc4_);
            _loc3_++;
         }
      }
   }
}

