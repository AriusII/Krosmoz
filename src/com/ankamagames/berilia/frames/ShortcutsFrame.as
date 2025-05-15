package com.ankamagames.berilia.frames
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.managers.BindsManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.types.shortcut.Bind;
   import com.ankamagames.berilia.types.shortcut.Shortcut;
   import com.ankamagames.berilia.utils.BeriliaHookList;
   import com.ankamagames.jerakine.handlers.FocusHandler;
   import com.ankamagames.jerakine.handlers.messages.keyboard.KeyboardKeyDownMessage;
   import com.ankamagames.jerakine.handlers.messages.keyboard.KeyboardKeyUpMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.replay.KeyboardShortcut;
   import com.ankamagames.jerakine.replay.LogFrame;
   import com.ankamagames.jerakine.replay.LogTypeEnum;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.system.IME;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.ui.Keyboard;
   import flash.utils.getQualifiedClassName;
   
   public class ShortcutsFrame implements Frame
   {
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ShortcutsFrame));
      
      public static var shiftKey:Boolean = false;
      
      public static var ctrlKey:Boolean = false;
      
      public static var altKey:Boolean = false;
      
      public static var shortcutsEnabled:Boolean = true;
      
      private var _lastCtrlKey:Boolean = false;
      
      private var _isProcessingDirectInteraction:Boolean;
      
      public function ShortcutsFrame()
      {
         super();
      }
      
      public function get isProcessingDirectInteraction() : Boolean
      {
         return this._isProcessingDirectInteraction;
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:KeyboardKeyDownMessage = null;
         var _loc3_:KeyboardKeyUpMessage = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:* = false;
         var _loc8_:Bind = null;
         var _loc9_:Bind = null;
         var _loc10_:Shortcut = null;
         var _loc11_:TextField = null;
         var _loc12_:TextField = null;
         this._isProcessingDirectInteraction = false;
         if(!shortcutsEnabled)
         {
            return false;
         }
         switch(true)
         {
            case param1 is KeyboardKeyDownMessage:
               _loc2_ = KeyboardKeyDownMessage(param1);
               shiftKey = _loc2_.keyboardEvent.shiftKey;
               ctrlKey = _loc2_.keyboardEvent.ctrlKey;
               altKey = _loc2_.keyboardEvent.altKey;
               this._lastCtrlKey = false;
               return false;
            case param1 is KeyboardKeyUpMessage:
               _loc3_ = KeyboardKeyUpMessage(param1);
               shiftKey = _loc3_.keyboardEvent.shiftKey;
               ctrlKey = _loc3_.keyboardEvent.ctrlKey;
               altKey = _loc3_.keyboardEvent.altKey;
               _loc4_ = int(_loc3_.keyboardEvent.keyCode);
               if(_loc4_ == Keyboard.CONTROL)
               {
                  this._lastCtrlKey = true;
               }
               else if(this._lastCtrlKey)
               {
                  this._lastCtrlKey = false;
                  return false;
               }
               this._isProcessingDirectInteraction = true;
               if(_loc3_.keyboardEvent.shiftKey && _loc3_.keyboardEvent.keyCode == 52)
               {
                  _loc5_ = 39;
               }
               else if(_loc3_.keyboardEvent.shiftKey && _loc3_.keyboardEvent.keyCode == 54)
               {
                  _loc5_ = 45;
               }
               else
               {
                  _loc5_ = int(_loc3_.keyboardEvent.charCode);
               }
               _loc6_ = BindsManager.getInstance().getShortcutString(_loc3_.keyboardEvent.keyCode,_loc5_);
               if(FocusHandler.getInstance().getFocus() is TextField && Berilia.getInstance().useIME && IME.enabled)
               {
                  _loc11_ = FocusHandler.getInstance().getFocus() as TextField;
                  if(_loc11_.parent is Input)
                  {
                     _loc7_ = _loc11_.text != Input(_loc11_.parent).lastTextOnInput;
                     if(!_loc7_ && Input(_loc11_.parent).imeActive)
                     {
                        Input(_loc11_.parent).imeActive = false;
                        _loc7_ = true;
                     }
                     else
                     {
                        Input(_loc11_.parent).imeActive = _loc7_;
                     }
                  }
               }
               else
               {
                  IME.enabled = false;
               }
               if(_loc6_ == null || _loc7_)
               {
                  this._isProcessingDirectInteraction = false;
                  return true;
               }
               _loc8_ = new Bind(_loc6_,"",_loc3_.keyboardEvent.altKey,_loc3_.keyboardEvent.ctrlKey,_loc3_.keyboardEvent.shiftKey);
               _loc9_ = BindsManager.getInstance().getBind(_loc8_);
               if(_loc9_ != null)
               {
                  _loc10_ = Shortcut.getShortcutByName(_loc9_.targetedShortcut);
               }
               if(BindsManager.getInstance().canBind(_loc8_) && (_loc10_ != null && !_loc10_.disable || _loc10_ == null))
               {
                  KernelEventsManager.getInstance().processCallback(BeriliaHookList.KeyboardShortcut,_loc8_,_loc3_.keyboardEvent.keyCode);
               }
               if(_loc9_ != null && _loc10_ && !_loc10_.disable)
               {
                  if(!Shortcut.getShortcutByName(_loc9_.targetedShortcut))
                  {
                     break;
                  }
                  _loc12_ = StageShareManager.stage.focus as TextField;
                  if((Boolean(_loc12_)) && _loc12_.type == TextFieldType.INPUT)
                  {
                     if(!Shortcut.getShortcutByName(_loc9_.targetedShortcut).textfieldEnabled)
                     {
                        break;
                     }
                  }
                  LogFrame.log(LogTypeEnum.SHORTCUT,new com.ankamagames.jerakine.replay.KeyboardShortcut(_loc9_.targetedShortcut));
                  BindsManager.getInstance().processCallback(_loc9_,_loc9_.targetedShortcut);
               }
               this._isProcessingDirectInteraction = false;
               return false;
         }
         this._isProcessingDirectInteraction = false;
         return false;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
   }
}

