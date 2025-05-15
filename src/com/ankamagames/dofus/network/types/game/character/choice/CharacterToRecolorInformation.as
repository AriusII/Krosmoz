package com.ankamagames.dofus.network.types.game.character.choice
{
   import com.ankamagames.dofus.network.types.game.character.AbstractCharacterInformation;
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class CharacterToRecolorInformation extends AbstractCharacterInformation implements INetworkType
   {
      public static const protocolId:uint = 212;
      
      public var colors:Vector.<int> = new Vector.<int>();
      
      public function CharacterToRecolorInformation()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 212;
      }
      
      public function initCharacterToRecolorInformation(param1:uint = 0, param2:Vector.<int> = null) : CharacterToRecolorInformation
      {
         super.initAbstractCharacterInformation(param1);
         this.colors = param2;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.colors = new Vector.<int>();
      }
      
      override public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_CharacterToRecolorInformation(param1);
      }
      
      public function serializeAs_CharacterToRecolorInformation(param1:IDataOutput) : void
      {
         super.serializeAs_AbstractCharacterInformation(param1);
         param1.writeShort(this.colors.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.colors.length)
         {
            param1.writeInt(this.colors[_loc2_]);
            _loc2_++;
         }
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_CharacterToRecolorInformation(param1);
      }
      
      public function deserializeAs_CharacterToRecolorInformation(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         super.deserialize(param1);
         var _loc2_:uint = uint(param1.readUnsignedShort());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = int(param1.readInt());
            this.colors.push(_loc4_);
            _loc3_++;
         }
      }
   }
}

