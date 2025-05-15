package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class HumanOptionEmote extends HumanOption implements INetworkType
   {
      public static const protocolId:uint = 407;
      
      public var emoteId:int = 0;
      
      public var emoteStartTime:Number = 0;
      
      public function HumanOptionEmote()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 407;
      }
      
      public function initHumanOptionEmote(param1:int = 0, param2:Number = 0) : HumanOptionEmote
      {
         this.emoteId = param1;
         this.emoteStartTime = param2;
         return this;
      }
      
      override public function reset() : void
      {
         this.emoteId = 0;
         this.emoteStartTime = 0;
      }
      
      override public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_HumanOptionEmote(param1);
      }
      
      public function serializeAs_HumanOptionEmote(param1:IDataOutput) : void
      {
         super.serializeAs_HumanOption(param1);
         param1.writeByte(this.emoteId);
         param1.writeDouble(this.emoteStartTime);
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_HumanOptionEmote(param1);
      }
      
      public function deserializeAs_HumanOptionEmote(param1:IDataInput) : void
      {
         super.deserialize(param1);
         this.emoteId = param1.readByte();
         this.emoteStartTime = param1.readDouble();
      }
   }
}

