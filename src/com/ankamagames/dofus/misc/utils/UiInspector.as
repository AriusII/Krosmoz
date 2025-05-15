package com.ankamagames.dofus.misc.utils
{
   import avmplus.getQualifiedClassName;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.managers.UiSoundManager;
   import com.ankamagames.berilia.types.data.BeriliaUiElementSound;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.desktop.Clipboard;
   import flash.desktop.ClipboardFormats;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   
   public class UiInspector
   {
      private var _highlightShape:Shape;
      
      private var _highlightShape2:Shape;
      
      private var _highlightEffect:ColorTransform = new ColorTransform(1.2,1.2,1.2);
      
      private var _normalEffect:ColorTransform = new ColorTransform(1,1,1);
      
      private var _tooltipTf:TextField = new TextField();
      
      private var _tooltip:Sprite = new Sprite();
      
      private var _enable:Boolean;
      
      private var _lastTarget:GraphicContainer;
      
      private var _uiRoot:UiRootContainer;
      
      public function UiInspector()
      {
         super();
         this._highlightShape = new Shape();
         this._highlightShape2 = new Shape();
         this._tooltip.mouseEnabled = false;
         this._tooltipTf.mouseEnabled = false;
         var _loc1_:TextFormat = new TextFormat("Verdana");
         this._tooltipTf.defaultTextFormat = _loc1_;
         this._tooltipTf.setTextFormat(_loc1_);
         this._tooltipTf.multiline = true;
         this._tooltip.addChild(this._tooltipTf);
         this._tooltipTf.autoSize = TextFieldAutoSize.LEFT;
      }
      
      public function set enable(param1:Boolean) : void
      {
         if(param1)
         {
            StageShareManager.stage.addEventListener(MouseEvent.MOUSE_OVER,this.onRollover);
            StageShareManager.stage.addEventListener(MouseEvent.MOUSE_OUT,this.onRollout);
            StageShareManager.stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         }
         else
         {
            StageShareManager.stage.removeEventListener(MouseEvent.MOUSE_OVER,this.onRollover);
            StageShareManager.stage.removeEventListener(MouseEvent.MOUSE_OUT,this.onRollout);
            StageShareManager.stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
            this.onRollout(this._lastTarget);
         }
         this._enable = param1;
      }
      
      public function get enable() : Boolean
      {
         return this._enable;
      }
      
      private function onRollout(param1:*) : void
      {
         var _loc3_:GraphicContainer = null;
         if(this._highlightShape2.parent)
         {
            StageShareManager.stage.removeChild(this._highlightShape2);
         }
         if(this._highlightShape.parent)
         {
            StageShareManager.stage.removeChild(this._highlightShape);
         }
         if(this._tooltip.parent)
         {
            StageShareManager.stage.removeChild(this._tooltip);
         }
         var _loc2_:Array = this.getBeriliaElement(param1 is DisplayObject ? param1 : param1.target);
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_ is UiRootContainer)
            {
               _loc3_.transform.colorTransform = this._normalEffect;
            }
         }
      }
      
      private function onRollover(param1:MouseEvent) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Rectangle = null;
         var _loc6_:GraphicContainer = null;
         var _loc7_:GraphicContainer = null;
         var _loc8_:GraphicContainer = null;
         var _loc2_:Array = this.getBeriliaElement(param1.target as DisplayObject);
         for each(_loc8_ in _loc2_)
         {
            if(_loc8_ is UiRootContainer)
            {
               if(!_loc4_)
               {
                  _loc4_ = true;
                  StageShareManager.stage.addChild(this._highlightShape2);
                  _loc5_ = _loc8_.getBounds(StageShareManager.stage);
                  this._highlightShape2.graphics.clear();
                  this._highlightShape2.graphics.lineStyle(2,255,0.7);
                  this._highlightShape2.graphics.beginFill(255,0);
                  this._highlightShape2.graphics.drawRect(_loc5_.left,_loc5_.top,_loc5_.width,_loc5_.height);
                  this._highlightShape2.graphics.endFill();
                  this._uiRoot = _loc8_ as UiRootContainer;
               }
            }
            else if(!_loc3_)
            {
               this._lastTarget = _loc6_ = _loc8_;
               _loc3_ = true;
               StageShareManager.stage.addChild(this._highlightShape);
               _loc5_ = _loc8_.getBounds(StageShareManager.stage);
               this._highlightShape.graphics.clear();
               this._highlightShape.graphics.lineStyle(3,0,0.7);
               this._highlightShape.graphics.beginFill(16711680,0);
               this._highlightShape.graphics.drawRect(_loc5_.left,_loc5_.top,_loc5_.width,_loc5_.height);
               this._highlightShape.graphics.endFill();
            }
            else if(_loc8_ is Grid || _loc8_ is ComboBox)
            {
               _loc7_ = _loc8_;
               this._lastTarget = _loc8_;
            }
         }
         this.buildTooltip(_loc6_,_loc7_);
      }
      
      private function getBeriliaElement(param1:DisplayObject) : Array
      {
         var _loc2_:Array = [];
         while(param1 && !(param1 is Stage) && Boolean(param1.parent))
         {
            if(param1 is UiRootContainer || param1 is GraphicContainer)
            {
               _loc2_.push(param1);
            }
            param1 = param1.parent;
         }
         return _loc2_;
      }
      
      private function getGraphicContainerInfo(param1:GraphicContainer, param2:String, param3:String = "") : String
      {
         var _loc7_:BeriliaUiElementSound = null;
         var _loc4_:* = "";
         var _loc5_:String = "#0";
         if(param1.name.indexOf("instance") == 0)
         {
            _loc5_ = "#FF0000";
         }
         _loc4_ = param3 + "<font size=\'16\'><b>" + param2 + "</b></font><br/>";
         _loc4_ = _loc4_ + (param3 + "<b>Nom : </b><font color=\'" + _loc5_ + "\'>" + param1.name + "</font><br/>");
         _loc4_ = _loc4_ + (param3 + "<b>Type : </b>" + getQualifiedClassName(param1).split("::").pop() + "<br/>");
         var _loc6_:Vector.<BeriliaUiElementSound> = UiSoundManager.getInstance().getAllSoundUiElement(param1);
         _loc4_ += param3 + "<b>Sons : </b>" + (!!_loc6_.length ? "" : "Aucun") + "<br/>";
         if(_loc6_.length)
         {
            for each(_loc7_ in _loc6_)
            {
               _loc4_ += param3 + "&nbsp;&nbsp;&nbsp; - " + _loc7_.hook + " : " + _loc7_.file + "<br/>";
            }
         }
         return _loc4_;
      }
      
      private function buildTooltip(param1:GraphicContainer, param2:GraphicContainer) : void
      {
         var _loc3_:* = "";
         var _loc4_:* = "";
         var _loc5_:String = "";
         if(param2)
         {
            _loc3_ += this.getGraphicContainerInfo(param2,"Elément parent",_loc5_);
            _loc5_ = "&nbsp;&nbsp;&nbsp;";
         }
         if(param1)
         {
            _loc3_ += this.getGraphicContainerInfo(param1,"Elément",_loc5_);
            _loc4_ = "<br/>---------- AIDE ---------<br/>";
            _loc4_ = _loc4_ + "[Ctrl + c] : Copier ces informations<br/>";
            _loc4_ = _loc4_ + "[Ctrl + Shift + s] : Cmd son survol<br/>";
            _loc4_ = _loc4_ + "[Ctrl + Shift + c] : Cmd son clique<br/>";
            _loc4_ = _loc4_ + "[Ctrl + Shift + i] : Cmd inspecter element";
         }
         if(Boolean(this._uiRoot) && Boolean(this._uiRoot.uiData))
         {
            if(param1)
            {
               _loc3_ += "<br/>";
            }
            _loc3_ += "<font size=\'16\'><b>Interface</b></font><br/>";
            _loc3_ += "<b>Nom : </b>" + this._uiRoot.uiData.name + "<br/>";
            _loc3_ += "<b>Module : </b>" + this._uiRoot.uiData.module.id + "<br/>";
            _loc3_ += "<b>Script : </b>" + this._uiRoot.uiData.uiClassName + "<br/>";
         }
         _loc3_ += _loc4_;
         if(_loc3_.length)
         {
            this._tooltipTf.htmlText = _loc3_;
            this._tooltip.graphics.clear();
            this._tooltip.graphics.beginFill(16777215,0.9);
            this._tooltip.graphics.lineStyle(1,0,0.7);
            this._tooltip.graphics.drawRect(-5,-5,this._tooltipTf.width * 1.1 + 10,this._tooltipTf.textHeight * 1.1 + 10);
            this._tooltip.graphics.endFill();
            if(param1)
            {
               this._tooltip.x = StageShareManager.mouseX;
               this._tooltip.y = StageShareManager.mouseY - this._tooltip.height - 5;
               if(this._tooltip.y < 0)
               {
                  this._tooltip.y = 5;
               }
               if(this._tooltip.x + this._tooltip.width > StageShareManager.startWidth)
               {
                  this._tooltip.x += StageShareManager.startWidth - (this._tooltip.x + this._tooltip.width);
               }
            }
            else
            {
               this._tooltip.y = 0;
               this._tooltip.x = 0;
            }
            StageShareManager.stage.addChild(this._tooltip);
         }
      }
      
      private function onKeyUp(param1:KeyboardEvent) : void
      {
         if(param1.ctrlKey && param1.keyCode == Keyboard.C)
         {
            if(this._lastTarget)
            {
               if(!param1.shiftKey)
               {
                  Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,this._tooltipTf.text);
               }
               else
               {
                  Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,"/adduisoundelement " + this._lastTarget.getUi().uiData.name + " " + this._lastTarget.name + " onRelease [ID_SON]");
               }
            }
         }
         if(param1.ctrlKey && param1.keyCode == Keyboard.S)
         {
            if(this._lastTarget is Grid || this._lastTarget is ComboBox)
            {
               Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,"/adduisoundelement " + this._lastTarget.getUi().uiData.name + " " + this._lastTarget.name + " onItemRollOver [ID_SON]");
            }
            else
            {
               Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,"/adduisoundelement " + this._lastTarget.getUi().uiData.name + " " + this._lastTarget.name + " onRollOver [ID_SON]");
            }
         }
         if(param1.ctrlKey && param1.keyCode == Keyboard.I)
         {
            Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,"/inspectuielement " + this._lastTarget.getUi().uiData.name + " " + this._lastTarget.name);
            this.enable = false;
         }
      }
   }
}

