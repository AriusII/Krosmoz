package com.ankamagames.dofus.console.chat
{
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.network.enums.PlayerLifeStatusEnum;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmotePlayRequestMessage;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   
   public class EmoteInstructionHandler implements ConsoleInstructionHandler
   {
      public function EmoteInstructionHandler()
      {
         super();
      }
      
      public function handle(param1:ConsoleHandler, param2:String, param3:Array) : void
      {
         var _loc5_:EmotePlayRequestMessage = null;
         var _loc4_:PlayedCharacterManager = PlayedCharacterManager.getInstance();
         if(_loc4_.state == PlayerLifeStatusEnum.STATUS_ALIVE_AND_KICKING && _loc4_.isRidding || _loc4_.isPetsMounting || _loc4_.infos.entityLook.bonesId == 1)
         {
            _loc5_ = new EmotePlayRequestMessage();
            _loc5_.initEmotePlayRequestMessage(this.getEmoteId(param2));
            ConnectionsHandler.getConnection().send(_loc5_);
         }
      }
      
      public function getHelp(param1:String) : String
      {
         return null;
      }
      
      private function getEmoteId(param1:String) : uint
      {
         var _loc2_:Emoticon = null;
         for each(_loc2_ in Emoticon.getEmoticons())
         {
            if(_loc2_.shortcut == param1)
            {
               return _loc2_.id;
            }
            if(_loc2_.defaultAnim == param1)
            {
               return _loc2_.id;
            }
         }
         return 0;
      }
      
      public function getParamPossibilities(param1:String, param2:uint = 0, param3:Array = null) : Array
      {
         return [];
      }
   }
}

