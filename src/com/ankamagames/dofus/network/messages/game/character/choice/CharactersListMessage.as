package com.ankamagames.dofus.network.messages.game.character.choice
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.character.choice.CharacterBaseInformations;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class CharactersListMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 151;
      
      private var _isInitialized:Boolean = false;
      
      public var hasStartupActions:Boolean = false;
      
      public var characters:Vector.<CharacterBaseInformations> = new Vector.<CharacterBaseInformations>();
      
      public function CharactersListMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 151;
      }
      
      public function initCharactersListMessage(param1:Boolean = false, param2:Vector.<CharacterBaseInformations> = null) : CharactersListMessage
      {
         this.hasStartupActions = param1;
         this.characters = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.hasStartupActions = false;
         this.characters = new Vector.<CharacterBaseInformations>();
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
         this.serializeAs_CharactersListMessage(param1);
      }
      
      public function serializeAs_CharactersListMessage(param1:IDataOutput) : void
      {
         param1.writeBoolean(this.hasStartupActions);
         param1.writeShort(this.characters.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.characters.length)
         {
            param1.writeShort((this.characters[_loc2_] as CharacterBaseInformations).getTypeId());
            (this.characters[_loc2_] as CharacterBaseInformations).serialize(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_CharactersListMessage(param1);
      }
      
      public function deserializeAs_CharactersListMessage(param1:IDataInput) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:CharacterBaseInformations = null;
         this.hasStartupActions = param1.readBoolean();
         var _loc2_:uint = uint(param1.readUnsignedShort());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = uint(param1.readUnsignedShort());
            _loc5_ = ProtocolTypeManager.getInstance(CharacterBaseInformations,_loc4_);
            _loc5_.deserialize(param1);
            this.characters.push(_loc5_);
            _loc3_++;
         }
      }
   }
}

