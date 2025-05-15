package com.ankamagames.tiphon.types.look
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.DefaultableColor;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class TiphonEntityLook implements EntityLookObserver
   {
      public static var MEMORY_LOG:Dictionary = new Dictionary(true);
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(TiphonEntityLook));
      
      private var _observers:Dictionary;
      
      private var _locked:Boolean;
      
      private var _boneChangedWhileLocked:Boolean;
      
      private var _skinsChangedWhileLocked:Boolean;
      
      private var _colorsChangedWhileLocked:Boolean;
      
      private var _scalesChangedWhileLocked:Boolean;
      
      private var _subEntitiesChangedWhileLocked:Boolean;
      
      private var _bone:uint;
      
      private var _skins:Vector.<uint>;
      
      private var _colors:Array;
      
      private var _scaleX:Number = 1;
      
      private var _scaleY:Number = 1;
      
      private var _subEntities:Array;
      
      private var _defaultSkin:int = -1;
      
      public function TiphonEntityLook(param1:String = null)
      {
         super();
         MEMORY_LOG[this] = 1;
         if(param1)
         {
            fromString(param1,this);
         }
      }
      
      public static function fromString(param1:String, param2:TiphonEntityLook = null) : TiphonEntityLook
      {
         return EntityLookParser.fromString(param1,EntityLookParser.CURRENT_FORMAT_VERSION,EntityLookParser.DEFAULT_NUMBER_BASE,param2);
      }
      
      public function get skins() : Vector.<uint>
      {
         return this._skins;
      }
      
      public function set defaultSkin(param1:int) : void
      {
         if(this._defaultSkin != -1 && Boolean(this._skins))
         {
            this._skins.shift();
         }
         if(!this._skins)
         {
            this._skins = new Vector.<uint>(0,false);
         }
         this._defaultSkin = param1;
         if(!this._skins.length || this._skins[0] != this._defaultSkin)
         {
            this._skins.unshift(param1);
         }
      }
      
      public function get firstSkin() : uint
      {
         if(!this._skins || !this._skins.length)
         {
            return 0;
         }
         if(this._defaultSkin != -1 && this._skins.length > 1)
         {
            return this._skins[1];
         }
         return this._skins[0];
      }
      
      public function get defaultSkin() : int
      {
         return this._defaultSkin;
      }
      
      public function getBone() : uint
      {
         return this._bone;
      }
      
      public function setBone(param1:uint) : void
      {
         var _loc2_:Object = null;
         if(this._bone == param1)
         {
            return;
         }
         this._bone = param1;
         if(!this._locked)
         {
            for(_loc2_ in this._observers)
            {
               _loc2_.boneChanged(this);
            }
         }
         else
         {
            this._boneChangedWhileLocked = true;
         }
      }
      
      public function getSkins(param1:Boolean = false, param2:Boolean = true) : Vector.<uint>
      {
         if(!this._skins)
         {
            return null;
         }
         if(param1)
         {
            return this._skins;
         }
         var _loc3_:uint = this._skins.length;
         var _loc4_:uint = 0;
         if(!param2 && this._defaultSkin != -1)
         {
            _loc4_ = 1;
         }
         var _loc5_:Vector.<uint> = new Vector.<uint>(_loc3_,true);
         var _loc6_:uint = _loc4_;
         while(_loc6_ < _loc3_)
         {
            _loc5_[_loc6_ - _loc4_] = this._skins[_loc6_];
            _loc6_++;
         }
         return _loc5_;
      }
      
      public function resetSkins() : void
      {
         var _loc1_:Object = null;
         if(!this._skins || this._skins.length == 0)
         {
            return;
         }
         this._skins = null;
         if(!this._locked)
         {
            for(_loc1_ in this._observers)
            {
               _loc1_.skinsChanged(this);
            }
         }
         else
         {
            this._skinsChangedWhileLocked = true;
         }
      }
      
      public function addSkin(param1:uint, param2:Boolean = false) : void
      {
         var _loc3_:Object = null;
         if(!this._skins)
         {
            this._skins = new Vector.<uint>(0,false);
         }
         if(!param2)
         {
            this._skins.push(param1);
         }
         else
         {
            this._skins.unshift(param1);
         }
         if(!this._locked)
         {
            for(_loc3_ in this._observers)
            {
               _loc3_.skinsChanged(this);
            }
         }
         else
         {
            this._skinsChangedWhileLocked = true;
         }
      }
      
      public function getColors(param1:Boolean = false) : Array
      {
         var _loc3_:String = null;
         if(!this._colors)
         {
            return null;
         }
         if(param1)
         {
            return this._colors;
         }
         var _loc2_:Array = new Array();
         for(_loc3_ in this._colors)
         {
            _loc2_[uint(_loc3_)] = this._colors[_loc3_];
         }
         return _loc2_;
      }
      
      public function getColor(param1:uint) : DefaultableColor
      {
         var _loc2_:DefaultableColor = null;
         if(!this._colors || !this._colors[param1])
         {
            _loc2_ = new DefaultableColor();
            _loc2_.isDefault = true;
            return _loc2_;
         }
         return new DefaultableColor(this._colors[param1]);
      }
      
      public function hasColor(param1:uint) : Boolean
      {
         return Boolean(this._colors) && Boolean(this._colors[param1]);
      }
      
      public function resetColor(param1:uint) : void
      {
         var _loc2_:Object = null;
         if(!this._colors || !this._colors[param1])
         {
            return;
         }
         delete this._colors[param1];
         if(!this._locked)
         {
            for(_loc2_ in this._observers)
            {
               _loc2_.colorsChanged(this);
            }
         }
         else
         {
            this._colorsChangedWhileLocked = true;
         }
      }
      
      public function resetColors() : void
      {
         var _loc1_:Object = null;
         if(!this._colors)
         {
            return;
         }
         this._colors = null;
         if(!this._locked)
         {
            for(_loc1_ in this._observers)
            {
               _loc1_.colorsChanged(this);
            }
         }
         else
         {
            this._colorsChangedWhileLocked = true;
         }
      }
      
      public function setColor(param1:uint, param2:uint) : void
      {
         var _loc3_:Object = null;
         if(!this._colors)
         {
            this._colors = new Array();
         }
         if(Boolean(this._colors[param1]) && this._colors[param1] == param2)
         {
            return;
         }
         if(param2 == 0)
         {
            this._colors[param1] = 1;
         }
         else
         {
            this._colors[param1] = param2;
         }
         if(!this._locked)
         {
            for(_loc3_ in this._observers)
            {
               _loc3_.colorsChanged(this);
            }
         }
         else
         {
            this._colorsChangedWhileLocked = true;
         }
      }
      
      public function getScaleX() : Number
      {
         return this._scaleX;
      }
      
      public function setScaleX(param1:Number) : void
      {
         var _loc2_:Object = null;
         if(this._scaleX == param1)
         {
            return;
         }
         this._scaleX = param1;
         if(!this._locked)
         {
            for(_loc2_ in this._observers)
            {
               _loc2_.scalesChanged(this);
            }
         }
         else
         {
            this._scalesChangedWhileLocked = true;
         }
      }
      
      public function getScaleY() : Number
      {
         return this._scaleY;
      }
      
      public function setScaleY(param1:Number) : void
      {
         var _loc2_:Object = null;
         if(this._scaleY == param1)
         {
            return;
         }
         this._scaleY = param1;
         if(!this._locked)
         {
            for(_loc2_ in this._observers)
            {
               _loc2_.scalesChanged(this);
            }
         }
         else
         {
            this._scalesChangedWhileLocked = true;
         }
      }
      
      public function setScales(param1:Number, param2:Number) : void
      {
         var _loc3_:Object = null;
         if(this._scaleX == param1 && this._scaleY == param2)
         {
            return;
         }
         this._scaleX = param1;
         this._scaleY = param2;
         if(!this._locked)
         {
            for(_loc3_ in this._observers)
            {
               _loc3_.scalesChanged(this);
            }
         }
         else
         {
            this._scalesChangedWhileLocked = true;
         }
      }
      
      public function getSubEntities(param1:Boolean = false) : Array
      {
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         if(!this._subEntities)
         {
            return null;
         }
         if(param1)
         {
            return this._subEntities;
         }
         var _loc2_:Array = new Array();
         for(_loc3_ in this._subEntities)
         {
            _loc4_ = uint(_loc3_);
            if(!_loc2_[_loc4_])
            {
               _loc2_[_loc4_] = new Array();
            }
            for(_loc5_ in this._subEntities[_loc3_])
            {
               _loc6_ = uint(_loc5_);
               _loc2_[_loc4_][_loc6_] = this._subEntities[_loc3_][_loc5_];
            }
         }
         return _loc2_;
      }
      
      public function getSubEntitiesFromCategory(param1:uint) : Array
      {
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         if(!this._subEntities)
         {
            return null;
         }
         var _loc2_:Array = new Array();
         for(_loc3_ in this._subEntities[param1])
         {
            _loc4_ = uint(_loc3_);
            _loc2_[_loc4_] = this._subEntities[param1][_loc3_];
         }
         return _loc2_;
      }
      
      public function getSubEntity(param1:uint, param2:uint) : TiphonEntityLook
      {
         if(!this._subEntities)
         {
            return null;
         }
         if(!this._subEntities[param1])
         {
            return null;
         }
         return this._subEntities[param1][param2];
      }
      
      public function resetSubEntities() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:TiphonEntityLook = null;
         var _loc4_:Object = null;
         if(!this._subEntities)
         {
            return;
         }
         for(_loc1_ in this._subEntities)
         {
            for(_loc2_ in this._subEntities[_loc1_])
            {
               _loc3_ = this._subEntities[_loc1_][_loc2_];
               _loc3_.removeObserver(this);
            }
         }
         this._subEntities = null;
         if(!this._locked)
         {
            for(_loc4_ in this._observers)
            {
               _loc4_.subEntitiesChanged(this);
            }
         }
         else
         {
            this._subEntitiesChangedWhileLocked = true;
         }
      }
      
      public function addSubEntity(param1:uint, param2:uint, param3:TiphonEntityLook) : void
      {
         var _loc4_:Object = null;
         if(!this._subEntities)
         {
            this._subEntities = new Array();
         }
         if(!this._subEntities[param1])
         {
            this._subEntities[param1] = new Array();
         }
         param3.addObserver(this);
         this._subEntities[param1][param2] = param3;
         if(!this._locked)
         {
            for(_loc4_ in this._observers)
            {
               _loc4_.subEntitiesChanged(this);
            }
         }
         else
         {
            this._subEntitiesChangedWhileLocked = true;
         }
      }
      
      public function removeSubEntity(param1:uint, param2:uint = 0) : void
      {
         var _loc3_:Object = null;
         if(!this._subEntities || !this._subEntities[param1] || !this._subEntities[param1][param2])
         {
            return;
         }
         delete this._subEntities[param1][param2];
         if(this._subEntities[param1].length == 1)
         {
            delete this._subEntities[param1];
         }
         if(!this._locked)
         {
            for(_loc3_ in this._observers)
            {
               _loc3_.subEntitiesChanged(this);
            }
         }
         else
         {
            this._subEntitiesChangedWhileLocked = true;
         }
      }
      
      public function lock() : void
      {
         if(this._locked)
         {
            return;
         }
         this._locked = true;
         this._boneChangedWhileLocked = false;
         this._skinsChangedWhileLocked = false;
         this._colorsChangedWhileLocked = false;
         this._scalesChangedWhileLocked = false;
         this._subEntitiesChangedWhileLocked = false;
      }
      
      public function unlock(param1:Boolean = false) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         if(!this._locked)
         {
            return;
         }
         this._locked = false;
         if(!param1)
         {
            if(this._boneChangedWhileLocked)
            {
               for(_loc2_ in this._observers)
               {
                  _loc2_.boneChanged(this);
               }
               this._boneChangedWhileLocked = false;
            }
            if(this._skinsChangedWhileLocked)
            {
               for(_loc3_ in this._observers)
               {
                  _loc3_.skinsChanged(this);
               }
               this._skinsChangedWhileLocked = false;
            }
            if(this._colorsChangedWhileLocked)
            {
               for(_loc4_ in this._observers)
               {
                  _loc4_.colorsChanged(this);
               }
               this._colorsChangedWhileLocked = false;
            }
            if(this._scalesChangedWhileLocked)
            {
               for(_loc5_ in this._observers)
               {
                  _loc5_.scalesChanged(this);
               }
               this._scalesChangedWhileLocked = false;
            }
            if(this._subEntitiesChangedWhileLocked)
            {
               for(_loc6_ in this._observers)
               {
                  _loc6_.subEntitiesChanged(this);
               }
               this._subEntitiesChangedWhileLocked = false;
            }
         }
      }
      
      public function addObserver(param1:EntityLookObserver) : void
      {
         if(!this._observers)
         {
            this._observers = new Dictionary(true);
         }
         this._observers[param1] = 1;
      }
      
      public function removeObserver(param1:EntityLookObserver) : void
      {
         if(!this._observers)
         {
            return;
         }
         delete this._observers[param1];
      }
      
      public function toString() : String
      {
         return EntityLookParser.toString(this);
      }
      
      public function equals(param1:TiphonEntityLook) : Boolean
      {
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:TiphonEntityLook = null;
         var _loc9_:String = null;
         var _loc10_:TiphonEntityLook = null;
         if(this._bone != param1._bone)
         {
            return false;
         }
         if(this._scaleX != param1._scaleX)
         {
            return false;
         }
         if(this._scaleY != param1._scaleY)
         {
            return false;
         }
         if(this._skins == null && param1._skins != null || this._skins != null && param1._skins == null)
         {
            return false;
         }
         if(Boolean(this._skins) && Boolean(param1._skins))
         {
            if(this._skins.length != param1._skins.length)
            {
               return false;
            }
            for each(_loc2_ in this._skins)
            {
               if(param1._skins.indexOf(_loc2_) == -1)
               {
                  return false;
               }
            }
         }
         if(this._colors == null && param1._colors != null || this._colors != null && param1._colors == null)
         {
            return false;
         }
         if(Boolean(this._colors) && Boolean(param1._colors))
         {
            for(_loc3_ in this._colors)
            {
               if(param1._colors[_loc3_] != this._colors[_loc3_])
               {
                  return false;
               }
            }
            for(_loc4_ in param1._colors)
            {
               if(this._colors[_loc4_] != param1._colors[_loc4_])
               {
                  return false;
               }
            }
         }
         if(this._subEntities == null && param1._subEntities != null || this._subEntities != null && param1._subEntities == null)
         {
            return false;
         }
         if(Boolean(this._subEntities) && Boolean(param1._subEntities))
         {
            for(_loc5_ in this._subEntities)
            {
               if(!param1._subEntities || param1._subEntities[_loc5_] == null)
               {
                  return false;
               }
               for(_loc7_ in this._subEntities[_loc5_])
               {
                  _loc8_ = param1._subEntities[_loc5_][_loc7_];
                  if(_loc8_ == null)
                  {
                     return false;
                  }
                  if(!_loc8_.equals(this._subEntities[_loc5_][_loc7_]))
                  {
                     return false;
                  }
               }
            }
            for(_loc6_ in param1._subEntities)
            {
               if(!this._subEntities || this._subEntities[_loc6_] == null)
               {
                  return false;
               }
               for(_loc9_ in param1._subEntities[_loc6_])
               {
                  _loc10_ = this._subEntities[_loc6_][_loc9_];
                  if(_loc10_ == null)
                  {
                     return false;
                  }
                  if(!_loc10_.equals(param1._subEntities[_loc6_][_loc9_]))
                  {
                     return false;
                  }
               }
            }
         }
         return true;
      }
      
      public function updateFrom(param1:TiphonEntityLook) : void
      {
         if(this.equals(param1))
         {
            return;
         }
         this.lock();
         this._boneChangedWhileLocked = true;
         this.setBone(param1.getBone());
         this.resetColors();
         this._colorsChangedWhileLocked = true;
         this._colors = param1.getColors();
         this.resetSkins();
         this._skinsChangedWhileLocked = true;
         this._skins = param1.getSkins();
         this._defaultSkin = param1.defaultSkin;
         this.resetSubEntities();
         this._subEntitiesChangedWhileLocked = true;
         this._subEntities = param1.getSubEntities();
         this.setScales(param1.getScaleX(),param1.getScaleY());
         this._scalesChangedWhileLocked = true;
         this.unlock(false);
      }
      
      public function boneChanged(param1:TiphonEntityLook) : void
      {
         var _loc2_:Object = null;
         if(!this._locked)
         {
            for(_loc2_ in this._observers)
            {
               _loc2_.subEntitiesChanged(this);
            }
         }
         else
         {
            this._subEntitiesChangedWhileLocked = true;
         }
      }
      
      public function skinsChanged(param1:TiphonEntityLook) : void
      {
         var _loc2_:Object = null;
         if(!this._locked)
         {
            for(_loc2_ in this._observers)
            {
               _loc2_.subEntitiesChanged(this);
            }
         }
         else
         {
            this._subEntitiesChangedWhileLocked = true;
         }
      }
      
      public function colorsChanged(param1:TiphonEntityLook) : void
      {
         var _loc2_:Object = null;
         if(!this._locked)
         {
            for(_loc2_ in this._observers)
            {
               _loc2_.subEntitiesChanged(this);
            }
         }
         else
         {
            this._subEntitiesChangedWhileLocked = true;
         }
      }
      
      public function scalesChanged(param1:TiphonEntityLook) : void
      {
         var _loc2_:Object = null;
         if(!this._locked)
         {
            for(_loc2_ in this._observers)
            {
               _loc2_.subEntitiesChanged(this);
            }
         }
         else
         {
            this._subEntitiesChangedWhileLocked = true;
         }
      }
      
      public function subEntitiesChanged(param1:TiphonEntityLook) : void
      {
         var _loc2_:Object = null;
         if(!this._locked)
         {
            for(_loc2_ in this._observers)
            {
               _loc2_.subEntitiesChanged(this);
            }
         }
         else
         {
            this._subEntitiesChangedWhileLocked = true;
         }
      }
      
      public function clone() : TiphonEntityLook
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc1_:TiphonEntityLook = new TiphonEntityLook();
         _loc1_._bone = this._bone;
         _loc1_._colors = !!this._colors ? this._colors.concat() : this._colors;
         _loc1_._skins = !!this._skins ? this._skins.concat() : this._skins;
         _loc1_._defaultSkin = this._defaultSkin;
         _loc1_._scaleX = this._scaleX;
         _loc1_._scaleY = this._scaleY;
         if(this._subEntities)
         {
            _loc1_._subEntities = [];
            for(_loc2_ in this._subEntities)
            {
               _loc1_._subEntities[_loc2_] = [];
               for(_loc3_ in this._subEntities[_loc2_])
               {
                  if(this._subEntities[_loc2_][_loc3_])
                  {
                     _loc1_._subEntities[_loc2_][_loc3_] = this._subEntities[_loc2_][_loc3_].clone();
                  }
               }
            }
         }
         return _loc1_;
      }
   }
}

