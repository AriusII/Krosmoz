package com.ankamagames.dofus.network.messages.game.guild
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class GuildInfosUpgradeMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 5636;
      
      private var _isInitialized:Boolean = false;
      
      public var maxTaxCollectorsCount:uint = 0;
      
      public var taxCollectorsCount:uint = 0;
      
      public var taxCollectorLifePoints:uint = 0;
      
      public var taxCollectorDamagesBonuses:uint = 0;
      
      public var taxCollectorPods:uint = 0;
      
      public var taxCollectorProspecting:uint = 0;
      
      public var taxCollectorWisdom:uint = 0;
      
      public var boostPoints:uint = 0;
      
      public var spellId:Vector.<uint> = new Vector.<uint>();
      
      public var spellLevel:Vector.<uint> = new Vector.<uint>();
      
      public function GuildInfosUpgradeMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5636;
      }
      
      public function initGuildInfosUpgradeMessage(param1:uint = 0, param2:uint = 0, param3:uint = 0, param4:uint = 0, param5:uint = 0, param6:uint = 0, param7:uint = 0, param8:uint = 0, param9:Vector.<uint> = null, param10:Vector.<uint> = null) : GuildInfosUpgradeMessage
      {
         this.maxTaxCollectorsCount = param1;
         this.taxCollectorsCount = param2;
         this.taxCollectorLifePoints = param3;
         this.taxCollectorDamagesBonuses = param4;
         this.taxCollectorPods = param5;
         this.taxCollectorProspecting = param6;
         this.taxCollectorWisdom = param7;
         this.boostPoints = param8;
         this.spellId = param9;
         this.spellLevel = param10;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.maxTaxCollectorsCount = 0;
         this.taxCollectorsCount = 0;
         this.taxCollectorLifePoints = 0;
         this.taxCollectorDamagesBonuses = 0;
         this.taxCollectorPods = 0;
         this.taxCollectorProspecting = 0;
         this.taxCollectorWisdom = 0;
         this.boostPoints = 0;
         this.spellId = new Vector.<uint>();
         this.spellLevel = new Vector.<uint>();
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
         this.serializeAs_GuildInfosUpgradeMessage(param1);
      }
      
      public function serializeAs_GuildInfosUpgradeMessage(param1:IDataOutput) : void
      {
         if(this.maxTaxCollectorsCount < 0)
         {
            throw new Error("Forbidden value (" + this.maxTaxCollectorsCount + ") on element maxTaxCollectorsCount.");
         }
         param1.writeByte(this.maxTaxCollectorsCount);
         if(this.taxCollectorsCount < 0)
         {
            throw new Error("Forbidden value (" + this.taxCollectorsCount + ") on element taxCollectorsCount.");
         }
         param1.writeByte(this.taxCollectorsCount);
         if(this.taxCollectorLifePoints < 0)
         {
            throw new Error("Forbidden value (" + this.taxCollectorLifePoints + ") on element taxCollectorLifePoints.");
         }
         param1.writeShort(this.taxCollectorLifePoints);
         if(this.taxCollectorDamagesBonuses < 0)
         {
            throw new Error("Forbidden value (" + this.taxCollectorDamagesBonuses + ") on element taxCollectorDamagesBonuses.");
         }
         param1.writeShort(this.taxCollectorDamagesBonuses);
         if(this.taxCollectorPods < 0)
         {
            throw new Error("Forbidden value (" + this.taxCollectorPods + ") on element taxCollectorPods.");
         }
         param1.writeShort(this.taxCollectorPods);
         if(this.taxCollectorProspecting < 0)
         {
            throw new Error("Forbidden value (" + this.taxCollectorProspecting + ") on element taxCollectorProspecting.");
         }
         param1.writeShort(this.taxCollectorProspecting);
         if(this.taxCollectorWisdom < 0)
         {
            throw new Error("Forbidden value (" + this.taxCollectorWisdom + ") on element taxCollectorWisdom.");
         }
         param1.writeShort(this.taxCollectorWisdom);
         if(this.boostPoints < 0)
         {
            throw new Error("Forbidden value (" + this.boostPoints + ") on element boostPoints.");
         }
         param1.writeShort(this.boostPoints);
         param1.writeShort(this.spellId.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.spellId.length)
         {
            if(this.spellId[_loc2_] < 0)
            {
               throw new Error("Forbidden value (" + this.spellId[_loc2_] + ") on element 9 (starting at 1) of spellId.");
            }
            param1.writeShort(this.spellId[_loc2_]);
            _loc2_++;
         }
         param1.writeShort(this.spellLevel.length);
         var _loc3_:uint = 0;
         while(_loc3_ < this.spellLevel.length)
         {
            if(this.spellLevel[_loc3_] < 0)
            {
               throw new Error("Forbidden value (" + this.spellLevel[_loc3_] + ") on element 10 (starting at 1) of spellLevel.");
            }
            param1.writeByte(this.spellLevel[_loc3_]);
            _loc3_++;
         }
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_GuildInfosUpgradeMessage(param1);
      }
      
      public function deserializeAs_GuildInfosUpgradeMessage(param1:IDataInput) : void
      {
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         this.maxTaxCollectorsCount = param1.readByte();
         if(this.maxTaxCollectorsCount < 0)
         {
            throw new Error("Forbidden value (" + this.maxTaxCollectorsCount + ") on element of GuildInfosUpgradeMessage.maxTaxCollectorsCount.");
         }
         this.taxCollectorsCount = param1.readByte();
         if(this.taxCollectorsCount < 0)
         {
            throw new Error("Forbidden value (" + this.taxCollectorsCount + ") on element of GuildInfosUpgradeMessage.taxCollectorsCount.");
         }
         this.taxCollectorLifePoints = param1.readShort();
         if(this.taxCollectorLifePoints < 0)
         {
            throw new Error("Forbidden value (" + this.taxCollectorLifePoints + ") on element of GuildInfosUpgradeMessage.taxCollectorLifePoints.");
         }
         this.taxCollectorDamagesBonuses = param1.readShort();
         if(this.taxCollectorDamagesBonuses < 0)
         {
            throw new Error("Forbidden value (" + this.taxCollectorDamagesBonuses + ") on element of GuildInfosUpgradeMessage.taxCollectorDamagesBonuses.");
         }
         this.taxCollectorPods = param1.readShort();
         if(this.taxCollectorPods < 0)
         {
            throw new Error("Forbidden value (" + this.taxCollectorPods + ") on element of GuildInfosUpgradeMessage.taxCollectorPods.");
         }
         this.taxCollectorProspecting = param1.readShort();
         if(this.taxCollectorProspecting < 0)
         {
            throw new Error("Forbidden value (" + this.taxCollectorProspecting + ") on element of GuildInfosUpgradeMessage.taxCollectorProspecting.");
         }
         this.taxCollectorWisdom = param1.readShort();
         if(this.taxCollectorWisdom < 0)
         {
            throw new Error("Forbidden value (" + this.taxCollectorWisdom + ") on element of GuildInfosUpgradeMessage.taxCollectorWisdom.");
         }
         this.boostPoints = param1.readShort();
         if(this.boostPoints < 0)
         {
            throw new Error("Forbidden value (" + this.boostPoints + ") on element of GuildInfosUpgradeMessage.boostPoints.");
         }
         var _loc2_:uint = uint(param1.readUnsignedShort());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc6_ = uint(param1.readShort());
            if(_loc6_ < 0)
            {
               throw new Error("Forbidden value (" + _loc6_ + ") on elements of spellId.");
            }
            this.spellId.push(_loc6_);
            _loc3_++;
         }
         var _loc4_:uint = uint(param1.readUnsignedShort());
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc7_ = uint(param1.readByte());
            if(_loc7_ < 0)
            {
               throw new Error("Forbidden value (" + _loc7_ + ") on elements of spellLevel.");
            }
            this.spellLevel.push(_loc7_);
            _loc5_++;
         }
      }
   }
}

