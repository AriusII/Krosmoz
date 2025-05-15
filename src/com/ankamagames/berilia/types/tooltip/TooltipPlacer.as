package com.ankamagames.berilia.types.tooltip
{
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.display.Rectangle2;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getQualifiedClassName;
   
   public class TooltipPlacer
   {
      private static var _init:Boolean;
      
      protected static var _log:Logger = Log.getLogger(getQualifiedClassName(TooltipPlacer));
      
      private static const _anchors:Array = [];
      
      public function TooltipPlacer()
      {
         super();
      }
      
      private static function init() : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(_init)
         {
            return;
         }
         _init = true;
         var _loc1_:Array = [LocationEnum.POINT_TOPLEFT,LocationEnum.POINT_TOP,LocationEnum.POINT_TOPRIGHT,LocationEnum.POINT_LEFT,LocationEnum.POINT_CENTER,LocationEnum.POINT_RIGHT,LocationEnum.POINT_BOTTOMLEFT,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_BOTTOMRIGHT];
         for each(_loc2_ in _loc1_)
         {
            for each(_loc3_ in _loc1_)
            {
               _anchors.push({
                  "p1":_loc2_,
                  "p2":_loc3_
               });
            }
         }
      }
      
      private static function getAnchors() : Array
      {
         init();
         return _anchors.concat();
      }
      
      public static function place(param1:DisplayObject, param2:IRectangle, param3:uint = 6, param4:uint = 0, param5:int = 3) : void
      {
         var _loc13_:Point = null;
         var _loc14_:Point = null;
         var _loc15_:Rectangle2 = null;
         var _loc16_:Point = null;
         var _loc17_:Rectangle2 = null;
         var _loc18_:int = 0;
         var _loc19_:Object = null;
         var _loc20_:Object = null;
         var _loc21_:Object = null;
         var _loc6_:* = false;
         var _loc7_:Rectangle = param1.getBounds(param1);
         var _loc8_:uint = param3;
         var _loc9_:uint = param4;
         var _loc10_:Boolean = false;
         var _loc11_:Array = getAnchors();
         var _loc12_:Array = new Array();
         while(!_loc6_)
         {
            _loc13_ = new Point(param2.x,param2.y);
            _loc14_ = new Point(param1.x,param1.y);
            _loc15_ = new Rectangle2(param1.x,param1.y,param1.width,param1.height);
            processAnchor(_loc14_,_loc15_,param3);
            processAnchor(_loc13_,param2,param4);
            _loc16_ = makeOffset(param3,param5);
            _loc13_.x -= _loc14_.x - _loc16_.x + _loc7_.left;
            _loc13_.y -= _loc14_.y - _loc16_.y;
            _loc17_ = new Rectangle2(_loc13_.x,_loc13_.y,_loc15_.width,_loc15_.height);
            if(_loc17_.y < 0)
            {
               _loc17_.y = 0;
            }
            if(_loc17_.x < 0)
            {
               _loc17_.x = 0;
            }
            if(_loc17_.y + _loc17_.height > StageShareManager.startHeight)
            {
               _loc17_.y -= _loc17_.height + _loc17_.y - StageShareManager.startHeight;
            }
            if(_loc17_.x + _loc17_.width > StageShareManager.startWidth)
            {
               _loc17_.x -= _loc17_.width + _loc17_.x - StageShareManager.startWidth;
            }
            if(!_loc10_)
            {
               _loc18_ = hitTest(_loc17_,param2);
               _loc6_ = _loc18_ == 0;
               if(!_loc6_)
               {
                  _loc19_ = _loc11_.shift();
                  if(!_loc19_)
                  {
                     _loc20_ = {
                        "size":param2.width * param2.height,
                        "point":{
                           "p1":_loc8_,
                           "p2":_loc9_
                        }
                     };
                     for each(_loc21_ in _loc12_)
                     {
                        if(_loc20_.size > _loc21_.size)
                        {
                           _loc20_ = _loc21_;
                        }
                     }
                     _loc10_ = true;
                     param3 = uint(_loc20_.point.p1);
                     param4 = uint(_loc20_.point.p2);
                  }
                  else
                  {
                     _loc12_.push({
                        "size":_loc18_,
                        "point":{
                           "p1":param3,
                           "p2":param4
                        }
                     });
                     param3 = uint(_loc19_.p1);
                     param4 = uint(_loc19_.p2);
                  }
               }
            }
            else
            {
               _loc6_ = true;
            }
         }
         param1.x = _loc17_.x;
         param1.y = _loc17_.y;
      }
      
      public static function placeWithArrow(param1:DisplayObject, param2:IRectangle) : Object
      {
         var _loc3_:Point = new Point(param1.x,param1.y);
         var _loc4_:Object = {
            "bottomFlip":false,
            "leftFlip":false
         };
         _loc3_.x = param2.x + param2.width / 2 + 5;
         _loc3_.y = param2.y - param1.height;
         if(_loc3_.x + param1.width > StageShareManager.startWidth)
         {
            _loc4_.leftFlip = true;
            _loc3_.x -= param1.width + 10;
         }
         if(_loc3_.y < 0)
         {
            _loc4_.bottomFlip = true;
            _loc3_.y = param2.y + param2.height;
         }
         param1.x = _loc3_.x;
         param1.y = _loc3_.y;
         return _loc4_;
      }
      
      private static function hitTest(param1:IRectangle, param2:IRectangle) : int
      {
         var _loc3_:Rectangle = new Rectangle(param1.x,param1.y,param1.width,param1.height);
         var _loc4_:Rectangle = new Rectangle(param2.x,param2.y,param2.width,param2.height);
         var _loc5_:Rectangle = _loc3_.intersection(_loc4_);
         return _loc5_.width * _loc5_.height;
      }
      
      private static function processAnchor(param1:Point, param2:IRectangle, param3:uint) : Point
      {
         switch(param3)
         {
            case LocationEnum.POINT_TOPLEFT:
               break;
            case LocationEnum.POINT_TOP:
               param1.x += param2.width / 2;
               break;
            case LocationEnum.POINT_TOPRIGHT:
               param1.x += param2.width;
               break;
            case LocationEnum.POINT_LEFT:
               param1.y += param2.height / 2;
               break;
            case LocationEnum.POINT_CENTER:
               param1.x += param2.width / 2;
               param1.y += param2.height / 2;
               break;
            case LocationEnum.POINT_RIGHT:
               param1.x += param2.width;
               param1.y += param2.height / 2;
               break;
            case LocationEnum.POINT_BOTTOMLEFT:
               param1.y += param2.height;
               break;
            case LocationEnum.POINT_BOTTOM:
               param1.x += param2.width / 2;
               param1.y += param2.height;
               break;
            case LocationEnum.POINT_BOTTOMRIGHT:
               param1.x += param2.width;
               param1.y += param2.height;
         }
         return param1;
      }
      
      private static function makeOffset(param1:uint, param2:uint) : Point
      {
         var _loc3_:Point = new Point();
         switch(param1)
         {
            case LocationEnum.POINT_TOPLEFT:
            case LocationEnum.POINT_BOTTOMLEFT:
            case LocationEnum.POINT_LEFT:
               _loc3_.x = param2;
               break;
            case LocationEnum.POINT_TOP:
               break;
            case LocationEnum.POINT_BOTTOMRIGHT:
            case LocationEnum.POINT_TOPRIGHT:
            case LocationEnum.POINT_RIGHT:
               _loc3_.x = -param2;
         }
         switch(param1)
         {
            case LocationEnum.POINT_TOPLEFT:
            case LocationEnum.POINT_TOP:
            case LocationEnum.POINT_TOPRIGHT:
               _loc3_.y = param2;
               break;
            case LocationEnum.POINT_BOTTOMLEFT:
            case LocationEnum.POINT_BOTTOMRIGHT:
            case LocationEnum.POINT_BOTTOM:
               _loc3_.y = -param2;
         }
         return _loc3_;
      }
   }
}

