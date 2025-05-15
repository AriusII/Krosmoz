package com.ankamagames.dofus.network.types.game.shortcut
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class Shortcut implements INetworkType
   {
      public static const protocolId:uint = 369;
      
      public var slot:uint = 0;
      
      public function Shortcut()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 369;
      }
      
      public function initShortcut(param1:uint = 0) : Shortcut
      {
         this.slot = param1;
         return this;
      }
      
      public function reset() : void
      {
         this.slot = 0;
      }
      
      public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_Shortcut(param1);
      }
      
      public function serializeAs_Shortcut(param1:IDataOutput) : void
      {
         if(this.slot < 0 || this.slot > 99)
         {
            throw new Error("Forbidden value (" + this.slot + ") on element slot.");
         }
         param1.writeInt(this.slot);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_Shortcut(param1);
      }
      
      public function deserializeAs_Shortcut(param1:IDataInput) : void
      {
         this.slot = param1.readInt();
         if(this.slot < 0 || this.slot > 99)
         {
            throw new Error("Forbidden value (" + this.slot + ") on element of Shortcut.slot.");
         }
      }
   }
}

