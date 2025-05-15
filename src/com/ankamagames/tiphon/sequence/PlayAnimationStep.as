package com.ankamagames.tiphon.sequence
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import flash.events.TimerEvent;
   import flash.utils.getQualifiedClassName;
   
   public class PlayAnimationStep extends AbstractSequencable
   {
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(PlayAnimationStep));
      
      private var _target:TiphonSprite;
      
      private var _animationName:String;
      
      private var _loop:int;
      
      private var _endEvent:String;
      
      private var _waitEvent:Boolean;
      
      private var _lastAnimName:String;
      
      private var _lastSpriteAnimation:String;
      
      private var _backToLastAnimationAtEnd:Boolean;
      
      private var _callbackExecuted:Boolean = false;
      
      public function PlayAnimationStep(param1:TiphonSprite, param2:String, param3:Boolean = true, param4:Boolean = true, param5:String = "animation_event_end", param6:int = 1)
      {
         super();
         this._endEvent = param5;
         this._target = param1;
         this._animationName = param2;
         this._loop = param6;
         this._waitEvent = param4;
         this._backToLastAnimationAtEnd = param3;
      }
      
      public function get target() : TiphonSprite
      {
         return this._target;
      }
      
      public function get animation() : String
      {
         return this._animationName;
      }
      
      public function set waitEvent(param1:Boolean) : void
      {
         this._waitEvent = param1;
      }
      
      override public function start() : void
      {
         var _loc2_:String = null;
         if(this._target.isShowingOnlyBackground())
         {
            this._callbackExecuted = true;
            executeCallbacks();
            return;
         }
         if(this._endEvent != TiphonEvent.ANIMATION_END)
         {
            this._target.addEventListener(this._endEvent,this.onCustomEvent);
         }
         this._target.addEventListener(TiphonEvent.ANIMATION_END,this.onAnimationEnd);
         this._target.addEventListener(TiphonEvent.RENDER_FAILED,this.onAnimationFail);
         this._target.addEventListener(TiphonEvent.SPRITE_INIT_FAILED,this.onAnimationFail);
         this._lastAnimName = this._target.getAnimation();
         this._target.overrideNextAnimation = true;
         var _loc1_:Array = this._target.getAvaibleDirection(this._animationName,true);
         if(!_loc1_[this._target.getDirection()])
         {
            for(_loc2_ in _loc1_)
            {
               if(_loc1_[_loc2_])
               {
                  this._target.setDirection(uint(_loc2_));
                  break;
               }
            }
         }
         this._target.setAnimation(this._animationName);
         this._lastSpriteAnimation = this._target.getAnimation();
         if(!this._waitEvent)
         {
            this._callbackExecuted = true;
            executeCallbacks();
         }
      }
      
      private function onCustomEvent(param1:TiphonEvent) : void
      {
         this._target.removeEventListener(this._endEvent,this.onCustomEvent);
         this._callbackExecuted = true;
         executeCallbacks();
      }
      
      private function onAnimationFail(param1:TiphonEvent) : void
      {
         if(this._endEvent != TiphonEvent.ANIMATION_END)
         {
            this.onCustomEvent(param1);
         }
         this.onAnimationEnd(param1);
      }
      
      private function onAnimationEnd(param1:TiphonEvent) : void
      {
         var _loc2_:String = null;
         if(this._target)
         {
            if(this._endEvent != TiphonEvent.ANIMATION_END)
            {
               this._target.removeEventListener(this._endEvent,this.onCustomEvent);
            }
            this._target.removeEventListener(TiphonEvent.ANIMATION_END,this.onAnimationEnd);
            this._target.removeEventListener(TiphonEvent.RENDER_FAILED,this.onAnimationEnd);
            this._target.removeEventListener(TiphonEvent.SPRITE_INIT_FAILED,this.onAnimationFail);
            _loc2_ = this._target.getAnimation();
            if(this._backToLastAnimationAtEnd)
            {
               if(Boolean(_loc2_) && Boolean(this._lastSpriteAnimation) && this._lastSpriteAnimation.indexOf(_loc2_) != -1)
               {
                  this._target.setAnimation("AnimStatique");
               }
            }
         }
         if(!this._callbackExecuted)
         {
            executeCallbacks();
         }
      }
      
      override public function toString() : String
      {
         return "play " + this._animationName + " on " + (!!this._target ? this._target.name : this._target);
      }
      
      override protected function onTimeOut(param1:TimerEvent) : void
      {
         this._callbackExecuted = true;
         this.onAnimationEnd(null);
         super.onTimeOut(param1);
      }
   }
}

