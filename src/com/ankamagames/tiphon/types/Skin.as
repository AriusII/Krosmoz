package com.ankamagames.tiphon.types
{
   import com.ankamagames.jerakine.data.CensoredContentManager;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.types.Swl;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.tiphon.TiphonConstants;
   import com.ankamagames.tiphon.engine.Tiphon;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.ProgressEvent;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class Skin extends EventDispatcher
   {
      private static var _censoredSkin:Dictionary;
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(Skin));
      
      private static var _alternativeSkin:Dictionary = new Dictionary();
      
      private var _ressourceCount:uint = 0;
      
      private var _ressourceLoading:uint = 0;
      
      private var _skinParts:Array;
      
      private var _skinClass:Array;
      
      private var _aSkinPartOrdered:Array;
      
      private var _validate:Boolean = true;
      
      public function Skin()
      {
         super();
         this._skinParts = new Array();
         this._skinClass = new Array();
         this._aSkinPartOrdered = new Array();
      }
      
      public static function addAlternativeSkin(param1:uint, param2:uint) : void
      {
         if(!_alternativeSkin[param1])
         {
            _alternativeSkin[param1] = new Array();
         }
         _alternativeSkin[param1].push(param2);
      }
      
      public function get complete() : Boolean
      {
         var _loc2_:uint = 0;
         if(!this._validate)
         {
            return false;
         }
         var _loc1_:Boolean = true;
         for each(_loc2_ in this._aSkinPartOrdered)
         {
            _loc1_ &&= Tiphon.skinLibrary.isLoaded(_loc2_) || Tiphon.skinLibrary.hasError(_loc2_);
         }
         return _loc1_;
      }
      
      public function get validate() : Boolean
      {
         return this._validate;
      }
      
      public function set validate(param1:Boolean) : void
      {
         this._validate = param1;
         if(param1 && this.complete)
         {
            this.processSkin();
         }
      }
      
      public function add(param1:uint, param2:int = -1) : uint
      {
         var _loc3_:int = -1;
         if(!_censoredSkin)
         {
            _censoredSkin = CensoredContentManager.getInstance().getCensoredIndex(2);
         }
         if(_censoredSkin[param1])
         {
            param1 = uint(_censoredSkin[param1]);
         }
         if(param2 != -1 && _alternativeSkin && Boolean(_alternativeSkin[param1]) && param2 < _alternativeSkin[param1].length)
         {
            _loc3_ = int(param1);
            param1 = uint(_alternativeSkin[param1][param2]);
         }
         var _loc4_:Array = new Array();
         var _loc5_:uint = 0;
         while(_loc5_ < this._aSkinPartOrdered.length)
         {
            if(this._aSkinPartOrdered[_loc5_] != param1 && this._aSkinPartOrdered[_loc5_] != _loc3_)
            {
               _loc4_.push(this._aSkinPartOrdered[_loc5_]);
            }
            _loc5_++;
         }
         _loc4_.push(param1);
         if(this._aSkinPartOrdered.length != _loc4_.length)
         {
            this._aSkinPartOrdered = _loc4_;
            ++this._ressourceLoading;
            Tiphon.skinLibrary.addResource(param1,new Uri(TiphonConstants.SWF_SKIN_PATH + param1 + ".swl"));
            Tiphon.skinLibrary.askResource(param1,null,new Callback(this.onResourceLoaded,param1),new Callback(this.onResourceLoaded,param1));
         }
         else
         {
            this._aSkinPartOrdered = _loc4_;
         }
         return param1;
      }
      
      public function getPart(param1:String) : Sprite
      {
         var _loc2_:Sprite = this._skinParts[param1];
         if(Boolean(_loc2_) && !_loc2_.parent)
         {
            return _loc2_;
         }
         if(this._skinClass[param1])
         {
            _loc2_ = new this._skinClass[param1]();
            this._skinParts[param1] = _loc2_;
            return _loc2_;
         }
         return null;
      }
      
      public function reset() : void
      {
         this._skinParts = new Array();
         this._skinClass = new Array();
         this._aSkinPartOrdered = new Array();
      }
      
      private function onResourceLoaded(param1:uint) : void
      {
         ++this._ressourceCount;
         --this._ressourceLoading;
         this.processSkin();
      }
      
      private function processSkin() : void
      {
         var _loc1_:uint = 0;
         var _loc3_:Swl = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this._aSkinPartOrdered.length)
         {
            _loc1_ = uint(this._aSkinPartOrdered[_loc2_]);
            _loc3_ = Tiphon.skinLibrary.getResourceById(_loc1_);
            if(_loc3_)
            {
               _loc4_ = _loc3_.getDefinitions();
               for each(_loc5_ in _loc4_)
               {
                  this._skinClass[_loc5_] = _loc3_.getDefinition(_loc5_);
                  delete this._skinParts[_loc5_];
               }
            }
            _loc2_++;
         }
         if(this.complete)
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
         else
         {
            dispatchEvent(new Event(ProgressEvent.PROGRESS));
         }
      }
   }
}

