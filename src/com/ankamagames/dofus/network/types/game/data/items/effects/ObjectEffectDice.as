package com.ankamagames.dofus.network.types.game.data.items.effects
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class ObjectEffectDice extends ObjectEffect implements INetworkType
   {
      public static const protocolId:uint = 73;
      
      public var diceNum:uint = 0;
      
      public var diceSide:uint = 0;
      
      public var diceConst:uint = 0;
      
      public function ObjectEffectDice()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 73;
      }
      
      public function initObjectEffectDice(param1:uint = 0, param2:uint = 0, param3:uint = 0, param4:uint = 0) : ObjectEffectDice
      {
         super.initObjectEffect(param1);
         this.diceNum = param2;
         this.diceSide = param3;
         this.diceConst = param4;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.diceNum = 0;
         this.diceSide = 0;
         this.diceConst = 0;
      }
      
      override public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_ObjectEffectDice(param1);
      }
      
      public function serializeAs_ObjectEffectDice(param1:IDataOutput) : void
      {
         super.serializeAs_ObjectEffect(param1);
         if(this.diceNum < 0)
         {
            throw new Error("Forbidden value (" + this.diceNum + ") on element diceNum.");
         }
         param1.writeShort(this.diceNum);
         if(this.diceSide < 0)
         {
            throw new Error("Forbidden value (" + this.diceSide + ") on element diceSide.");
         }
         param1.writeShort(this.diceSide);
         if(this.diceConst < 0)
         {
            throw new Error("Forbidden value (" + this.diceConst + ") on element diceConst.");
         }
         param1.writeShort(this.diceConst);
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_ObjectEffectDice(param1);
      }
      
      public function deserializeAs_ObjectEffectDice(param1:IDataInput) : void
      {
         super.deserialize(param1);
         this.diceNum = param1.readShort();
         if(this.diceNum < 0)
         {
            throw new Error("Forbidden value (" + this.diceNum + ") on element of ObjectEffectDice.diceNum.");
         }
         this.diceSide = param1.readShort();
         if(this.diceSide < 0)
         {
            throw new Error("Forbidden value (" + this.diceSide + ") on element of ObjectEffectDice.diceSide.");
         }
         this.diceConst = param1.readShort();
         if(this.diceConst < 0)
         {
            throw new Error("Forbidden value (" + this.diceConst + ") on element of ObjectEffectDice.diceConst.");
         }
      }
   }
}

