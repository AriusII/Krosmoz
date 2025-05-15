package com.ankamagames.dofus.logic.game.common.actions.roleplay
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class BasicSwitchModeAction implements Action
   {
      public var type:int;
      
      public function BasicSwitchModeAction()
      {
         super();
      }
      
      public static function create(param1:int) : BasicSwitchModeAction
      {
         var _loc2_:BasicSwitchModeAction = new BasicSwitchModeAction();
         _loc2_.type = param1;
         return _loc2_;
      }
   }
}

