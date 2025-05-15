package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class OpenMapAction implements Action
   {
      public var conquest:Boolean;
      
      public function OpenMapAction()
      {
         super();
      }
      
      public static function create(param1:Boolean = false) : OpenMapAction
      {
         var _loc2_:OpenMapAction = new OpenMapAction();
         _loc2_.conquest = param1;
         return _loc2_;
      }
   }
}

