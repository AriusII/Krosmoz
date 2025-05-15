package com.ankamagames.berilia.managers
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.components.params.TooltipProperties;
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.factories.TooltipsFactory;
   import com.ankamagames.berilia.interfaces.IApplicationContainer;
   import com.ankamagames.berilia.types.data.UiData;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.event.UiRenderEvent;
   import com.ankamagames.berilia.types.event.UiUnloadEvent;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.berilia.types.tooltip.Tooltip;
   import com.ankamagames.berilia.types.tooltip.TooltipRectangle;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class TooltipManager
   {
      public static var defaultTooltipUiScript:Class;
      
      protected static var _log:Logger = Log.getLogger(getQualifiedClassName(TooltipManager));
      
      private static var _tooltips:Array = new Array();
      
      private static var _tooltipsStrata:Array = new Array();
      
      private static var _tooltipsDico:Dictionary = new Dictionary();
      
      private static const TOOLTIP_UI_NAME_PREFIX:String = "tooltip_";
      
      public static const TOOLTIP_STANDAR_NAME:String = "standard";
      
      public static var _tooltipCache:Dictionary = new Dictionary();
      
      public static var _tooltipCacheParam:Dictionary = new Dictionary();
      
      private static var _isInit:Boolean = false;
      
      public function TooltipManager()
      {
         super();
      }
      
      public static function show(param1:*, param2:*, param3:UiModule, param4:Boolean = true, param5:String = "standard", param6:uint = 0, param7:uint = 2, param8:int = 3, param9:Boolean = true, param10:String = null, param11:Class = null, param12:Object = null, param13:String = null, param14:Boolean = false, param15:int = 4, param16:Number = 1) : Tooltip
      {
         var _loc18_:Array = null;
         var _loc19_:Tooltip = null;
         if(!_isInit)
         {
            Berilia.getInstance().addEventListener(UiRenderEvent.UIRenderComplete,onUiRenderComplete);
            Berilia.getInstance().addEventListener(UiUnloadEvent.UNLOAD_UI_STARTED,onUiUnloadStarted);
            _isInit = true;
         }
         param5 = (param9 ? TOOLTIP_UI_NAME_PREFIX : "") + param5;
         if(param11 == null)
         {
            param11 = defaultTooltipUiScript;
         }
         if(_tooltips[param5])
         {
            hide(param5);
         }
         if(param13)
         {
            _loc18_ = param13.split("#");
            if(_tooltipCache[_loc18_[0]] && _loc18_.length == 1 || _tooltipCache[_loc18_[0]] && _loc18_.length > 1 && _tooltipCacheParam[_loc18_[0]] == _loc18_[1])
            {
               _loc19_ = _tooltipCache[_loc18_[0]] as Tooltip;
               _tooltips[param5] = param1;
               _tooltipsStrata[param5] = _loc19_.display.strata;
               Berilia.getInstance().uiList[param5] = _loc19_.display;
               DisplayObjectContainer(Berilia.getInstance().docMain.getChildAt(param15 + 1)).addChild(_loc19_.display);
               if(_loc19_ != null && _loc19_.display != null)
               {
                  _loc19_.display.x = _loc19_.display.y = 0;
                  _loc19_.display.scaleX = _loc19_.display.scaleY = param16;
                  _loc19_.display.uiClass.main(new TooltipProperties(_loc19_,param4,getTargetRect(param2),param6,param7,param8,SecureCenter.secure(param1),param12,param16));
               }
               return _loc19_;
            }
         }
         var _loc17_:Tooltip = TooltipsFactory.create(param1,param10,param11,param12);
         if(!_loc17_)
         {
            _log.error("Erreur lors du rendu du tooltip de " + param1 + " (" + getQualifiedClassName(param1) + ")");
            return null;
         }
         if(param3)
         {
            _loc17_.uiModuleName = param3.id;
         }
         _tooltips[param5] = param1;
         if(param14)
         {
            param15 = StrataEnum.STRATA_TOP;
         }
         _loc17_.askTooltip(new Callback(onTooltipReady,_loc17_,param3,param5,param1,param2,param4,param6,param7,param8,param13,param15,param12,param16));
         _tooltipsDico[param5] = _loc17_;
         return _loc17_;
      }
      
      public static function hide(param1:String = "standard") : void
      {
         if(param1 == null)
         {
            param1 = TOOLTIP_STANDAR_NAME;
         }
         if(param1.indexOf(TOOLTIP_UI_NAME_PREFIX) == -1)
         {
            param1 = TOOLTIP_UI_NAME_PREFIX + param1;
         }
         if(_tooltips[param1])
         {
            Berilia.getInstance().unloadUi(param1);
            delete _tooltips[param1];
            delete _tooltipsDico[param1];
         }
      }
      
      public static function isVisible(param1:String) : Boolean
      {
         if(param1.indexOf(TOOLTIP_UI_NAME_PREFIX) == -1)
         {
            param1 = TOOLTIP_UI_NAME_PREFIX + param1;
         }
         return _tooltips[param1] != null;
      }
      
      public static function updateContent(param1:String, param2:String, param3:Object) : void
      {
         var _loc4_:Tooltip = null;
         if(isVisible(param2))
         {
            _loc4_ = _tooltipCache[param1] as Tooltip;
            if(_loc4_)
            {
               _loc4_.display.uiClass.updateContent(new TooltipProperties(_loc4_,false,null,0,0,0,param3,null));
            }
         }
      }
      
      public static function hideAll() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:Tooltip = null;
         for(_loc1_ in _tooltips)
         {
            _loc2_ = int(_tooltipsStrata[_loc1_]);
            _loc3_ = _tooltipsDico[_loc1_];
            if((_loc2_ == StrataEnum.STRATA_TOOLTIP || _loc2_ == StrataEnum.STRATA_WORLD) && (_loc3_ == null || _loc3_.mustBeHidden))
            {
               hide(_loc1_);
            }
         }
      }
      
      public static function clearCache() : void
      {
         var _loc2_:Tooltip = null;
         var _loc1_:Berilia = Berilia.getInstance();
         for each(_loc2_ in _tooltipCache)
         {
            _loc2_.display.cached = false;
            _loc1_.uiList[_loc2_.display.name] = _loc2_.display;
            _loc1_.unloadUi(_loc2_.display.name);
         }
         _tooltipCache = new Dictionary();
         _tooltipCacheParam = new Dictionary();
      }
      
      private static function onTooltipReady(param1:Tooltip, param2:UiModule, param3:String, param4:*, param5:*, param6:Boolean, param7:uint, param8:uint, param9:int, param10:String, param11:int, param12:Object, param13:Number) : void
      {
         var _loc16_:UiData = null;
         var _loc17_:Array = null;
         var _loc14_:* = param10 != null;
         var _loc15_:Boolean = Boolean(_tooltips[param3]) && _tooltips[param3] === param4;
         _tooltipsStrata[param3] = param11;
         if(_loc15_ || Boolean(param10))
         {
            _loc16_ = new UiData(param2,param3,null,null);
            _loc16_.xml = param1.content;
            _loc16_.uiClass = param1.scriptClass;
            param1.display = Berilia.getInstance().loadUi(param2,_loc16_,param3,new TooltipProperties(param1,param6,getTargetRect(param5),param7,param8,param9,SecureCenter.secure(param4),param12,param13),true,param11,!_loc15_,null);
            if(param10)
            {
               _loc17_ = param10.split("#");
               _tooltipCache[_loc17_[0]] = param1;
               if(_loc17_.length > 0)
               {
                  _tooltipCacheParam[_loc17_[0]] = _loc17_[1];
               }
               param1.display.cached = true;
               param1.display.cacheAsBitmap = true;
               if(param1.display.scale != param13)
               {
                  param1.display.scale = param13;
               }
            }
            else
            {
               param1.display.scale = param13;
            }
         }
      }
      
      private static function getTargetRect(param1:*) : TooltipRectangle
      {
         var _loc2_:Point = null;
         var _loc4_:Point = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Boolean = false;
         var _loc8_:TooltipRectangle = null;
         var _loc3_:* = SecureCenter.unsecure(param1);
         if(_loc3_)
         {
            if(_loc3_ is Rectangle)
            {
               _loc2_ = new Point(_loc3_.x,_loc3_.y);
            }
            else if(Boolean(_loc3_.hasOwnProperty("parent")) && Boolean(_loc3_.parent))
            {
               _loc2_ = localToGlobal(_loc3_.parent,new Point(_loc3_.x,_loc3_.y));
            }
            else
            {
               _loc2_ = _loc3_.localToGlobal(new Point(_loc3_.x,_loc3_.y));
            }
            _loc4_ = Berilia.getInstance().strataTooltip.globalToLocal(_loc2_);
            _loc5_ = StageShareManager.stageScaleX;
            _loc6_ = StageShareManager.stageScaleY;
            _loc7_ = _loc3_ is DisplayObject ? Berilia.getInstance().docMain.contains(_loc3_) : false;
            return new TooltipRectangle(_loc4_.x * (_loc7_ ? _loc5_ : 1),_loc4_.y * (_loc7_ ? _loc6_ : 1),_loc3_.width / _loc5_,_loc3_.height / _loc6_);
         }
         return null;
      }
      
      private static function localToGlobal(param1:Object, param2:Point = null) : Point
      {
         if(!param2)
         {
            param2 = new Point();
         }
         if(!param1.hasOwnProperty("parent"))
         {
            return param1.localToGlobal(new Point(param1.x,param1.y));
         }
         param2.x += param1.x;
         param2.y += param1.y;
         if(Boolean(param1.parent) && !(param1.parent is IApplicationContainer))
         {
            param2.x *= param1.parent.scaleX;
            param2.y *= param1.parent.scaleY;
            param2 = localToGlobal(param1.parent,param2);
         }
         return param2;
      }
      
      private static function onUiRenderComplete(param1:UiRenderEvent) : void
      {
         TooltipManager.removeTooltipsHiddenByUi(param1.uiTarget.name);
      }
      
      private static function onUiUnloadStarted(param1:UiUnloadEvent) : void
      {
         TooltipManager.removeTooltipsHiddenByUi(param1.name);
      }
      
      private static function removeTooltipsHiddenByUi(param1:String) : void
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:Tooltip = null;
         var _loc8_:Rectangle = null;
         var _loc2_:Berilia = Berilia.getInstance();
         var _loc3_:UiRootContainer = _loc2_.getUi(param1);
         if(!_loc3_ || Boolean(_tooltips[param1]))
         {
            return;
         }
         var _loc4_:Rectangle = _loc3_.getBounds(StageShareManager.stage);
         for(_loc5_ in _tooltips)
         {
            _loc6_ = int(_tooltipsStrata[_loc5_]);
            _loc7_ = _tooltipsDico[_loc5_];
            if((_loc6_ == StrataEnum.STRATA_TOOLTIP || _loc6_ == StrataEnum.STRATA_WORLD) && (_loc7_ == null || _loc7_.mustBeHidden))
            {
               if(_loc2_.getUi(_loc5_))
               {
                  _loc8_ = _loc2_.getUi(_loc5_).getBounds(StageShareManager.stage);
                  if(_loc8_.x > _loc4_.x && _loc8_.x + _loc8_.width < _loc4_.x + _loc4_.width && _loc8_.y > _loc4_.y && _loc8_.y + _loc8_.height < _loc4_.x + _loc4_.height)
                  {
                     hide(_loc5_);
                  }
               }
            }
         }
      }
   }
}

