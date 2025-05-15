package com.ankamagames.dofus.network.messages.game.context.roleplay.job
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobCrafterDirectorySettings;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class JobCrafterDirectorySettingsMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5652;
      
      private var _isInitialized:Boolean = false;
      
      public var craftersSettings:Vector.<JobCrafterDirectorySettings> = new Vector.<JobCrafterDirectorySettings>();
      
      public function JobCrafterDirectorySettingsMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5652;
      }
      
      public function initJobCrafterDirectorySettingsMessage(param1:Vector.<JobCrafterDirectorySettings> = null) : JobCrafterDirectorySettingsMessage
      {
         this.craftersSettings = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.craftersSettings = new Vector.<JobCrafterDirectorySettings>();
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
         this.serializeAs_JobCrafterDirectorySettingsMessage(param1);
      }
      
      public function serializeAs_JobCrafterDirectorySettingsMessage(param1:IDataOutput) : void
      {
         param1.writeShort(this.craftersSettings.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.craftersSettings.length)
         {
            (this.craftersSettings[_loc2_] as JobCrafterDirectorySettings).serializeAs_JobCrafterDirectorySettings(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_JobCrafterDirectorySettingsMessage(param1);
      }
      
      public function deserializeAs_JobCrafterDirectorySettingsMessage(param1:IDataInput) : void
      {
         var _loc4_:JobCrafterDirectorySettings = null;
         var _loc2_:uint = uint(param1.readUnsignedShort());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new JobCrafterDirectorySettings();
            _loc4_.deserialize(param1);
            this.craftersSettings.push(_loc4_);
            _loc3_++;
         }
      }
   }
}

