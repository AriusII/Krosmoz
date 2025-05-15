package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ShowMonstersInfoAction implements Action
   {
      public function ShowMonstersInfoAction()
      {
         super();
      }
      
      public static function create() : ShowMonstersInfoAction
      {
         return new ShowMonstersInfoAction();
      }
   }
}

