package com.ankamagames.dofus.logic.game.common.types
{
   import com.ankamagames.dofus.datacenter.mounts.Mount;
   import com.ankamagames.dofus.datacenter.mounts.MountBehavior;
   import com.ankamagames.dofus.misc.ObjectEffectAdapter;
   import com.ankamagames.dofus.network.types.game.mount.MountClientData;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.CopyObject;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.utils.Dictionary;
   
   public class MountData
   {
      private static var _dictionary_cache:Dictionary = new Dictionary();
      
      public function MountData()
      {
         super();
      }
      
      public static function makeMountData(param1:MountClientData, param2:Boolean = true, param3:uint = 0) : Object
      {
         var _loc4_:Object = null;
         var _loc7_:uint = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(Boolean(_dictionary_cache[param1.id]) && param2)
         {
            _loc4_ = getMountFromCache(param1.id);
         }
         else
         {
            _loc4_ = CopyObject.copyObject(param1,["behaviors","ancestor"]);
            _dictionary_cache[_loc4_.id] = _loc4_;
         }
         var _loc5_:Mount = Mount.getMountById(param1.model);
         if(!param1.name)
         {
            _loc4_.name = I18n.getUiText("ui.common.noName");
         }
         _loc4_.id = param1.id;
         _loc4_.model = param1.model;
         _loc4_.description = _loc5_.name;
         _loc4_.level = param1.level;
         _loc4_.experience = param1.experience;
         _loc4_.experienceForLevel = param1.experienceForLevel;
         _loc4_.experienceForNextLevel = param1.experienceForNextLevel;
         _loc4_.xpRatio = param3;
         try
         {
            _loc4_.entityLook = TiphonEntityLook.fromString(_loc5_.look);
            _loc4_.colors = _loc4_.entityLook.getColors();
         }
         catch(e:Error)
         {
         }
         var _loc6_:Vector.<uint> = param1.ancestor.concat();
         _loc6_.unshift(param1.model);
         _loc4_.ancestor = makeParent(_loc6_,0,-1,0);
         _loc4_.ability = new Array();
         for each(_loc7_ in param1.behaviors)
         {
            _loc4_.ability.push(MountBehavior.getMountBehaviorById(_loc7_));
         }
         _loc4_.effectList = new Array();
         _loc8_ = int(param1.effectList.length);
         _loc9_ = 0;
         while(_loc9_ < _loc8_)
         {
            _loc4_.effectList.push(ObjectEffectAdapter.fromNetwork(param1.effectList[_loc9_]));
            _loc9_++;
         }
         _loc4_.isRideable = param1.isRideable;
         _loc4_.stamina = param1.stamina;
         _loc4_.energy = param1.energy;
         _loc4_.maturity = param1.maturity;
         _loc4_.serenity = param1.serenity;
         _loc4_.love = param1.love;
         _loc4_.fecondationTime = param1.fecondationTime;
         _loc4_.isFecondationReady = param1.isFecondationReady;
         _loc4_.reproductionCount = param1.reproductionCount;
         _loc4_.boostLimiter = param1.boostLimiter;
         return _loc4_;
      }
      
      public static function getMountFromCache(param1:uint) : Object
      {
         return _dictionary_cache[param1];
      }
      
      private static function makeParent(param1:Vector.<uint>, param2:uint, param3:int, param4:uint) : Object
      {
         var _loc5_:uint = param3 + Math.pow(2,param2 - 1);
         var _loc6_:uint = _loc5_ + param4;
         if(param1.length <= _loc6_)
         {
            return null;
         }
         var _loc7_:Mount = Mount.getMountById(param1[_loc6_]);
         if(!_loc7_)
         {
            return null;
         }
         return {
            "mount":_loc7_,
            "mother":makeParent(param1,param2 + 1,_loc5_,0 + 2 * (_loc6_ - _loc5_)),
            "father":makeParent(param1,param2 + 1,_loc5_,1 + 2 * (_loc6_ - _loc5_)),
            "entityLook":TiphonEntityLook.fromString(_loc7_.look)
         };
      }
   }
}

