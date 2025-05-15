package com.ankamagames.dofus.network.types.game.shortcut
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class ShortcutSmiley extends Shortcut implements INetworkType
   {
      public static const protocolId:uint = 388;
      
      public var smileyId:uint = 0;
      
      public function ShortcutSmiley()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 388;
      }
      
      public function initShortcutSmiley(param1:uint = 0, param2:uint = 0) : ShortcutSmiley
      {
         super.initShortcut(param1);
         this.smileyId = param2;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.smileyId = 0;
      }
      
      override public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_ShortcutSmiley(param1);
      }
      
      public function serializeAs_ShortcutSmiley(param1:IDataOutput) : void
      {
         super.serializeAs_Shortcut(param1);
         if(this.smileyId < 0)
         {
            throw new Error("Forbidden value (" + this.smileyId + ") on element smileyId.");
         }
         param1.writeByte(this.smileyId);
      }
      
      override public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_ShortcutSmiley(param1);
      }
      
      public function deserializeAs_ShortcutSmiley(param1:IDataInput) : void
      {
         super.deserialize(param1);
         this.smileyId = param1.readByte();
         if(this.smileyId < 0)
         {
            throw new Error("Forbidden value (" + this.smileyId + ") on element of ShortcutSmiley.smileyId.");
         }
      }
   }
}

