package com.ankamagames.dofus.logic.game.common.actions.craft
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class JobAllowMultiCraftRequestSetAction implements Action
   {
      public var isPublic:Boolean;
      
      public function JobAllowMultiCraftRequestSetAction()
      {
         super();
      }
      
      public static function create(param1:Boolean) : JobAllowMultiCraftRequestSetAction
      {
         var _loc2_:JobAllowMultiCraftRequestSetAction = new JobAllowMultiCraftRequestSetAction();
         _loc2_.isPublic = param1;
         return _loc2_;
      }
   }
}

