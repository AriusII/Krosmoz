package com.ankamagames.tiphon.types
{
   import flash.display.Sprite;
   import flash.utils.getQualifiedClassName;
   
   public class EquipmentSprite extends DynamicSprite
   {
      private static var n:uint = 0;
      
      public function EquipmentSprite()
      {
         super();
      }
      
      override public function init(param1:IAnimationSpriteHandler) : void
      {
         var _loc3_:uint = 0;
         if(getQualifiedClassName(parent) == getQualifiedClassName(this))
         {
            return;
         }
         var _loc2_:Sprite = param1.getSkinSprite(this);
         if(Boolean(_loc2_) && _loc2_ != this)
         {
            _loc3_ = 0;
            while(Boolean(numChildren) && _loc3_ != numChildren)
            {
               _loc3_ = uint(numChildren);
               removeChildAt(0);
            }
            addChild(_loc2_);
         }
      }
   }
}

