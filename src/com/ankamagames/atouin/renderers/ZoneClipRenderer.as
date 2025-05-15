package com.ankamagames.atouin.renderers
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.types.DataMapContainer;
   import com.ankamagames.atouin.types.ZoneClipTile;
   import com.ankamagames.atouin.utils.IZoneRenderer;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import com.ankamagames.jerakine.utils.prng.PRNG;
   import com.ankamagames.jerakine.utils.prng.ParkMillerCarta;
   
   public class ZoneClipRenderer implements IZoneRenderer
   {
      private static var zoneTile:Array = new Array();
      
      private var _uri:Uri;
      
      private var _clipName:Array;
      
      private var _currentMapId:int;
      
      private var _needBorders:Boolean;
      
      protected var _aZoneTile:Array;
      
      protected var _aCellTile:Array;
      
      public var strata:uint = 0;
      
      protected var _cells:Vector.<uint>;
      
      public function ZoneClipRenderer(param1:uint, param2:String, param3:Array, param4:int = -1, param5:Boolean = false)
      {
         super();
         this._aZoneTile = new Array();
         this._aCellTile = new Array();
         this.strata = param1;
         this._currentMapId = param4;
         this._needBorders = param5;
         this._uri = new Uri(param2);
         this._clipName = param3;
         Atouin.getInstance().options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
      }
      
      private static function getZoneTile(param1:Uri, param2:String, param3:Boolean) : ZoneClipTile
      {
         var _loc5_:ZoneClipTile = null;
         var _loc4_:CachedTile = getData(param1.fileName,param2);
         if(_loc4_.length)
         {
            return _loc4_.shift();
         }
         return new ZoneClipTile(param1,param2,param3);
      }
      
      private static function destroyZoneTile(param1:ZoneClipTile) : void
      {
         param1.remove();
         var _loc2_:CachedTile = getData(param1.uri.fileName,param1.clipName);
         _loc2_.push(param1);
      }
      
      private static function getData(param1:String, param2:String) : CachedTile
      {
         var _loc3_:int = 0;
         var _loc4_:int = int(zoneTile.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(zoneTile[_loc3_].uriName == param1 && zoneTile[_loc3_].clipName == param2)
            {
               return zoneTile[_loc3_] as CachedTile;
            }
            _loc3_ += 1;
         }
         var _loc5_:CachedTile = new CachedTile(param1,param2);
         zoneTile.push(_loc5_);
         return _loc5_;
      }
      
      public function render(param1:Vector.<uint>, param2:Color, param3:DataMapContainer, param4:Boolean = false, param5:Boolean = false) : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:ZoneClipTile = null;
         this._cells = param1;
         var _loc6_:PRNG = new ParkMillerCarta();
         _loc6_.seed(this._currentMapId + 5435);
         var _loc10_:int = int(param1.length);
         _loc8_ = 0;
         while(_loc8_ < _loc10_)
         {
            _loc9_ = this._aZoneTile[_loc8_];
            if(!_loc9_)
            {
               _loc7_ = int(_loc6_.nextIntR(0,this._clipName.length * 8));
               _loc9_ = getZoneTile(this._uri,this._clipName[_loc7_ < 0 || _loc7_ > this._clipName.length - 1 ? 0 : _loc7_],this._needBorders);
               this._aZoneTile[_loc8_] = _loc9_;
               _loc9_.strata = this.strata;
            }
            this._aCellTile[_loc8_] = param1[_loc8_];
            _loc9_.cellId = param1[_loc8_];
            _loc9_.display();
            _loc8_++;
         }
         while(_loc8_ < _loc10_)
         {
            _loc9_ = this._aZoneTile[_loc8_];
            if(_loc9_)
            {
               destroyZoneTile(_loc9_);
            }
            _loc8_++;
         }
      }
      
      public function remove(param1:Vector.<uint>, param2:DataMapContainer) : void
      {
         var _loc4_:int = 0;
         var _loc8_:ZoneClipTile = null;
         if(!param1)
         {
            return;
         }
         var _loc3_:int = 0;
         var _loc5_:Array = new Array();
         var _loc6_:int = int(param1.length);
         _loc4_ = 0;
         while(_loc4_ < _loc6_)
         {
            _loc5_[param1[_loc4_]] = true;
            _loc4_++;
         }
         _loc6_ = int(this._aCellTile.length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            if(_loc5_[this._aCellTile[_loc7_]])
            {
               _loc3_++;
               _loc8_ = this._aZoneTile[_loc7_];
               if(_loc8_)
               {
                  destroyZoneTile(_loc8_);
               }
               this._aCellTile.splice(_loc7_,1);
               this._aZoneTile.splice(_loc7_,1);
               _loc7_--;
               _loc6_--;
            }
            _loc7_++;
         }
      }
      
      private function onPropertyChanged(param1:PropertyChangeEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ZoneClipTile = null;
         if(param1.propertyName == "transparentOverlayMode")
         {
            _loc2_ = 0;
            while(_loc2_ < this._aZoneTile.length)
            {
               _loc3_ = this._aZoneTile[_loc2_];
               _loc3_.remove();
               _loc3_.display();
               _loc2_++;
            }
         }
      }
   }
}

import com.ankamagames.atouin.types.ZoneClipTile;

class CachedTile
{
   public var uriName:String;
   
   public var clipName:String;
   
   private var _list:Vector.<ZoneClipTile>;
   
   public function CachedTile(param1:String, param2:String)
   {
      super();
      this.uriName = param1;
      this.clipName = param2;
      this._list = new Vector.<ZoneClipTile>();
   }
   
   public function push(param1:ZoneClipTile) : void
   {
      this._list.push(param1);
   }
   
   public function shift() : ZoneClipTile
   {
      return this._list.shift();
   }
   
   public function get length() : uint
   {
      return this._list.length;
   }
}
