package com.ankamagames.dofus.network.types.game.look
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class EntityLook implements INetworkType
   {
      public static const protocolId:uint = 55;
      
      public var bonesId:uint = 0;
      
      public var skins:Vector.<uint> = new Vector.<uint>();
      
      public var indexedColors:Vector.<int> = new Vector.<int>();
      
      public var scales:Vector.<int> = new Vector.<int>();
      
      public var subentities:Vector.<SubEntity> = new Vector.<SubEntity>();
      
      public function EntityLook()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 55;
      }
      
      public function initEntityLook(param1:uint = 0, param2:Vector.<uint> = null, param3:Vector.<int> = null, param4:Vector.<int> = null, param5:Vector.<SubEntity> = null) : EntityLook
      {
         this.bonesId = param1;
         this.skins = param2;
         this.indexedColors = param3;
         this.scales = param4;
         this.subentities = param5;
         return this;
      }
      
      public function reset() : void
      {
         this.bonesId = 0;
         this.skins = new Vector.<uint>();
         this.indexedColors = new Vector.<int>();
         this.scales = new Vector.<int>();
         this.subentities = new Vector.<SubEntity>();
      }
      
      public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_EntityLook(param1);
      }
      
      public function serializeAs_EntityLook(param1:IDataOutput) : void
      {
         if(this.bonesId < 0)
         {
            throw new Error("Forbidden value (" + this.bonesId + ") on element bonesId.");
         }
         param1.writeShort(this.bonesId);
         param1.writeShort(this.skins.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.skins.length)
         {
            if(this.skins[_loc2_] < 0)
            {
               throw new Error("Forbidden value (" + this.skins[_loc2_] + ") on element 2 (starting at 1) of skins.");
            }
            param1.writeShort(this.skins[_loc2_]);
            _loc2_++;
         }
         param1.writeShort(this.indexedColors.length);
         var _loc3_:uint = 0;
         while(_loc3_ < this.indexedColors.length)
         {
            param1.writeInt(this.indexedColors[_loc3_]);
            _loc3_++;
         }
         param1.writeShort(this.scales.length);
         var _loc4_:uint = 0;
         while(_loc4_ < this.scales.length)
         {
            param1.writeShort(this.scales[_loc4_]);
            _loc4_++;
         }
         param1.writeShort(this.subentities.length);
         var _loc5_:uint = 0;
         while(_loc5_ < this.subentities.length)
         {
            (this.subentities[_loc5_] as SubEntity).serializeAs_SubEntity(param1);
            _loc5_++;
         }
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_EntityLook(param1);
      }
      
      public function deserializeAs_EntityLook(param1:IDataInput) : void
      {
         var _loc10_:uint = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:SubEntity = null;
         this.bonesId = param1.readShort();
         if(this.bonesId < 0)
         {
            throw new Error("Forbidden value (" + this.bonesId + ") on element of EntityLook.bonesId.");
         }
         var _loc2_:uint = uint(param1.readUnsignedShort());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc10_ = uint(param1.readShort());
            if(_loc10_ < 0)
            {
               throw new Error("Forbidden value (" + _loc10_ + ") on elements of skins.");
            }
            this.skins.push(_loc10_);
            _loc3_++;
         }
         var _loc4_:uint = uint(param1.readUnsignedShort());
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc11_ = int(param1.readInt());
            this.indexedColors.push(_loc11_);
            _loc5_++;
         }
         var _loc6_:uint = uint(param1.readUnsignedShort());
         var _loc7_:uint = 0;
         while(_loc7_ < _loc6_)
         {
            _loc12_ = int(param1.readShort());
            this.scales.push(_loc12_);
            _loc7_++;
         }
         var _loc8_:uint = uint(param1.readUnsignedShort());
         var _loc9_:uint = 0;
         while(_loc9_ < _loc8_)
         {
            _loc13_ = new SubEntity();
            _loc13_.deserialize(param1);
            this.subentities.push(_loc13_);
            _loc9_++;
         }
      }
   }
}

