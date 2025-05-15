package com.ankamagames.dofus.network.messages.game.context.roleplay.houses
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.house.HouseInformations;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class HousePropertiesMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5734;
      
      private var _isInitialized:Boolean = false;
      
      public var properties:HouseInformations = new HouseInformations();
      
      public function HousePropertiesMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5734;
      }
      
      public function initHousePropertiesMessage(param1:HouseInformations = null) : HousePropertiesMessage
      {
         this.properties = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.properties = new HouseInformations();
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
         this.serializeAs_HousePropertiesMessage(param1);
      }
      
      public function serializeAs_HousePropertiesMessage(param1:IDataOutput) : void
      {
         param1.writeShort(this.properties.getTypeId());
         this.properties.serialize(param1);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_HousePropertiesMessage(param1);
      }
      
      public function deserializeAs_HousePropertiesMessage(param1:IDataInput) : void
      {
         var _loc2_:uint = uint(param1.readUnsignedShort());
         this.properties = ProtocolTypeManager.getInstance(HouseInformations,_loc2_);
         this.properties.deserialize(param1);
      }
   }
}

